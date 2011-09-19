require 'arriba/version'

require 'arriba/routing'
require 'arriba/mime_type'
require 'arriba/file'
require 'arriba/root'
require 'arriba/volume'
require 'arriba/volume/directory'

if Object.const_defined?(:ARRIBA_PATH)
  load File.join(ARRIBA_PATH,'arriba','routing.rb')
  load File.join(ARRIBA_PATH,'arriba','mime_type.rb')
  load File.join(ARRIBA_PATH,'arriba','file.rb')
  load File.join(ARRIBA_PATH,'arriba','root.rb')
  load File.join(ARRIBA_PATH,'arriba','volume.rb')
  load File.join(ARRIBA_PATH,'arriba','volume','directory.rb')
end
