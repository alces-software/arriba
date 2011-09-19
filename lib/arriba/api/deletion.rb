module Arriba
  class Api
    module Deletion
      def rm
        # accepts a targets[] array
        errors = []
        results = params[:targets].map do |target|
          v, p = Arriba::Routing::route(target)
          v = volumes.find{|vol| vol.id == v}
          result = v.rm(p)
          STDERR.puts "THE RESULT IS: #{result}"
          if result == true
            v.hash_for(p)
          else
            errors << "\n#{result}"
            nil
          end
        end.compact
        {}.tap do |data|
          data[:removed] = results if results.any?
          data[:error] = errors.join('<br />') if errors.any?
        end
      end
    end
  end
end
