require 'arriba/api/structures'
require 'arriba/api/creation'
require 'arriba/api/deletion'
require 'arriba/api/duplication'
require 'arriba/api/management'

module Arriba
  class Api
    module Base
      attr_accessor :volumes, :params

      def initialize(volumes, params)
        self.volumes = volumes
        self.params = params
      end

      include Arriba::Api::Structures
      include Arriba::Api::Creation
      include Arriba::Api::Deletion
      include Arriba::Api::Duplication
      include Arriba::Api::Management

      # def tmb
      # end
      # def size
      # end
      # def upload
      # end
      # def archive
      # end
      # def extract
      # end
      # def search
      # end
      # def info
      # end
      # def dim
      # end
      # def resize
      # end
    end
  end
end
