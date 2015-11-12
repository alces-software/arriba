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
require 'base64'

module Arriba
  module Routing
    class << self
      def encode(pathname)
        # while it breaks the spec, '=' padding is removed to keep the
        # elfinder client happy :-/
        Base64.encode64(pathname).chomp.tr("\n", "_").gsub('=','')
      end
      
      def decode(hash)
        # repad the data with appropriate '=' padding
        hash += '=' * (4 - (hash.length % 4))
        Base64.decode64(hash.tr("_", "\n"))
      end

      def route(target)
        # XXX - ruby 1.9
        m = target.match(/^(?<volume>.*?)_(?<path>.*)$/)
        # STDERR.puts "routed vol: #{m[:volume]}, routed path: #{m[:path]}, decoded path: #{decode(m[:path])}"
        [m[:volume],decode(m[:path])]
      end
    end
  end
end
