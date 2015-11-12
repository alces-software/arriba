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
  class Volume::Directory < Volume
    include Arriba::Operations::File

    attr_accessor :name, :root

    def initialize(root, name = nil, id = nil)
      name ||= root
      id ||= Arriba::Routing::encode(name)
      super(id)
      self.name = name
      self.root = root
    end

    def shortcut?(dest_vol)
      # can always shortcut if we're only operating within the scope
      # of the local filesystem.      
      dest_vol.is_a?(Arriba::Volume::Directory)
    end
  end
end
