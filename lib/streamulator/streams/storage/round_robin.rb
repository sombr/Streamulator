require_relative "../in/round_robin"
require_relative "../storage"

module Streams
  module Storage

    class RoundRobin
      include Streams::Storage::Storage

      def initialize( size: 1024**3 )
        @size = size
        @data = {}
        @meta = { storage: 0 }

        @buffer = {}
        @buffer_size = 50 * 1024**2
        @buf = 0
      end

      def write( line )
        write_chunk( [line] )
      end

      def write_chunk( chunk )
        chunk.each { |line|
          @buffer[@buf] = line
          if (line.is_a? Hash) && line[:size]
            @buf += line[:size]
          else
            throw "not implemented"
          end
        }

        if @buf > @buffer_size
          flush_buffer()
        end
      end

      def commit
        flush_buffer()
      end

      def in( name )
        @clients ||= []
        c = Streams::In::RoundRobin.new( name, meta: @meta, data: @data )
        @clients.push( c )
        c
      end

      private

      def flush_buffer
        storage = @meta[:storage]
        new_pos = storage + @buf
        crossed = false
        if new_pos >= @size
          new_pos = @size - new_pos
          crossed = true
        end

        @meta.keys.map { |k|
          if crossed
            throw "on write: cross position with #{k}" if ( new_pos >= @meta[k] || @meta[k] > storage )
          else
            throw "on write: cross position with #{k}" if ( new_pos >= @meta[k] && @meta[k] > storage )
          end
        }

        #clean data
          @data.delete_if { |k,v| k > storage && k <= new_pos }
        # //
        @buffer.each { |k,v|
          @data[ storage + k ] = v
        }
        @buf = 0
        @buffer = {}
        @meta[:storage] = new_pos
      end

    end
# //
  end
end
