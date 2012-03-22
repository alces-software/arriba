require 'arriba/operations/base'

module Arriba
  module Operations
    module File
      include Arriba::Operations::Base

      # RHEL5 ships with file v4
      FILE_VERSION = begin
                       version = IO.popen('/usr/bin/file --version 2>&1') { |io| io.readline.chomp }
                       version =~ /file-4/ && :legacy || :modern
                     rescue
                       :modern
                     end

      FILE_IO_HANDLER = if FILE_VERSION == :legacy
                          lambda { |io| io.read.chomp.split(';').first }
                        else
                          lambda { |io| io.read.chomp }
                        end

      FILE_COMMAND = if FILE_VERSION == :legacy
                       # File.absolute_path is ruby 1.9 only....
                       ['/usr/bin/file','-m',::File.absolute_path('../../../../etc/magic',__FILE__),'--mime','-b']
                     else
                       # this only works with file v5+
                       ['/usr/bin/file','--mime-type','-b']
                     end

      # Fulfilling Arriba::Operations::Base contract
      def tree(path)
        # path is a directory
        # find directory children
        [cwd(path)] + entries(path).map {|f| file(path,f) if directory?(path,f)}.compact
      end

      # Fulfilling Arriba::Operations::Base contract
      def entries(path)
        # XXX - limit - also file sizes for previews, and downloads etc.
#        Dir.entries(abs(path)) - ['.','..']
        Dir.entries(abs(path)).reject{|s|s[0..0] == '.'}
      end

      def mkdir(path,newdir) 
        FileUtils.mkdir(abs(path,newdir)) && true
      end

      def mkfile(path,newfile)
        FileUtils.touch(abs(path,newfile)) && true
      end

      # XXX - recursive delete of subdirectories? Too dangerous?
      def rm(path)
#         if directory?(path)
#           Dir::rmdir(abs(path)) && true
#         else
#           FileUtils::rm(abs(path)) && true
#         end
        FileUtils::rm_rf(abs(path)) && true
      end

      def dirname(path)
        ::File.dirname(path)
      end

      def rename(path,newfile)
        FileUtils.mv(abs(path),abs(dirname(path),newfile)) && true
      end

      def duplicate_name_for(path)
        "Copy of #{::File.basename(path)}"
      end

      def duplicate(path)
        FileUtils.cp_r(abs(path),abs(dirname(path),duplicate_name_for(path)))
        true
      end

      def copy(src_path,dest_path,shortcut = false)
        if !shortcut
          src_path = abs(src_path)
          dest_path = abs(dest_path)
        end
        FileUtils.cp_r(src_path,dest_path)
        true
      end

      def move(src_path,dest_path,shortcut = false)
        if !shortcut
          src_path = abs(src_path)
          dest_path = abs(dest_path)
        end
        FileUtils.mv(src_path,dest_path)
        true
      end

      def archive_name_for(dir, basename, ext)
        arch_name = "#{basename}.#{ext}"
        if exists?(::File.join(dir,arch_name))
          idx = 0
          while exists?(::File.join(dir,arch_name))
            arch_name = "#{basename}.#{idx += 1}.#{ext}"
          end
        end
        arch_name
      end

      def archive(mimetype, paths)
        dir = ::File.dirname(paths.first)
        if paths.length > 1
          basename = 'Archive'
        else
          basename = ::File.basename(paths.first)
        end
        # strip off leading directory path
        paths = paths.map{|p|p.gsub(/^#{dir}\//,'')} 
        # XXX - assumes 'tar' and 'zip' are in the PATH
        cmd = case mimetype
              when 'application/x-tar'
                archive_name = archive_name_for(dir, basename, 'tar')
                ['tar','-cf',archive_name,*paths]
              when 'application/x-gzip'
                archive_name = archive_name_for(dir, basename, 'tar.gz')
                ['tar','-czf',archive_name,*paths]
              when 'application/x-bzip2'
                archive_name = archive_name_for(dir, basename, 'tar.bz2')
                ['tar','-cjf',archive_name,*paths]
              when 'application/zip'
                archive_name = archive_name_for(dir, basename, 'zip')
                ['zip','-qr',archive_name,*paths]
              else
                Kernel::raise "Unknown archive format: #{mimetype}"
              end
        cmd << {:chdir => abs(dir)}
        IO.popen(cmd) {|io| io.read }.tap do |r|
          STDERR.puts "Command was: #{cmd.inspect}"
          STDERR.puts "Archive command yielded: #{r.inspect}"
        end
        ::File.join(dir,archive_name)
      end

      def extract(path)
        dir = ::File.dirname(path)
        basename = ::File.basename(path)
        out_dir = archive_name_for(dir, basename, 'extracted')
        type = mimetype(path)
        cmd = case type
              when 'application/x-tar'
                ['tar','-xSf',abs(path),'-C',out_dir]
              when 'application/x-gzip'
                ['tar','-xSzf',abs(path),'-C',out_dir]
              when 'application/x-bzip2'
                ['tar','-xSjf',abs(path),'-C',out_dir]
              when 'application/zip'
                ['unzip','-qn',abs(path),'-d',out_dir]
              else
                Kernel::raise "Unknown archive format: #{type}"
              end
        cmd << {:chdir => abs(dir)}
        mkdir(dir,out_dir)
        IO.popen(cmd) {|io| io.read }.tap do |r|
          STDERR.puts "Command was: #{cmd.inspect}"
          STDERR.puts "Archive command yielded: #{r.inspect}"
        end
        ::File.join(dir,out_dir)
      end

      def read(path)
        ::File.read(abs(path))
      end

      def write(path,content)
        ::File.open(abs(path),'w') do |io|
          io.print(content)
        end
        true
      end

      def name_for(path)
        ::File.basename(path)
      end

      def readable?(path)
        ::File.readable?(abs(path))
      end

      def writable?(path)
        readable?(path) && ::File.writable?(abs(path))
      end

      def user(path)
        uid = stat(path).uid
        {:id => uid}.tap do |h|
          name = (Etc.getpwuid(uid).name rescue nil)
          h[:name] = name unless name.nil?
        end
      end

      def group(path)
        gid = stat(path).gid
        {:id => gid}.tap do |h|
          name = (Etc.getgrgid(gid).name rescue nil)
          h[:name] = name unless name.nil?
        end
      end

      def mode(path)
        stat(path).mode
      end

      def ctime(path)
        stat(path).ctime
      end

      def atime(path)
        stat(path).atime
      end

      def mtime(path)
        stat(path).mtime
      end

      def children?(path)
        directory?(path) && entries(path).find {|f| directory?(path,f)}
      rescue Errno::EACCES
        false
      end

      def date(path)
        mtime(path)
      end

      def size(path)
        stat(path).size
      end

      def mimetype(path)
        if directory?(path)
          'directory'
        elsif symlink?(path) 
          exists?(path) ? 'symlink' : 'symlink-broken'
        else
          # gsub to prune leading '.' character
          ext = ::File.extname(path).gsub(/^\./,'')
          Arriba::MimeType::for(ext) || (readable?(path) ? read_mimetype(path) : 'unknown')
        end
      end

      def io(path)
        ::File.new(abs(path))
      end

      private
      def stat(path)
        ::File.lstat(abs(path))
      end

      def read_mimetype(path)
        IO.popen(FILE_COMMAND + [abs(path)], &FILE_IO_HANDLER)
      rescue
        'unknown'
      end

      def directory?(*args)
        f = abs(*args)
        !::File.symlink?(f) && ::File.directory?(f)
      end

      def symlink?(path)
        ::File.symlink?(abs(path))
      end

      def exists?(path)
        ::File.exists?(abs(path))
      end
    end
  end
end
