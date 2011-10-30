module Arriba
  class Volume::Directory < Volume
    include Arriba::Operations::File

    attr_accessor :name

    def initialize(root, name = nil, id = nil)
      name ||= root
      id ||= Arriba::Routing::encode(name)
      super(id)
      self.name = name
      self.root = root
    end

    def shortcut?(dest_vol)
      # can always shortcut if we're only operating within the scope
      # of the local filesystem.      
      dest_vol.is_a?(Arriba::Volume::Directory)
    end
  end
end
