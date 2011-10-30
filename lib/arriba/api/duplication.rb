module Arriba
  class Api
    module Duplication
      def duplicate
        each_target(:added) do |v,p|
          v.duplicate(p)
          v.file(v.dirname(p),v.duplicate_name_for(p))
        end
      end
      
      def paste
        cut? ? cut : copy
      end

      private
      def copy
        each_target_with_destination(:added) do |src_vol, src_path, dest_vol, dest_path|
          if src_vol == dest_vol
            src_vol.copy(src_path,dest_path)
            dest_vol.file(dest_path, dest_vol.name_for(src_path))
          else
            raise "Unable to copy across volumes"
          end
        end
      end

      def cut
        removed = []
        each_target_with_destination(:added) do |src_vol, src_path, dest_vol, dest_path|
          if src_vol == dest_vol
            src_vol.move(src_path,dest_path)
            removed << src_vol.hash_for(src_path)
            dest_vol.file(dest_path,dest_vol.name_for(src_path))
          else
            raise "Unable to move across volumes"
          end
        end.tap do |data|
          data[:removed] = removed if removed.any?
        end    
      end

      def cut?
        flagged?(:cut)
      end
    end
  end
end
