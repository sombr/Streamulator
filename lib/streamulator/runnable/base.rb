require_relative "../engine"

module Streamulator
  module Runnable

    LOAD_TIME = 3 # sec

    class Base
      include Streamulator::Events

      def initialize( auto_start = true, &block )
        @run_block = block
        self.start if auto_start
      end

      def start
        after_delay LOAD_TIME * rand {
          fiber = Fiber.new &@run_block
          @pid = fiber.object_id
          fiber.resume
        }
      end

      def stop

      end

    end

  end
end
