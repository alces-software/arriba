require 'arriba/api/base'

module Arriba
  class Api
    SINGLE_TARGET_COMMANDS = [
                              'open','tree','parents','ls',
                              'mkdir', 'mkfile',
                              'rename', 'file', 'get', 'put',
                              'extract'
                             ]
    class << self
      def singular?(cmd)
        SINGLE_TARGET_COMMANDS.include?(cmd)
      end

      def run(cmd, volumes, params)
        if method_defined?(cmd.to_sym)
          if singular?(cmd)
            new(volumes,params).target(cmd)
          else
            new(volumes,params).send(cmd)
          end
        else
          raise "Unsupported operation: #{cmd}"
        end
      end
    end

    include Arriba::Api::Base
  end
end
