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
    module Duplication
      def duplicate
        each_target(:added) do |v,p|
          v.duplicate(p)
          v.file(v.dirname(p),v.duplicate_name_for(p))
        end
      end
      
      def paste
        cut? ? cut : copy
      end

      private
      def copy
        each_target_with_destination(:added) do |src_vol, src_path, dest_vol, dest_path|
          if src_vol == dest_vol
            src_vol.copy(src_path,dest_path)
          elsif src_vol.shortcut?(dest_vol)
            src_vol.copy(src_vol.abs(src_path),dest_vol.abs(dest_path), true)
          else
            raise "Unable to copy across volumes"
          end
          dest_vol.file(dest_path, dest_vol.name_for(src_path))
        end
      end

      def cut
        removed = []
        each_target_with_destination(:added) do |src_vol, src_path, dest_vol, dest_path|
          if src_vol == dest_vol
            src_vol.move(src_path,dest_path)
          elsif src_vol.shortcut?(dest_vol)
            src_vol.move(src_vol.abs(src_path),dest_vol.abs(dest_path), true)
          else
            # XXX - should combine the error with :removed
            raise "Unable to move across volumes"
          end
          removed << src_vol.hash_for(src_path)
          dest_vol.file(dest_path,dest_vol.name_for(src_path))
        end.tap do |data|
          data[:removed] = removed if removed.any?
        end    
      end

      def cut?
        flagged?(:cut)
      end
    end
  end
end
