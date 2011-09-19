module Arriba
  class File
    delegate :encode, :to => Arriba::Routing
    attr_accessor :volume, :path

    def initialize(volume,path)
      self.volume = volume
      self.path = path
    end

    # The usages of ::File within the class are safe as they are used only for string manipulation
    def basename
      ::File.basename(path)
    end

    def dirname
      f = ::File.dirname(path)
      f == '.' ? '/' : f
    end

    def readable?
      volume.readable?(path)
    end

    def writable?
      volume.writable?(path)
    end

    def locked?
      volume.locked?(path)
    end

    def children?
      volume.children?(path)
    end

    def date
      stat.mtime
    end

    def size
      stat.size
    end

    def stat
      @stat ||= volume.stat(path)
    end

    def mimetype
      volume.mimetype(path)
    end

    def to_hash
      {
        'name' => basename,
        'hash' => "#{volume.id}_#{encode(path)}",
        'phash' => "#{volume.id}_#{encode(dirname)}",
        'date' => date,
        'mime' => mimetype,
        'size' => size,
        'dirs' => children? ? 1 : 0,
        'locked' => locked? ? 1 : 0,
        'read' => readable? ? 1 : 0,
        'write' => writable? ? 1 : 0
      }
    end
  end
end
