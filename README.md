# Injected

Simple Guice-inspird dependency injection framework for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'injected'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install injected

## Usage

```ruby
require 'injected'

class DemoInterface < Injected::Interface
  interface_method(:demo, :arg1, :arg2, arg3: :default)
end

class DemoImplementation < Injected::Implementation
  implements DemoInterface

  def demo(arg1, arg2, arg3: :wat)
    "arg1: #{arg1}; arg2: #{arg2}; arg3: #{arg3}"
  end
end

class DemoService < Injected::Instance
  injected(DemoInterface, :demo_dependency)

  def demo
    demo_dependency.demo(1, 2)
  end
end

injector = Injected::Injector.new(
  DemoInterface => DemoImplementation
)

demo_service = injector.instance(DemoService)
demo_service.demo #=> "arg1: 1; arg2: 2; arg3: default"

# inside demo_service

demo_interface.demo(1, 'two')
# => "arg1: 1; arg2: two; arg3: default"

demo_interface.demo(1, 'two', arg3: :three)
# => "arg1: 1; arg2: two; arg3: three"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/watmin/injected. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/watmin/injected/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Injected project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/watmin/injected/blob/master/CODE_OF_CONDUCT.md).
