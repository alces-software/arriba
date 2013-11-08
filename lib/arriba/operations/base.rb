require 'active_support/core_ext/object/inclusion'

module Arriba
  module Operations
    module Base
      attr_accessor :name, :root
      private :name=, :root=, :name, :root

      # module that mix in must define: #entries(path) and #tree(path)
      # in order to support #files, #ls and #parents.
      
      def files(path)
        [cwd(path)] + entries(path).map {|f| file(path,f) }
      rescue Errno::EACCES
        [cwd(path)]
      end

      def ls(path)
        entries(path)
      end

      def parents(path)
        # path is a directory
        # find siblings of path and siblings of parents
        parent = ::File.dirname(path)
        tree(parent).tap { |d| d += parents(parent) unless parent.in?(['.','/']) }
      end
      
      def cwd(path)
        if path.in?(['.','/'])
          base
        else
          represent(path)
        end
      end

      def file(path,f = nil)
        relative_path = f.nil? ? path : ::File.join(path,f)
        represent(relative_path)
      end

      def locked?(path)
        false
      end

      def rel(path)
        return nil unless path && ::File.exists?(path)
        ::File.realpath(path).tap do |rel|
          rel.slice!(real_root)
        end
      end

      protected
      def abs(*args)
        ::File.join(root,*args)
      end

      private
      def volume
        self
      end

      def represent(path)
        Arriba::File.new(volume, path)
      end

      def base
        Arriba::Root.new(volume,name)
      end
    end
  end
end
