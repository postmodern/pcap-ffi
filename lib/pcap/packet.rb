require 'pcap/extensions/ffi/struct/array'

module FFI
  module PCap
    module Packet
      def self.included(base)
        base.module_eval do
          # Payload of the packet
          attr_reader :payload

          # Length of the packets payload
          attr_reader :payload_length

          # Previous packet in the payload
          attr_reader :prev

          def self.release(ptr)
          end
        end
      end

      #
      # Creates a new packet from the specified _ptr_, _length_
      # and the given _prev_ packet.
      #
      def initialize(ptr,length,prev=nil)
        super(ptr)

        @length = length
        @payload = self.to_ptr + self.size
        @payload_length = @length - self.size

        @prev = prev
      end

      #
      # Returns the bytes at the specified _index_or_range_.
      #
      #   pkt[0]
      #   # => 255
      #
      #   pkt[0..2]
      #   # => [255, 255, 25]
      #
      def [](index_or_range)
        if index_or_range.kind_of?(Range)
          start = index_or_range.begin
          stop = index_or_range.end
        else
          start = index_or_range
          stop = index_or_range + 1
        end

        if start >= @payload_length
          return nil
        end

        return @payload.get_array_of_uint8(start,stop - start)
      end

      #
      # Default method which returns the next packet in the payload.
      #
      def next
        nil
      end
    end
  end
end
