require 'active_support/core_ext/module/delegation'

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

    def symlink?
      volume.symlink?(path)
    end

    def symlink_target
      volume.symlink_target(path)
    end

    def date
      mtime
    end

    def size
      volume.size(path)
    end

    def mimetype
      volume.mimetype(path)
    end

    def mtime
      volume.mtime(path)
    end

    def ctime
      volume.ctime(path)
    end

    def atime
      volume.atime(path)
    end

    def user
      volume.user(path)
    end

    def group
      volume.group(path)
    end

    def mode
      volume.mode(path)
    end

    def to_hash
      @hash ||= {
        'name' => basename,
        'hash' => "#{volume.id}_#{encode(path)}",
        'phash' => "#{volume.id}_#{encode(dirname)}",
        'date' => mtime,
        'mime' => mimetype,
        'alias' => symlink? ? symlink_target : nil,
        'thash' => symlink? ? "#{volume.id}_#{encode(symlink_target)}": nil,
        'size' => size,
        'dirs' => children? ? 1 : 0,
        'locked' => locked? ? 1 : 0,
        'read' => readable? ? 1 : 0,
        'write' => writable? ? 1 : 0,
        'user' => user,
        'group' => group,
        'atime' => atime,
        'mtime' => mtime,
        'ctime' => ctime,
        'mode' => mode
      }
    end
  end
end
