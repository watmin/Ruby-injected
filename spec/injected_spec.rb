# frozen_string_literal: true

class SpecInterface0 < Injected::Interface
  interface_method(:test, :arg)
end

class SpecInterface1 < Injected::Interface
  interface_method(:test, :arg1, :arg2)
end

class SpecInterface2 < Injected::Interface
  interface_method(:test, kwarg: nil)
end

class SpecInterface3 < Injected::Interface
  interface_method(:test) {}
end

class SpecInterface4 < Injected::Interface
  interface_method(:test, :arg, kwarg: nil)
end

class SpecInterface5 < Injected::Interface
  interface_method(:test, :arg) {}
end

class SpecInterface6 < Injected::Interface
  interface_method(:test, kwarg: nil) {}
end

class SpecInterface7 < Injected::Interface
  interface_method(:test, :arg, kwarg: nil) {}
end

class SpecInterface8 < Injected::Interface
  interface_method(:test, :arg1, :arg2)
end

RSpec.describe Injected do
  context 'when failing to implement interface metohd' do
    it 'raises an error' do
      implemented = Class.new(Injected::Implementation) {}
      service = Class.new(Injected::Instance) { injected(SpecInterface0, :dependency) }
      injector = Injected::Injector.new(SpecInterface0 => implemented)

      expect do
        injector.instance(service)
      end.to raise_error(ArgumentError)
    end
  end

  context 'when implementing a positional argument' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface0

        def test(arg)
          arg
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface0, :dependency)

        def test(arg)
          dependency.test(arg)
        end
      end

      injector = Injected::Injector.new(SpecInterface0 => implemented)
      instance = injector.instance(service)

      expect(instance.test(:test)).to be :test
    end
  end

  context 'when implementing multple positional arguments' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface1

        def test(arg1, arg2)
          [arg1, arg2]
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface1, :dependency)

        def test(arg1, arg2)
          dependency.test(arg1, arg2)
        end
      end

      injector = Injected::Injector.new(SpecInterface1 => implemented)
      instance = injector.instance(service)

      expect(instance.test(:test1, :test2)).to eq %i[test1 test2]
    end
  end

  context 'when implementing keyword arguments' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface2

        def test(kwarg: true)
          kwarg
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface2, :dependency)

        def test1(value)
          dependency.test(kwarg: value)
        end

        def test2
          dependency.test
        end
      end

      injector = Injected::Injector.new(SpecInterface2 => implemented)
      instance = injector.instance(service)

      aggregate_failures do
        expect(instance.test1(:test)).to be :test
        expect(instance.test2).to be true
      end
    end
  end

  context 'when implementing with a block' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface3

        def test(&block)
          block.call
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface3, :dependency)

        def test
          dependency.test { :test }
        end
      end

      injector = Injected::Injector.new(SpecInterface3 => implemented)
      instance = injector.instance(service)

      expect(instance.test).to be :test
    end
  end

  context 'when implementing with positional and keyword arguments' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface4

        def test(arg, kwarg: true)
          [arg, kwarg]
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface4, :dependency)

        def test1(arg)
          dependency.test(arg)
        end

        def test2(arg)
          dependency.test(arg, kwarg: :test2)
        end
      end

      injector = Injected::Injector.new(SpecInterface4 => implemented)
      instance = injector.instance(service)

      aggregate_failures do
        expect(instance.test1(:test)).to eq [:test, true]
        expect(instance.test2(:test)).to eq %i[test test2]
      end
    end
  end

  context 'when implementing with positional arguments and a block' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface5

        def test(arg, &block)
          block.call(arg)
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface5, :dependency)

        def test(arg)
          dependency.test(arg, &:to_sym)
        end
      end

      injector = Injected::Injector.new(SpecInterface5 => implemented)
      instance = injector.instance(service)

      expect(instance.test('test')).to be :test
    end
  end

  context 'when implementing with keyword arguments and a block' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface6

        def test(kwarg:, &block)
          block.call(kwarg)
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface6, :dependency)

        def test(arg)
          dependency.test(kwarg: arg, &:to_sym)
        end
      end

      injector = Injected::Injector.new(SpecInterface6 => implemented)
      instance = injector.instance(service)

      expect(instance.test('test')).to be :test
    end
  end

  context 'when implementing with positional and keyword arguments and a block' do
    it 'raises no errors' do
      implemented = Class.new(Injected::Implementation) do
        implements SpecInterface7

        def test(arg, kwarg: true, &block)
          [block.call(arg), kwarg]
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface7, :dependency)

        def test(arg)
          dependency.test(arg, &:to_sym)
        end
      end

      injector = Injected::Injector.new(SpecInterface7 => implemented)
      instance = injector.instance(service)

      expect(instance.test('test')).to eq [:test, true]
    end
  end

  context 'when implementing incorrect positional arguments' do
    it 'raises an error' do
      expect do
        Class.new(Injected::Implementation) do
          implements SpecInterface1

          def test(arg)
            arg
          end
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'when injecting multiple dependencies' do
    it 'raises no errors' do
      implemented0 = Class.new(Injected::Implementation) do
        implements SpecInterface0

        def test(arg)
          arg
        end
      end

      implemented1 = Class.new(Injected::Implementation) do
        implements SpecInterface1

        def test(arg1, arg2)
          [arg1, arg2]
        end
      end

      service = Class.new(Injected::Instance) do
        injected(SpecInterface0, :dependency0)
        injected(SpecInterface1, :dependency1)

        def test0(arg)
          dependency0.test(arg)
        end

        def test1(arg1, arg2)
          dependency1.test(arg1, arg2)
        end
      end

      injector = Injected::Injector.new(
        SpecInterface0 => implemented0,
        SpecInterface1 => implemented1
      )

      instance = injector.instance(service)

      aggregate_failures do
        expect(instance.test0(:test)).to be :test
        expect(instance.test1(:test1, :test2)).to eq %i[test1 test2]
      end
    end
  end
end
