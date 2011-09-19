require 'arriba/version'

require 'arriba/api'
require 'arriba/routing'
require 'arriba/mime_type'
require 'arriba/file'
require 'arriba/root'
require 'arriba/volume'
require 'arriba/volume/directory'

module Arriba
  class << self
    def execute(volumes,params)
      cmd = params[:cmd]
      data = if cmd.present? && Arriba::Api.method_defined?(cmd)
               Arriba::Api.new(volumes,params).send(cmd)
             else
               {:error => "Unsupported operation: #{cmd}"}
             end
    end
  end
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
  load File.join(ARRIBA_PATH,'arriba','root.rb')
  load File.join(ARRIBA_PATH,'arriba','volume.rb')
  load File.join(ARRIBA_PATH,'arriba','volume','directory.rb')
end
