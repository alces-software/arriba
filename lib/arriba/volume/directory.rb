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

    # Tries to return the location within this volume, or nil
    def rel_path_to(path)
      expanded_path = ::File.expand_path(path)
      expanded_root = ::File.expand_path(root)
      if m = /^#{expanded_root}(?<rel_path>\/.*)?$/.match(expanded_path)
        m[:rel_path] || '/'
      else
        nil
      end
    end
  end
end
