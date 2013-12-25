require_relative '../streams'

module Streamulator
  module Runnable
    class Pumper < Streamulator::Runnable::Process
      attr_accessor :in
      attr_accessor :out
      attr_accessor :main_filter

      def initialize( s_opts )
        (
          s_in, s_out, s_filter,
          limit, commit_step, chunk_size
        ) = [:in, :out, :filter, :limit, :commit_step, :chunk_size].map { |key| s_opts[key] }
        throw "should be In" unless s_in.is_a? Streams::In::In
        throw "should be Out" unless s_out.is_a? Streams::Out::Out
        @in = s_in
        @out = s_out
        @main_filter = s_filter || filter { |item| item }

        @limit = limit || 10000
        @chunk_size = chunk_size || 100
        @commit_step = commit_step if commit_step
      end

      def main
        process( { @in => @main_filter | @out }, {
          :limit => @limit,
          :chunk_size => @chunk_size,
          :commit_step => @commit_step
        })
      end
    end
  end
end
