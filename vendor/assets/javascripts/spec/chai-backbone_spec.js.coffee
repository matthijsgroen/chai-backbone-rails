
describe 'Chai-Backbone', ->

  describe 'trigger / when', ->

    it 'asserts if a trigger is fired', ->
      m = new Backbone.Model
      m.should.trigger('change').when ->
        m.set fire: 'trigger'

    it 'asserts if a trigger is not fired', ->
      m = new Backbone.Model
      m.should.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

    it 'knows the negate state in the chain', ->
      m = new Backbone.Model
      m.should.trigger('change').and.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

  describe 'assert backbone routes', ->
    routerClass = null
    router = null

    before ->
      routerClass = class extends Backbone.Router
        routes:
          'route1/sub': 'subRoute'
          'route2/:par1': 'routeWithArg'
        subRoute: ->
        routeWithArg: (arg) ->

    beforeEach ->
      router = new routerClass

    it 'checks if a method is trigger by route', ->
      "route1/sub".should.route.to router, 'subRoute'

    it 'verifies argument parsing', ->
      "route2/argVal".should.route.to router, 'routeWithArg', with: ['argVal']

    it 'leaves the `to` keyword working properly', ->
      expect('1').to.be.equal '1'

