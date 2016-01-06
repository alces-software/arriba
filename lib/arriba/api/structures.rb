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
    module Structures
      def open(volume, path)
        if volume.nil?
          volume = volumes.first
          path = '/'
        end
        { :options => options(volume) }.tap do |data|
          cwd_thread = Thread.new { Thread.current[:cwd] = volume.cwd(path) }
          if init?
            files = volumes.map do |vol|
              Thread.new { Thread.current[:files] = vol.files('/') }
            end.map { |t| t.join && t[:files] }.flatten
            files += ( path == '/' ? [] : volume.files(path) )
            data.merge!({
                          :api => '2.0',
                          :uplMaxSize => 0
                        })
          else
            files = volume.files(path)
          end
          cwd_thread.join
          data.merge!(:files => files, :cwd => cwd_thread[:cwd])
        end
      end
      
      def tree(volume, path)
        { :tree => volume.tree(path) }
      end
      
      # find directory siblings and all parent directories up to the root
      def parents(volume, path)
        { :tree => volume.parents(path) }
      end
      
      def ls(volume, path)
        { :list => volume.ls(path) }
      end
    end
  end
end
