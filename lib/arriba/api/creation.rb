module Arriba
  class Api
    module Creation
      def mkdir(volume, path)
        volume.mkdir(path,name)
        { :added => volume.tree( ::File.join(path,name) ) }
      end
      
      def mkfile(volume, path)
        volume.mkfile(path,name)
        { :added => [ volume.file(path,name) ] }
      end
    end
  end
end
