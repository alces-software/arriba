module Arriba
  class Api
    module Deletion
      def rm
        # accepts a targets[] array
        each_target(:removed) do |v,p|
          # XXX - should combine any errors with what is removed
          #  XXX++ - this should be being dealt with automatically withing Base#each_target, but it doesn't seem to be...
          v.rm(p)
          v.hash_for(p)
        end
      end
    end
  end
end
