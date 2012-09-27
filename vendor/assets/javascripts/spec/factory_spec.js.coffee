#= require ./../factories

describe 'Factory', ->

  beforeEach ->
    Factory.define 'user', (options = {}, traits...) ->
      [options, traits]

  afterEach ->
    Factory.resetFactories()

  describe '::define', ->

    it 'registers a factory', ->
      result = Factory.create 'user'
      result[0].should.deep.equal {}
      result[1].should.deep.equal []

    it 'raises an error on existing factory', ->
      expect(-> Factory.define('user', ->)).to.throw 'Factory user is already defined'

    it 'raises an error on naming conflict with traits', ->
      expect(-> Factory.define('admin-user', ->)).to.throw 'Factory name \'admin-user\' can\'t use - in name. It clashes with the traits construct'

  describe '::create', ->

    it 'delivers options to the callback', ->
      result = Factory.create 'user'
        hello: 'world'
        other: 'value'
      result[0].should.deep.equal { hello: 'world', other: 'value' }

    it 'delivers traits to the callback', ->
      result = Factory.create 'male-admin-user'
      result[1].should.deep.equal ['male', 'admin']


  describe 'helpers', ->

    describe 'sequence', ->

      beforeEach ->
        Factory.define 'counter', (options = {}, traits...) ->
          @sequence('property')

        Factory.define 'otherCounter', (options = {}, traits...) ->
          @sequence('property')

        Factory.define 'abc', (options = {}, traits...) ->
          @sequence((c) -> ['a', 'b', 'c'][c])

      it 'provides sequencers scoped to factory and property', ->
        Factory.create('counter').should.equal 0
        Factory.create('otherCounter').should.equal 0
        Factory.create('counter').should.equal 1

      it 'can yield results', ->
        Factory.create('abc').should.equal 'a'
        Factory.create('abc').should.equal 'b'

