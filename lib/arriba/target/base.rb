module Arriba
  module Target
    class Base
      attr_accessor :name, :dir

      def initialize(args_hash)
        self.name = args_hash[:name]
        self.dir = directory_for(args_hash)
      end

      def directory_for(opts)
        finder = opts[:directory_finder]
        case finder
        when NilClass
          opts[:directory]
        when Class
          finder.new(opts).directory
        else
          raise "Bad directory_finder: #{finder.inspect}"
        end
      end
    end
  end
end
