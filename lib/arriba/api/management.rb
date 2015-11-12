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
    module Management
      def rename(volume, path)
        volume.rename(path,name)
        { 
          :added => [volume.file(volume.dirname(path),name)],
          :removed => [volume.hash_for(path)]
        }
      end

      def file(volume, path)
        ## download a remote file
        filename = volume.name_for(path)

        if volume.symlink?(path)
          target = volume.abs_symlink_target(path)
          volume, path = volume_relpath_for(target)
        end

        mimetype = volume.mimetype(path)
        Arriba::FileResponse.new(volume.io(path), 
                                 filename,
                                 mimetype,
                                 disposition_for(mimetype),
                                 volume.size(path))
      end
      
      def get(volume, path)
        ## get contents of a file
        {:content => volume.read(path)}
      end

      def put(volume, path)
        ## write contents to a file
        volume.write(path,params[:content])
        { :changed => [volume.file(path)] }
      end

      private
      def inlineable?(mimetype)
        # if this is an image or text or (fsr) flash file, we allow
        # display inline
        mimetype =~ /^(image|text)\//i || 
          mimetype == 'application/pdf' || 
          mimetype == 'application/x-shockwave-flash'
      end

      def disposition_for(mimetype)
#        if params[:download] == '0' && inlineable?(mimetype)
        if params[:download] != '1' && inlineable?(mimetype)
          "inline"
        else
          "attachment" 
        end
      end
    end
  end
end
