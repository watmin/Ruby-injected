# frozen_string_literal: true

module Injected
  module InstanceDsl
    def self.extended(receiver)
      class << receiver
        attr_accessor :injected_interfaces
      end
    end

    def injected(interface, attribute)
      @injected_interfaces ||= {}
      injected_interfaces[interface] = attribute
      attr_reader attribute
      private attribute
    end
  end
end
