module Streams
  module In
    module In
      def read
        return read_chunk(1)
      end

      def read_chunk( count )
        throw "abstract method :read_chunk called on In"
      end

      def commit
        throw "abstract method :commit called on In"
      end
    end
  end
end
