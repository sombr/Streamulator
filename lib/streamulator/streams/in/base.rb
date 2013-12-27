require_relative "../filter"
require 'fiber'

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

      def |(b)
        return Streams::In::FilteredIn.new(self, b)
      end
    end

    class ArrayIn
      include Streams::In::In

      def initialize( list )
        @data = list
      end

      def read_chunk( count )
        return @data.shift( count ) if @data.size > 0
        return nil
      end

      def commit
        return true
      end

    end

    class FilteredIn
      include Streams::In::In

      def initialize( s_in, s_filter )
        throw "should be Streams::In::In" unless s_in.is_a? Streams::In::In
        throw "should be Streams::Filter::Filter" unless s_filter.is_a? Streams::Filter::Filter
        @in = s_in
        @filter = s_filter
      end

      def read_chunk( count )
        chunk = @in.read_chunk( count )
        return chunk if chunk.nil?

        return @filter.write_chunk( chunk )
      end

      def commit
        @filter.commit && @in.commit
      end

    end

  end
end
