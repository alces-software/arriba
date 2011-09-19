require 'arriba/api/base'

module Arriba
  class Api
    include Arriba::Api::Base

    private

    def volume
      @volume ||= begin
                    vol_id = decoded_volume_and_path.first
                    volumes.find{|vol| vol.id == vol_id}
                  end
    end

    def path
      @path ||= begin 
                  p = decoded_volume_and_path.last
                  # Prevent requests for '.' and '..' breaking elfinder client
                  raise "Invalid target path: '#{p}'" if p =~ /\.$/
                  p.blank? ? '/' : p
                end
    end

    def decoded_volume_and_path
      @decoded_volume_and_path ||= if params[:target].present?
                                     Arriba::Routing::route(params[:target])
                                   else
                                     [volumes.first.id,'/']
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

    def init?
      params[:init] && params[:init] == '1'
    end
    
    def tree?
      params[:tree] && params[:tree] == '1'
    end
  end
end
