require 'priority_queue'
require 'fiber'

module Streamulator
  class Engine
    @@global_time = 0
    @@queue = PriorityQueue.new
    @@debug = true

    def self.after_delay( interval, &block )
      @@queue.push block, ( interval + @@global_time )
    end

    def self.run
      while @@queue.length > 0
        event = @@queue.delete_min
        @@global_time = event[1]
        event[0].call()
      end
    end

    def self.debug( string )
      printf( "[%7d] %s\n", @@global_time, string ) if @@debug
    end
  end

  module Events
    def after_delay( interval, &block )
      Streamulator::Engine.after_delay( interval, &block )
    end

    def run!
      Streamulator::Engine.run
    end

    def debug( string )
      Streamulator::Engine.debug( string )
    end

    def delay( interval )
      fiber = Fiber.current
      after_delay interval do
        fiber.resume
      end
      Fiber.yield
    end
  end
end
