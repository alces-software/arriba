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
