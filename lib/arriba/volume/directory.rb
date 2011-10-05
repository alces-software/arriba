module Arriba
  class Volume::Directory < Volume
    include Arriba::Operations::File

    def initialize(root, name = nil, id = nil)
      name ||= root
      id ||= Arriba::Routing::encode(name)
      super(id)
      self.name = name
      self.root = root
    end
  end
end
