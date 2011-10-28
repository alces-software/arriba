module Arriba
  module Target
    class Local < Arriba::Target::Base
      def file_for(path)
        LocalFile.new(::File.join(dir,path))
      end

      def to_volume
        Arriba::Volume::Directory.new(dir, name)
      end

      class LocalFile < Struct.new(:path)
        def read_open
          ::File.open(path,'rb')
        end
        def open
          ::File.open(path,'wb')
        end
      end
    end
  end
end
