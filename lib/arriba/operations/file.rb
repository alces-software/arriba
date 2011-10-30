require 'arriba/operations/base'

module Arriba
  module Operations
    module File
      include Arriba::Operations::Base

      # Fulfilling Arriba::Operations::Base contract
      def tree(path)
        # path is a directory
        # find directory children
        [cwd(path)] + entries(path).map {|f| file(path,f) if directory?(path,f)}.compact
      end

      # Fulfilling Arriba::Operations::Base contract
      def entries(path)
        # XXX - limit - also file sizes for previews, and downloads etc.
        Dir.entries(abs(path)) - ['.','..']
      end

      def mkdir(path,newdir) 
        FileUtils.mkdir(abs(path,newdir)) && true
      end

      def mkfile(path,newfile)
        FileUtils.touch(abs(path,newfile)) && true
      end

      # XXX - recursive delete of subdirectories? Too dangerous?
      def rm(path)
        if directory?(path)
          Dir::rmdir(abs(path)) && true
        else
          FileUtils::rm(abs(path)) && true
        end
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
        # strip off leading '/'
        paths = paths.map{|p|p[1..-1]} 
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
        ::File.writable?(abs(path))
      end

      def children?(path)
        directory?(path) && entries(path).find {|f| directory?(path,f)}
      rescue Errno::EACCES
        false
      end

      def date(path)
        stat(path).mtime
      end

      def size(path)
        stat(path).size
      end

      def stat(path)
        ::File.lstat(abs(path))
      end

      def mimetype(path)
        if directory?(path)
          'directory'
        elsif symlink?(path) 
          exists?(path) ? 'symlink' : 'symlink-broken'
        else
          # gsub to prune leading '.' character
          ext = ::File.extname(path).gsub(/^\./,'')
          Arriba::MimeType::for(ext) || read_mimetype(path)
        end
      end

      def io(path)
        ::File.new(abs(path))
      end

      private
      def read_mimetype(path)
        begin
          # this only works with file v5+ but RHEL5 only ships with file v4. sigh.
          #        reader = ['/usr/bin/file','--mime-type','-b',abs(path)]
          #        IO.popen(reader) { |io| io.read }.chomp
          # File.absolute_path is ruby 1.9 only....
          reader = ['/usr/bin/file','-m',::File.absolute_path('../../../../etc/magic',__FILE__),'--mime','-b',abs(path)]
          IO.popen(reader) { |io| io.read }.chomp.split(';').first
        rescue
          'unknown/unknown'
        end
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
