module Arriba
  class Api
    module Duplication
      def duplicate
        respond_with(:added) do |v,p|
          v.duplicate(p)
          v.file(v.dirname(p),v.duplicate_name_for(p))
        end
      end
      
      def paste
        cut? ? cut : copy
      end

      private
      def copy
        respond_with(:added) do |v,p|
          dest_v, dest_p = Arriba::Routing::route(params[:dst])
          dest_v = volumes.find{|vol| vol.id == dest_v}
          v.copy(p,dest_v,dest_p)
          dest_v.file(dest_p, dest_v.name_for(p))
        end
      end

      # XXX
      def cut
        # accepts a targets[] array
        errors = []
        added = []
        removed = []
        params[:targets].each do |target|
          src_v, src_p = Arriba::Routing::route(target)
          src_v = volumes.find{|vol| vol.id == src_v}

          dest_v, dest_p = Arriba::Routing::route(params[:dst])
          dest_v = volumes.find{|vol| vol.id == dest_v}

          result = src_v.move(src_p,dest_v,dest_p)
          if result == true
            added << dest_v.file(dest_p,dest_v.name_for(src_p))
            removed << src_v.hash_for(src_p)
          else
            errors << "#{result}"
            nil
          end
        end.compact
        {}.tap do |data|
          data[:added] = added if added.any?
          data[:removed] = removed if removed.any?
          data[:error] = errors.join('<br />') if errors.any?
        end    
      end

      def cut?
        flagged?(:cut)
      end
    end
  end
end
