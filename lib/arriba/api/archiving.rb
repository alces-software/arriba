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
    module Archiving
      def archive
        # accepts a targets[] array
        paths = []
        ts = params[:targets] 
        v, _ = Arriba::Routing::route(ts.first)
        v = volumes.find{|vol| vol.id == v}
        paths = ts.map do |t|
          (_, p = Arriba::Routing::route(t)) && p
        end
        archive = v.archive(mimetype, paths)       
        {:added => [v.file(archive)]}
      end

      def extract(volume, path)
        out_dir = volume.extract(path)
        {:added => [volume.file(out_dir)]}
      end
    end
  end
end
