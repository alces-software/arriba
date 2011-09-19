module Arriba
  class Root < File
    attr_accessor :name
    def initialize(volume, name)
      super(volume, '/')
      self.name = name
    end

    def to_hash
      super.tap do |h|
        h.merge!(
                 'name' => name,
                 'phash' => '',
                 'volumeid' => "#{volume.id}_"
                 )
      end
    end
  end
end
