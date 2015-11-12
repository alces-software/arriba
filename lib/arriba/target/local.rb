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
  module Target
    class Local < Arriba::Target::Base
      def file_for(path)
        LocalFile.new(::File.join(dir,path))
      end

      def to_volume
        Arriba::Volume::Directory.new(dir, name)
      end

      class LocalFile < Struct.new(:path)
        def read_open
          ::File.open(path,'rb')
        end
        def open
          ::File.open(path,'wb')
        end
      end
    end
  end
end
