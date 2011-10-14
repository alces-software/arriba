module Arriba
  class Api
    module Management
      def rename(volume, path)
        volume.rename(path,name)
        { 
          :added => [volume.file(volume.dirname(path),name)],
          :removed => [volume.hash_for(path)]
        }
      end

      def file(volume, path)
        ## download a remote file
        filename = volume.name_for(path)
        mimetype = volume.mimetype(path)
        Arriba::FileResponse.new(volume.io(path), 
                                 filename,
                                 mimetype,
                                 disposition_for(mimetype),
                                 volume.size(path))
      end
      
      def get(volume, path)
        ## get contents of a file
        {:content => volume.read(path)}
      end

      def put(volume, path)
        ## write contents to a file
        volume.write(path,params[:content])
        { :changed => [volume.file(path)] }
      end

      private
      def inlineable?(mimetype)
        # if this is an image or text or (fsr) flash file, we allow
        # display inline
        mimetype =~ /^(image|text)\//i || 
          mimetype == 'application/pdf' || 
          mimetype == 'application/x-shockwave-flash'
      end

      def disposition_for(mimetype)
#        if params[:download] == '0' && inlineable?(mimetype)
        if params[:download] != '1' && inlineable?(mimetype)
          "inline"
        else
          "attachment" 
        end
      end
    end
  end
end
