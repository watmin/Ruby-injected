# frozen_string_literal: true

module Injected
  class Injector
    def initialize(injections)
      @injections = injections
    end

    def instance(class_name)
      class_name.new(@injections)
    end
  end
end
