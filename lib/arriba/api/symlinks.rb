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
module Arriba
  class Api
    module Symlinks
      def open(*args)
        resolve_symlinks(super)
      end

      private
      def resolve_symlinks(data)
        resolver = lambda do |obj|
          case obj
          when Array
            obj.each(&resolver)
          when Hash
            obj.each_value(&resolver)
          when Arriba::File
            if obj.symlink?
              target = obj.abs_symlink_target
              target_volume, target_rel_path = volume_relpath_for(target)
              obj.resolve_symlink(target_volume, target_rel_path)
            end
          end
        end
        resolver.call(data)
      end

      # Returns the first volume that 'contains' the specified path, or nil
      def volume_relpath_for(path)
        rel_path = nil
        vol = volumes.find { |vol| rel_path = vol.rel_path_to(path) }
        [vol, rel_path]
      end
    end
  end
end
