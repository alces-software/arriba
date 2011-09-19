module Arriba
  class Api
    module Creation
      def mkdir
        result = volume.mkdir(path,params[:name])
        if result == true
          { :added => volume.tree(File.join(path,params[:name])) }
        else
          { :error => result }
        end
      end
      
      def mkfile
        result = volume.mkfile(path,params[:name])
        if result == true
          { :added => [volume.file(path,params[:name])] }
        else
          { :error => result }
        end
      end
    end
  end
end
