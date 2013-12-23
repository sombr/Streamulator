require "streamulator/engine"
require "fiber"

module Streamulator
  module Source
    class File
      include Streamulator::Events

      OPEN_TIME = 1
      READ_TIME = 0.5
      WRITE_TIME = 1

      def initialize( name )
        @name = name
      end

      def read( size )
        debug "opening file #{@name}"
        delay OPEN_TIME
        debug "reading #{size} from #{@name}"
        delay READ_TIME
        debug "read #{size} from #{@name}"
      end

      def write( size )
        debug "opening file #{@name}"
        delay OPEN_TIME
        debug "writing #{size} to #{@name}"
        delay WRITE_TIME
        debug "wrote #{size} to #{@name}"
      end

    end
  end
end
