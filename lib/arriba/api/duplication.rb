module Arriba
  class Api
    module Duplication
      def duplicate
        # accepts a targets[] array
        errors = []
        results = params[:targets].map do |target|
          v, p = Arriba::Routing::route(target)
          v = volumes.find{|vol| vol.id == v}
          result = v.duplicate(p)
          if result == true
            v.file(v.dirname(p),v.duplicate_name_for(p))
          else
            errors << "#{result}"
            nil
          end
        end.compact
        {}.tap do |data|
          data[:added] = results if results.any?
          data[:error] = errors.join('<br />') if errors.any?
        end    
      end
      
      def paste
        if params[:cut] == '1'
          cut
        else
          copy
        end
      end

      def copy
        # accepts a targets[] array
        errors = []
        added = []
        params[:targets].each do |target|
          src_v, src_p = Arriba::Routing::route(target)
          src_v = volumes.find{|vol| vol.id == src_v}

          dest_v, dest_p = Arriba::Routing::route(params[:dst])
          STDERR.puts "dest_v is: #{dest_v.inspect}"
          dest_v = volumes.find{|vol| vol.id == dest_v}
          STDERR.puts "dest_v is: #{dest_v.inspect}"

          result = src_v.copy(src_p,dest_v,dest_p)
          if result == true
            added << dest_v.file(dest_p,dest_v.name_for(src_p))
          else
            errors << "#{result}"
            nil
          end
        end.compact
        {}.tap do |data|
          data[:added] = added if added.any?
          data[:error] = errors.join('<br />') if errors.any?
        end    
      end

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
    end
  end
end
