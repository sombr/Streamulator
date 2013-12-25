require_relative '../streams'

module Streamulator
  module Runnable
    class Pumper < Streamulator::Runnable::Process
      attr_accessor :in
      attr_accessor :out
      attr_accessor :main_filter

      def initialize( s_opts )
        (s_in, s_out, s_filter) = [:in, :out, :filter].map { |key| s_opts[key] }
        @in = s_in.is_a? Streams::In::In ? s_in : throw "should be In"
        @out = s_out.is_a? Streams::Out::Out ? s_out : throw "should be Out"
        @main_filter = s_filter || filter { |item| return item }
      end

      def main
        
      end
    end
  end
end
