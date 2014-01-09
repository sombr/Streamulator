require_relative "../base"

module Streams
  module Out
    class Any
      include Streams::Out::Out

      def initialize( :targets = [], :revalidate = nil, :shuffle = true )
        @buffers = []
        @invalid = targets.map { |t| nil }
        @n = 0
        @total = targets.size
        @targets = shuffle ? targets.shuffle : targets
        @revalidate = revalidate
      end

      def targets
        @targets
      end

      def write_chunk( chunk )
        n = @n
        unless @targets[n].write_chunk( chunk )
          debug("write to target #{n} #{@targets[n].name} failed")
          mark_invalid(n)

          return write_chunk( chunk )
        end

        @buffers[n] ||= []
        @buffers[n].push( chunk )
        next_target
      end

      private

      def next_target
        while true
          @n = ( @n + 1 ) % @total
          break unless is_invalid( @n )
        end
      end

      def check_invalid # check all invalid
        return (0...@targets.size).all? { |tn| is_invalid(tn) == true }
      end

      def is_invalid( i )
        if ( @revalidate && @invalid[i] && @invalid[i] < Time.now.to_i )
          debug("revalidate target #{i} - " + @targets[i].name)
          @invalid[i] = nil
        end
        return !@invalid[i].nil?
      end

      def clear_buffer( i )
        @buffers[i].each { |b|
          write_chunk( b )
        }
        @buffers[i] = []
      end


    end


  end

end
