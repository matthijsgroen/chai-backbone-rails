# Backbone::Chai

Some matchers to help testing backbone structures.

## Installation

Add this line to your application's Gemfile:

    gem 'chai-backbone-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chai-backbone-rails

## Usage

    #= require chai-backbone

### Triggers

    model.should.trigger("change", with: [model]).when -> model.set attribute: "value"

this can also be chained further:

    model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
    model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"

### Routing

    "page/3".should.route.to myRouter, "openPage", arguments: ["3"]
    "page/3".should.route.to myRouter, "openPage", considering: [conflictingRouter]

### Sinon (will be ported soon!)

Matchers have also been added for sinonjs. 

    #= require sinon-chai
    chai.use sinonChai

These are not complete yet, see tests and code for details.

    spy.should.have.been.called.exactly(x).times
    spy.should.have.been.called.before otherSpy
    spy.should.have.been.called.after otherSpy
    spy.should.have.been.called.with "argument1", 2, "argument3"
    spy.should.have.been.not_called

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
