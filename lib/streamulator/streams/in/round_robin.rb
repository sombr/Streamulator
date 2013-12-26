require_relative "../storage/round_robin"
require_relative "../in"

module Streams
  module In
    class RoundRobin
      include Streams::In::In

      def initialize( name, meta: {}, data: {})
        @meta = meta
        @data = data
        @meta[name] ||= @meta[:storage]
        @name = name
        @cur_pos ||= @meta[@name]
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

        return chunk
      end

      def commit
        @meta[@name] = @cur_pos
      end


    end
  end
end
