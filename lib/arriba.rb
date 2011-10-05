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
# XXX - move these out to an extension gem
require 'arriba/volume/irods'
require 'arriba/volume/polymorph_directory'

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

if Object.const_defined?(:ARRIBA_PATH)
  load File.join(ARRIBA_PATH,'arriba','api','structures.rb')
  load File.join(ARRIBA_PATH,'arriba','api','management.rb')
  load File.join(ARRIBA_PATH,'arriba','api','creation.rb')
  load File.join(ARRIBA_PATH,'arriba','api','deletion.rb')
  load File.join(ARRIBA_PATH,'arriba','api','duplication.rb')
  load File.join(ARRIBA_PATH,'arriba','api','base.rb')
  load File.join(ARRIBA_PATH,'arriba','api.rb')
  load File.join(ARRIBA_PATH,'arriba','routing.rb')
  load File.join(ARRIBA_PATH,'arriba','mime_type.rb')
  load File.join(ARRIBA_PATH,'arriba','file.rb')
  load File.join(ARRIBA_PATH,'arriba','file_response.rb')
  load File.join(ARRIBA_PATH,'arriba','root.rb')
  load File.join(ARRIBA_PATH,'arriba','volume.rb')
  load File.join(ARRIBA_PATH,'arriba','volume','directory.rb')
end
