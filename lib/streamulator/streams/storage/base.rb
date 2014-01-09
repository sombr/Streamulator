require_relative "../out"

module Streams
  module Storage
    module Storage
      include Streams::Out::Out

      def in( name )
        throw "abstract method :in is called"
      end

      def client_list
        throw "abstract method :client_list is called"
      end

      def occupancy
        return client_list.inject(0) { |acc,c| acc += c.lag; acc }
      end
    end

  end
end
