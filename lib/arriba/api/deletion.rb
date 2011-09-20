module Arriba
  class Api
    module Deletion
      def rm
        # accepts a targets[] array
        each_target(:removed) do |v,p|
          v.rm(p)
          v.hash_for(p)
        end
      end
    end
  end
end
