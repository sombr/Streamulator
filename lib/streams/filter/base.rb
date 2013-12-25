require_relative "../out"

module Streams
  module Filter
    module Filter
      def write
        throw "abstract module"
      end

      def write_chunk
        throw "abstract module"
      end

      def commit
        throw "abstract method :commit is called"
        return []
      end

      def |(b)
        return Streams::Out::FilteredOut.new( self, b )
      end
    end

    module FilterSimple
      include Streams::Filter::Filter

      def write( line )
        return write_chunk([line]).shift
      end

      def write_chunk(chunk)
        throw "abstract method :write_chunk is called"
      end

    end

    module FilterChunked
      include Streams::Filter::Filter

      def write( line )
        throw "abstract method :write is called"
      end

      def write_chunk(chunk)
        return chunk.inject([]) { |acc,line|
          wline = write(line)
          acc.push(wline) if wline
          acc
        }
      end

    end

    class AnonFilter
      include Streams::Filter::FilterChunked

      def initialize( &block )
        @block = block
      end

      def write( line )
        return @block.call(line)
      end

      def commit
      end
    end
  end
end
