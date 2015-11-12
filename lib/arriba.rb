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
require 'arriba/version'

require 'arriba/api'
require 'arriba/routing'
require 'arriba/mime_type'
require 'arriba/file'
require 'arriba/file_response'
require 'arriba/root'
require 'arriba/operations/base'
require 'arriba/operations/file'
require 'arriba/volume'
require 'arriba/volume/directory'
require 'arriba/target'
require 'arriba/target/base'
require 'arriba/target/local'

module Arriba
  module Base
    def execute(volumes,params)
      cmd = params[:cmd]
      if cmd.present?
        Arriba::Api::run(cmd,volumes,params)
      else
        raise "No operation supplied!"
      end
    rescue      
      STDERR.puts $!.backtrace
      {:error => $!.message}
    end
  end
  extend Arriba::Base
end
