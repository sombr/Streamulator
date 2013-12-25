require_relative '../streams'

module Streamulator
  module Runnable
    class Pumper < Streamulator::Runnable::Process
      attr_accessor :in
      attr_accessor :out
      attr_accessor :main_filter

      def initialize( s_in, s_out, s_filter )
        @in = s_in
        @out = s_out
        @main_filter = s_filter || filter { |item| return item }
      end
    end
  end
end
