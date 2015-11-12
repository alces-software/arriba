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
require 'active_support/core_ext/object/inclusion'

module Arriba
  module Operations
    module Base
      attr_accessor :name, :root
      private :name=, :root=, :name, :root

      # module that mix in must define: #entries(path) and #tree(path)
      # in order to support #files, #ls and #parents.
      
      def files(path)
        [cwd(path)] + entries(path).map {|f| file(path,f) }
      rescue Errno::EACCES
        [cwd(path)]
      end

      def ls(path)
        entries(path)
      end

      def parents(path)
        # path is a directory
        # find siblings of path and siblings of parents
        parent = ::File.dirname(path)
        tree(parent).tap { |d| d += parents(parent) unless parent.in?(['.','/']) }
      end
      
      def cwd(path)
        if path.in?(['.','/'])
          base
        else
          represent(path)
        end
      end

      def file(path,f = nil)
        relative_path = f.nil? ? path : ::File.join(path,f)
        represent(relative_path)
      end

      def locked?(path)
        false
      end

      protected
      def abs(*args)
        ::File.join(root,*args)
      end

      private
      def volume
        self
      end

      def represent(path)
        Arriba::File.new(volume, path)
      end

      def base
        Arriba::Root.new(volume,name)
      end
    end
  end
end
