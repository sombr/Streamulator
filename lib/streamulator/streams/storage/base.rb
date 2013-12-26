require_relative "../out"

module Streams
  module Storage
    module Storage
      include Streams::Out::Out

      def in( name )
        throw "abstract method :in is called"
      end
    end

  end
end
