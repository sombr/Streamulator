require_relative 'in'
require_relative 'out'
require_relative "filter"

module Streams
  module Utils
    def process( s_in_out, opts = {} )
      throw "should be <in> => <out> " unless s_in_out.keys.size == 1
      s_in = s_in_out.keys.first
      s_out = s_in_out.values.first
      chunk_size  = opts[:chunk_size] || 100
      commit      = opts[:commit] || true
      commit_step = opts[:commit_step]
      limit       = opts[:limit]

      count = 0
      last  = limit
      mchunk = chunk_size
      while ( chunk = s_in.read_chunk(mchunk) )
        s_out.write_chunk( chunk )
        count += chunk.size

        unless last.nil?
          last -= chunk.size
          mchunk = last if last < mchunk
        end

        if commit_step && count > commit_step
          s_out.commit
          s_in.commit
          count = 0
        end
      end

      s_out.commit
      s_in.commit
    end

    def array_in( list )
      return Streams::In::ArrayIn.new( list )
    end

    def array_out( list )
      return Streams::Out::ArrayOut.new( list )
    end

    def code_out( &block )
      return Streams::Out::CodeOut.new( &block )
    end

    def filter( &block )
      return Streams::Filter::AnonFilter.new( &block )
    end
  end
end
