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
        disp = if params[:download] == '0' && mimetype =~ /^image|text\//i || mimetype == 'application/x-shockwave-flash'
                 # if this is an image or text or (fsr) flash file, we allow display inline
                 "inline"
               else
                 "attachment" 
               end
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          headers['Pragma'] = 'public'
          headers["Content-type"] = mimetype
          headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "#{disp}; filename=\"#{filename}\"" 
          headers['Expires'] = "0" 
        else
          headers["Content-Type"] ||= mimetype
          headers["Content-Disposition"] = "#{disp}; filename=\"#{filename}\"" 
        end
        volume.read(path)
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
    end
  end
end
