require_relative "../filter"

module Streams
  module Out
    module Out
      def write( line )
        write_chunk([line])
      end

      def write_chunk( chunk )
        throw "abstract method :write_chunk is called"
      end

      def commit
        throw "abstract method :commit is called"
      end

    end

    class CodeOut
      include Streams::Out::Out

      def initialize( &block )
        @block = block
      end

      def write_chunk( chunk )
        chunk.each { |line|
          @block.call( line )
        }
      end

      def commit
        return true
      end
    end

    class ArrayOut
      include Streams::Out::Out

      def initialize( list )
        @list = list
      end

      def write_chunk( chunk )
        @list.push( *chunk )
      end

      def commit
        return true
      end
    end

    class FilteredOut
      include Streams::Out::Out

      def initialize( s_filter, s_out )
        throw "should be Streams::Out::Out" unless s_out.is_a? Streams::Out::Out
        throw "should be Streams::Filter::Filter" unless s_filter.is_a? Streams::Filter::Filter
        @out = s_out
        @filter = s_filter
      end

      def write_chunk( chunk )
        @out.write_chunk( @filter.write_chunk( chunk ) )
      end

      def commit
        chunk = @filter.commit
        @out.write_chunk( chunk ) if chunk
        @out.commit
      end
    end

  end
end
