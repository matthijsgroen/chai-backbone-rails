
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

  describe 'change', ->

    describe 'by delta', ->

      it 'asserts the delta of a change', ->
        result = 1
        expect(-> result).to.change.by(3).when -> result += 3

      it 'reports the contents of the subject method', ->
        result = 1
        expect(->
          (-> 1 + 3; result).should.change.by(3).when -> result += 2
        ).to.throw 'expected `1 + 3;result;` to change by 3, but it changed by 2'

      it 'can be negated to not.change', ->
        result = 1
        expect(->
          expect(-> result).to.not.change.when -> result += 2
        ).to.throw 'expected `result;` not to change, but it changed by 2'
        expect(-> result).to.not.change.when -> 1 + 3

    describe 'to', ->

      it 'asserts end values', ->
        result = ['a']
        expect(-> result).to.change.to(['b']).when -> result = ['b']

      it 'reports the mismatched end value', ->
        result = ['a']
        expect(->
          expect(-> result).to.change.to(['b']).when -> result = ['c']
        ).to.throw 'expected `result;` to change to [ \'b\' ], but it changed to [ \'c\' ]'

      it 'raises an error if there was no change', ->
        result = 'b'
        expect(->
          expect(-> result).to.change.to('b').when -> result = 'b'
        ).to.throw 'expected `result;` to change to \'b\', but it was already \'b\''

    describe 'from', ->

      it 'asserts start values', ->
        result = ['a']
        expect(-> result).to.change.from(['a']).when -> result = ['b']

      it 'reports the mismatched start value', ->
        result = ['a']
        expect(->
          expect(-> result).to.change.from(['b']).when -> result = ['c']
        ).to.throw 'expected `result;` to change from [ \'b\' ], but it changed from [ \'a\' ]'

      it 'raises an error if there was no change', ->
        result = 'b'
        expect(->
          expect(-> result).to.change.from('b').when -> result = 'b'
        ).to.throw 'expected `result;` to change from \'b\', but it did not change'


    describe 'mix and match', ->

      it 'can use from to and by in one sentence', ->
        result = 3
        expect(-> result).to.change.from(3).to(5).by(2).when -> result = 5
