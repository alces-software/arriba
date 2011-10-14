module Arriba
  module Target
    class << self
      def new(args_hash)
        target_class = const_get(args_hash[:type].to_s.camelize)
        target_class.new(args_hash)
      end
    end
  end
end
