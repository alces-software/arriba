module Arriba
  class Api
    module Structures
      def open(volume, path)
        {
          :cwd => volume.cwd(path),
          :options => options
        }.tap do |data|
          if init?
            files = volumes.map { |vol| vol.files('/') }.flatten
            files += ( path == '/' ? [] : (volume.files(path) + volume.parents(path)) )
            data.merge!({
                          :api => '2.0',
                          :uplMaxSize => 0
                        })
          else
            files = volume.files(path)
          end
          data.merge!(:files => files)
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
