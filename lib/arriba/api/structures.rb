module Arriba
  class Api
    module Structures
      def open(volume, path)
#        { :options => options([volume.name,path].join) }.tap do |data|
        if volume.nil?
          volume = volumes.first
          path = '/'
        end
        { :options => options }.tap do |data|
          cwd_thread = Thread.new { Thread.current[:cwd] = volume.cwd(path) }
          if init?
            files = volumes.map do |vol|
              Thread.new { Thread.current[:files] = vol.files('/') }
            end.map { |t| t.join && t[:files] }.flatten
            files += ( path == '/' ? [] : volume.files(path) )
            data.merge!({
                          :api => '2.0',
                          :uplMaxSize => 0
                        })
          else
            files = volume.files(path)
          end
          cwd_thread.join
          data.merge!(:files => files, :cwd => cwd_thread[:cwd])
        end
      end
      
      def tree(volume, path)
        { :tree => volume.tree(path) }
      end
      
      # find directory siblings and all parent directories up to the root
      def parents(volume, path)
        { :tree => volume.parents(path) }
      end
      
      def ls(volume, path)
        { :list => volume.ls(path) }
      end
    end
  end
end
