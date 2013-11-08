module Arriba
  class Api
    module Symlinks
      def send(*args)
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
              STDERR.puts "Trying to resolve " + obj.path + " with target " + obj.abs_symlink_target
              target = obj.abs_symlink_target
              target_volume, target_rel_path = symlink_target_volpath(target)
              obj.resolve_symlink(target_volume, target_rel_path)
            end
          end
        end
        resolver.call(data)
      end

      def symlink_target_volpath(target)
        rel_path = nil
        vol = volumes.find { |vol| rel_path = vol.rel_path_to(target) }
        [vol, rel_path]
      end
    end
  end
end
