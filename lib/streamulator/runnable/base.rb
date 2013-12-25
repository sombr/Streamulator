require_relative "../engine"

module Streamulator
  module Runnable
    # basic Runnable instance
    class Base
      include Streamulator::Events
      attr_accessor :pid

      LOAD_TIME = 30 # sec

      def initialize( &block )
        after_delay (LOAD_TIME * rand) {
          fiber = Fiber.new &block
          @pid = fiber.object_id
          fiber.resume
        }
      end

    end

    # basic Process with abstract main()
    class Process
      include Streamulator::Events

      def main
        throw "abstract method :main is called"
      end

      def run
        @r ||= Base.new {
          self.main
          @r = nil
        }
      end

      def pid
        return @r.pid if @r
      end

    end

  end
end
