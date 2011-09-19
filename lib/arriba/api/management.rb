module Arriba
  class Api
    module Management
      def rename
        result = volume.rename(path,params[:name])
        if result == true
          { 
            :added => [volume.file(volume.dirname(path),params[:name])],
            :removed => [volume.hash_for(path)]
          }
        else
          { :error => result }
        end
      end

      def file
        ## download a remote file
        filename = volume.name_for(path)
        mimetype = volume.mimetype(path)
        Arriba::FileResponse.new(volume.io(path), 
                                 filename,
                                 mimetype,
                                 disposition_for(mimetype))
      end
      
      def get
        ## get contents of a file
        {:content => volume.read(path)}
      end

      def put
        ## write contents to a file
        result = volume.write(path,params[:content])
        if result == true
          { :changed => [volume.file(path)] }
        else
          { :error => result }
        end
      end

      private
      def inlineable?(mimetype)
        # if this is an image or text or (fsr) flash file, we allow
        # display inline
        mimetype =~ /^image|text\//i || 
          mimetype == 'application/x-shockwave-flash'
      end

      def disposition_for(mimetype)
        if params[:download] == '0' && inlineable?(mimetype)
          "inline"
        else
          "attachment" 
        end
      end
    end
  end
end
