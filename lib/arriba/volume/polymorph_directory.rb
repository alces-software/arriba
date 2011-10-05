require 'polymorph_client/connection'

module Arriba
  class Volume::PolymorphDirectory < Volume
    attr_accessor :host, :uid, :polymorph
    def initialize(host, uid, root, name = nil, id = nil)
      name ||= root
      id ||= Arriba::Routing::encode(name)
      super(id)
      self.host = host
      self.uid = uid
      self.polymorph = PolymorphClient::Connection.new(host, { 
                                                         :uid => uid,
                                                         :handler => 'Alces::Polymorph::ArribaHandler',
                                                         :handler_args => [id, root, name]
                                                       })
    end

    delegate *Arriba::Operations::File.instance_methods, :to => :polymorph

    # override File IO method as we are unable to deliver a File over marshalling
    def io(path)
      s = polymorph.forked_io({:uid => uid},
                              polymorph.io(path))
      TCPSocket.new(host,s).tap do |sock|
        class << sock
          # 1MiB chunks by default from #each
          def each(*a,&b)
            if a.empty?
              # if @foo.nil?
              #   STDERR.puts Thread.current.backtrace.join("\n")
              #   @foo = true
              # end
              GC.start
              super('',1_048_576,&b)
            else
              super
            end
          end
        end
      end
    end
  end
end
