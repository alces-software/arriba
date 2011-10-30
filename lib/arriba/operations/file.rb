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

      def copy(src_path,dest_path)
        FileUtils.cp_r(abs(src_path),abs(dest_path))
        true
      end

      def move(src_path,dest_path)
        FileUtils.mv(abs(src_path),abs(dest_path))
        true
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
