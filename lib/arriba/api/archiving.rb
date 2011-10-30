module Arriba
  class Api
    module Archiving
      def archive
        # accepts a targets[] array
        paths = []
        ts = params[:targets] 
        v, _ = Arriba::Routing::route(ts.first)
        v = volumes.find{|vol| vol.id == v}
        paths = ts.map do |t|
          (_, p = Arriba::Routing::route(t)) && p
        end
        archive = v.archive(mimetype, paths)       
        {:added => [v.file(archive)]}
      end

      def extract(volume, path)
        out_dir = volume.extract(path)
        {:added => [volume.file(out_dir)]}
      end
    end
  end
end
