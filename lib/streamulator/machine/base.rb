require_relative "../engine"
require_relative "../runnable/base"

module Streamulator
  module Machine

    STARTUP_TIME = 5 # sec

    def machine(&block, mclass = Streamulator::Machine::Base) # returns Machine Generator
      Enumerator.new { |generator|
        m = mclass.new(&block)
        generator << m
      }
    end

    class Base # base Machine implementation
      include Streamulator::Events

      def initialize( &exec_block )
        after_delay rand * STARTUP_TIME {
          self.instance_exec exec_block
        }
      end

      def process( runnable )
        throw "don't know how to run #{runnable.class} type" unless runnable.is_a? Stream::Runnable::Base
      end
    end
  end
end
