# frozen_string_literal: true

module Injected
  class Instance
    extend Injected::InstanceDsl

    def initialize(injections) # rubocop:disable Metrics/AbcSize
      self.class.injected_interfaces&.each do |interface, attribute|
        interface.interface_methods.keys.each do |interface_method|
          raise ArgumentError, "#{self.class} unment dependency #{interface}" unless injections.key?(interface)
          next if injections[interface].instance_methods.include?(interface_method)

          raise ArgumentError, "Implementation #{injections[interface]} does not implement #{interface_method}"
        end
        instance_variable_set("@#{attribute}", injections[interface].new)
      end
    end
  end
end
