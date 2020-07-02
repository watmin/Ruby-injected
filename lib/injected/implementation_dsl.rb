# frozen_string_literal: true

module Injected
  module ImplementationDsl
    def implements(interface)
      @implemented_interface = interface
    end

    private

    attr_reader :implemented_interface

    def method_added(method_name)
      super

      return unless invalid_arity?(method_name)

      raise ArgumentError, "Invalid arity for implemented method #{method_name} for #{self}. " \
                           "Expected #{interface_method(method_name).parameters}, " \
                           "got #{instance_method(method_name).parameters}"
    end

    def interface_method(method_name)
      implemented_interface.interface_methods[method_name]
    end

    def invalid_arity?(method_name)
      if interface_method(method_name)
        fixed = instance_method(method_name).parameters.map do |type, arg|
          [type == :keyreq ? :key : type, arg]
        end
        interface_method(method_name).parameters != fixed
      else
        false
      end
    end
  end
end
