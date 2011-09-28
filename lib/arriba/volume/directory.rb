module Arriba
  class Volume::Directory < Volume
    attr_accessor :root, :name, :id
    def initialize(root, name = nil, id = nil)
      self.root = root
      self.name = name || self.root
      self.id = id || Arriba::Routing::encode(self.name)
    end

    def cwd(path)
      if path.in?(['.','/'])
        base
      else
        Arriba::File.new(self, path)
      end
    end

    def file(path,f = nil)
      relative_path = f.nil? ? path : ::File.join(path,f)
      Arriba::File.new(self, relative_path)
    end

    def files(path)
      [cwd(path)] + entries(path).map {|f| file(path,f) }
    rescue Errno::EACCES
      [cwd(path)]
    end

    def parents(path)
      # path is a directory
      # find siblings of path and siblings of parents
      parent = ::File.dirname(path)
      tree(parent).tap { |d| d += parents(parent) unless parent.in?(['.','/']) }
    end
    
    def tree(path)
      # path is a directory
      # find directory children
      [cwd(path)] + entries(path).map {|f| file(path,f) if directory?(path,f)}.compact
    end

    def mkdir(path,newdir)
      FileUtils.mkdir(abs(path,newdir)) && true
    end

    def mkfile(path,newfile)
      FileUtils.touch(abs(path,newfile)) && true
    end

    def rm(path)
      if directory?(path)
        Dir::rmdir(abs(path)) && true
      else
        FileUtils::rm(abs(path)) && true
      end
    end

    def rename(path,newfile)
      FileUtils.mv(abs(path),abs(dirname(path),newfile)) && true
    end

    def duplicate(path)
      FileUtils.cp_r(abs(path),abs(dirname(path),duplicate_name_for(path)))
      true
    end

    def copy(src_path,dest_vol,dest_path)
      unless Directory === dest_vol
        raise "Direct copy not available across incompatible volumes"
      end
      FileUtils.cp_r(abs(src_path),dest_vol.abs(dest_path))
      true
    end

    def move(src_path,dest_vol,dest_path)
      unless Directory === dest_vol
        raise "Direct move not available across incompatible volumes"
      end
      FileUtils.mv(abs(src_path),dest_vol.abs(dest_path))
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

    def ls(path)
      entries(path)
    end

    def duplicate_name_for(path)
      "Copy of #{::File.basename(path)}"
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

    def locked?(path)
      false
    end

    def children?(path)
      directory?(path) && entries(path).find {|f| directory?(path,f)}
    rescue Errno::EACCES
      false
    end

    def dirname(path)
      ::File.dirname(path)
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

    def hash_for(path)
      "#{self.id}_#{Arriba::Routing::encode(path)}"
    end

    def io(path)
      ::File.new(abs(path))
    end

    protected
    def abs(*args)
      ::File.join(root,*args)
    end

    private
    def read_mimetype(path)
      begin
# this only works with file v5+ but RHEL5 only ships with file v4. sigh.
#        reader = ['/usr/bin/file','--mime-type','-b',abs(path)]
#        IO.popen(reader) { |io| io.read }.chomp
        reader = ['/usr/bin/file','--mime','-b',abs(path)]
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

    def entries(path)
      Dir.entries(abs(path)) - ['.','..']
    end

    def base
      Arriba::Root.new(self,name)
    end
  end
end
