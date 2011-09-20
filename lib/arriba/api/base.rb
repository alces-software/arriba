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
      # def size
      # def upload
      # def archive
      # def extract
      # def search
      # def info
      # def dim
      # def resize

      def target(cmd = nil)
        volume, path = if params[:target].present?
                         v, p = Arriba::Routing::route(params[:target])
                         # Prevent requests for '.' and '..' breaking elfinder client
                         raise "Invalid target path: '#{p}'" if p =~ /\.$/
                         v = volumes.find{|vol| vol.id == v}
                         [v,p]
                       else
                         [volumes.first, '/']
                       end
        if cmd.nil?
          yield(volume, path)
        else
          send(cmd, volume, path)
        end
      end

      private

      def name
        params[:name]
      end

      def each_target_with_destination(sym)
        vol_id, dest_path = Arriba::Routing::route(params[:dst])
        dest_volume = volumes.find{|vol| vol.id == vol_id}
        each_target(sym) do |v,p|
          yield(v, p, dest_volume, dest_path)
        end
      end

      def each_target(sym)
        errors = []
        results = []
        targets do |volume, path|
          begin
            results << yield(volume,path)
          rescue
            errors << $!.message
          end
        end

        {}.tap do |data|
          data[sym] = results if results.any?
          data[:error] = errors.join('<br />') if errors.any?
        end    
      end
      
      def targets
        params[:targets].each do |t|
          v, p = Arriba::Routing::route(t)
          v = volumes.find{|vol| vol.id == v}
          yield(v,p)
        end
      end

      def options
        {
          archivers: {},
          # copyOverwrite enables a prompt before overwriting files
          copyOverwrite: 1,
          disabled: [],
          path: 'Home/',
          separator: '/',
          tmbUrl: 'http://foobar/thumbs/',
          url: 'http://foobar/'
        }
      end

      def flagged?(sym)
        params[sym] && params[sym] == '1'
      end

      def init?
        flagged?(:init)
      end
      
      def tree?
        flagged?(:tree)
      end
    end
  end
end
