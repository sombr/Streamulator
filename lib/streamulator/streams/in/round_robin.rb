require_relative "../storage/round_robin"
require_relative "../in"
require_relative "../../engine"

module Streams
  module In
    class RoundRobin
      include Streams::In::In
      include Streamulator::Events

      READ_TIME = 0.2

      def initialize( name, meta: {}, data: {}, size: 0 )
        @meta = meta
        @data = data
        @meta[name] ||= @meta[:storage]
        @name = name
        @cur_pos ||= @meta[@name]
        @size = size
      end

      def read
        res = read_chunk(1)
        return res if res.nil?
        return res.first
      end

      def read_chunk(count)
        max_pos = @meta[:storage]

        c = 0
        chunk = []
        while ( @cur_pos < max_pos && c < count )
          if @data[@cur_pos]
            chunk.push( @data[@cur_pos] )
            @cur_pos += @data[@cur_pos][:size]
            c += 1
          else
            throw "something strange"
          end
        end
        delay c*READ_TIME

        return chunk if chunk.size > 0
        return nil
      end

      def commit
        @meta[@name] = @cur_pos
      end

      def lag
        storage = @meta[:storage]
        cur = @meta[@name]

        if cur < storage
          return storage - cur
        else
          return (@size - cur) + storage
        end
      end

    end
  end
end
