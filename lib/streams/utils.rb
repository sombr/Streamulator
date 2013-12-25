module Streams
  module Utils
    def process( s_in, s_out, opts = {} )
      chunk_size = opts[:chunk_size] || 100
      commit     = opts[:commit] || true

      while ( chunk = s_in.read_chunk(chunk_size) )
        s_out.write_chunk( chunk )
      end

      s_out.commit
      s_in.commit
    end
  end
end
