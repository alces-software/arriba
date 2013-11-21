module Arriba
  class Api
    module Symlinks
      def open(*args)
        resolve_symlinks(super)
      end

      private
      def resolve_symlinks(data)
        resolver = lambda do |obj|
          case obj
          when Array
            obj.each(&resolver)
          when Hash
            obj.each_value(&resolver)
          when Arriba::File
            if obj.symlink?
              target = obj.abs_symlink_target
              target_volume, target_rel_path = volume_relpath_for(target)
              obj.resolve_symlink(target_volume, target_rel_path)
            end
          end
        end
        resolver.call(data)
      end

      # Returns the first volume that 'contains' the specified path, or nil
      def volume_relpath_for(path)
        rel_path = nil
        vol = volumes.find { |vol| rel_path = vol.rel_path_to(path) }
        [vol, rel_path]
      end
    end
  end
end
