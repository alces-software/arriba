module Arriba
  module Routing
    class << self
      def encode(pathname)
        # while it breaks the spec, '=' padding is removed to keep the
        # elfinder client happy :-/
        Base64.encode64(pathname).chomp.tr("\n", "_").gsub('=','')
      end
      
      def decode(hash)
        # repad the data with appropriate '=' padding
        hash += '=' * (4 - (hash.length % 4))
        Base64.decode64(hash.tr("_", "\n"))
      end

      def route(target)
        # XXX - ruby 1.9
        m = target.match(/^(?<volume>.*?)_(?<path>.*)$/)
        STDERR.puts "routed vol: #{m[:volume]}, routed path: #{m[:path]}, decoded path: #{decode(m[:path])}"
        [m[:volume],decode(m[:path])]
      end
    end
  end
end
