require_relative '../streams'
require_relative "../engine"

module Streamulator
  module Runnable
    class Pumper < Streamulator::Runnable::Process
      include Streamulator::Events

      attr_accessor :in
      attr_accessor :out
      attr_accessor :main_filter

      def initialize( s_opts )
        (
          s_in, s_out, s_filter,
          limit, commit_step, chunk_size
        ) = [:in, :out, :filter, :limit, :commit_step, :chunk_size].map { |key| s_opts[key] }
        @in = s_in
        @out = s_out

        throw "should be In" unless @in.is_a? Streams::In::In
        throw "should be Out" unless @out.is_a? Streams::Out::Out
        @main_filter = s_filter || filter { |item| item }

        @limit = limit || 10000
        @chunk_size = chunk_size || 100
        @commit_step = commit_step if commit_step
      end

      def main
        while true
          process( { @in => @main_filter | @out }, {
            :limit => @limit,
            :chunk_size => @chunk_size,
            :commit_step => @commit_step
          })
          delay 600
        end
      end
    end
  end
end
