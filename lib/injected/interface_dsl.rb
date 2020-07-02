# frozen_string_literal: true

module Injected
  module InterfaceDsl
    def self.extended(receiver)
      class << receiver
        attr_accessor :interface_methods
      end
    end

    def interface_method(method_name, *args, **optional, &block)
      @interface_methods ||= {}
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{method_name}(#{signature(args, optional, block)}); end
      RUBY_EVAL
      interface_methods[method_name] = instance_method(method_name)
    end

    def signature(args, optional, block)
      base = [args, optional.map { |k, v| "#{k}: #{v.inspect}" }.join(' ')].flatten(1).reject(&:empty?).join(', ')
      return base unless block

      [base, '&block'].reject(&:empty?).join(', ')
    end
  end
end
