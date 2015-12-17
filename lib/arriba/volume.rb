module Arriba
  class Volume
    attr_accessor :id
    def initialize(id)
      self.id = id
    end

    def hash_for(path)
      "#{self.id}_#{Arriba::Routing::encode(path)}"
    end

    def shortcut?
      false
    end

    def options
      {} # Extension point for overriding default options
    end
  end
end
