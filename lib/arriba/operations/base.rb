require 'active_support/core_ext/object/inclusion'

module Arriba
  module Operations
    module Base
      attr_accessor :name, :root
      private :name=, :root=, :name, :root

      # module that mix in must define: #entries(path) and #tree(path)
      # in order to support #files, #ls and #parents.
      
      def files(path, include_cwd = true)
        # x = entries(path).map {|f| file(path,f) }
        x = include_cwd ? [cwd(path)] : []
        x += entries(path).map {|f| file(path,f) }
        if x.length > 1000
          x = x[0..999]
          x.unshift :truncated
        end
        x
      rescue Errno::EACCES
        [cwd(path)]
      end

      def ls(path)
        x = entries(path)
        if x.length > 1000
          x = x[0..999]
          x.unshift :truncated
        end
        x
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
