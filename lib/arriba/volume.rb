module Arriba
  class Volume
    attr_accessor :id
    def initialize(id)
      self.id = id
    end

    def hash_for(path)
      "#{self.id}_#{Arriba::Routing::encode(path)}"
    end
  end
end
