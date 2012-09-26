Backbone::Chai
==============

- Adds Chai matchers for common backbone assertions
- Adds Chai matchers for common sinon assertions
- Adds support for Factories

Installation
------------

Add this line to your application's Gemfile:

    gem 'chai-backbone-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chai-backbone-rails

Using Backbone Chai Matchers
----------------------------

    #= require chai-backbone

### Triggers

    model.should.trigger("change", with: [model]).when -> model.set attribute: "value"

this can also be chained further:

    model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
    model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"

### Routing

    "page/3".should.route.to myRouter, "openPage", arguments: ["3"]
    "page/3".should.route.to myRouter, "openPage", considering: [conflictingRouter]

Using Sinon Chai Matchers
-------------------------

Matchers have also been added for sinonjs.

    #= require chai-sinon

These are not complete yet, see tests and code for details.

    spy.should.have.been.called.exactly(x).times
    spy.should.have.been.called.before otherSpy
    spy.should.have.been.called.after otherSpy
    spy.should.have.been.called.with "argument1", 2, "argument3"
    spy.should.not.have.been.called

Using Factories
--------------

Factory support is added to quickly be able to build backbone models or
other objects as you see fit:

    #= require factories

    Factory.define 'user', (attributes = {}) ->
      new User attributes

    Factory.create 'user', name: 'Matthijs'

you can also use 'traits':

    Factory.define 'user', (attributes = {}, traits...) ->
      if traits.indexOf('male') isnt -1
        attributes.gender = 'male'

      returningClass = User
      if traits.indexOf('admin') isnt -1
        returningClass = AdminUser

      new returningClass attributes

    Factory.create 'user', name: 'Matthijs' # => new User name: 'Matthijs'
    Factory.create 'male-user', name: 'Matthijs' # => new User name: 'Matthijs', gender: 'male'
    Factory.create 'male-admin-user', name: 'Matthijs' # => new AdminUser name: 'Matthijs', gender: 'male'

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
