#==============================================================================
# Copyright (C) 2007-2015 Stephen F. Norledge and Alces Software Ltd.
#
# This file/package is part of Alces Arriba.
#
# Alces Arriba is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# Alces Arriba is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this package.  If not, see <http://www.gnu.org/licenses/>.
#
# For more information on Alces Arriba, please visit:
# https://github.com/alces-software/arriba
#==============================================================================
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

    def exists?
      volume.exists?(path)
    end

    def abs_symlink_target
      volume.abs_symlink_target(path)
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

    def resolve_symlink(target_volume, target_rel_path)
      if @hash && exists? && target_volume
        @hash['alias'] = target_volume.name + target_rel_path
        @hash['thash'] = "#{target_volume.id}_#{encode(target_rel_path)}"
        @hash['size'] = target_volume.size(target_rel_path)
      end
    end
  end
end
