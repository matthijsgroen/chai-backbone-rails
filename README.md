Chai-Backbone-Rails
===================

- Adds Chai matchers to assert changes
- Adds Chai matchers for common backbone assertions
- Adds support for Factories

Installation
------------

Add this line to your application's Gemfile:

    gem 'chai-backbone-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chai-backbone-rails

Dependencies
------------

The provided libraries have dependencies to
[backbone](http://documentcloud.github.com/backbone/),
[underscore](http://documentcloud.github.com/underscore/) and
[sinon](http://sinonjs.org/)

to install these dependencies, you can add the following to your
`Gemfile`:

    gem 'sinonjs-rails'
    gem 'rails-backbone'

and in your `spec_helper`:

    #= require sinon/sinon-1.5.0
    #= require underscore
    #= require backbone
    #= require chai-backbone-rails


Using Changes Chai matchers
---------------------------

    #= require chai-changes

See [the Chai-changes plugin page](http://chaijs.com/plugins/chai-changes)

or [the Node.js package page](https://npmjs.org/package/chai-changes)


Using Backbone Chai Matchers
----------------------------

    #= require chai-backbone

See [the Chai-backbone plugin page](http://chaijs.com/plugins/chai-backbone)

or [the Node.js package page](https://npmjs.org/package/chai-backbone)


Using Factories
---------------

Factory support is added to quickly be able to build backbone models or
other objects as you see fit:

    #= require factories

See [the Node.js package page](https://npmjs.org/package/js-factories)


Running the tests
=================

You can run the tests by including:

    #= require chai-backbone_spec

or you can run the suites seperately:

    #= require spec/chai-backbone_spec
    #= require spec/chai-changes_spec
    #= require spec/factory_spec


Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Todo
----

- Add a rake task to update dependencies

