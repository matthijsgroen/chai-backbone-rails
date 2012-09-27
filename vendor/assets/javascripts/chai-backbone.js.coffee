#= require underscore

((chaiBackbone) ->
  # Module systems magic dance.
  if (typeof require == "function" && typeof exports == "object" && typeof module == "object")
    # NodeJS
    module.exports = chaiBackbone
  else if (typeof define == "function" && define.amd)
    # AMD
    define -> chaiBackbone
  else
    # Other environment (usually <script> tag): plug in to global chai instance directly.
    chai.use chaiBackbone
)((chai, utils) ->
  inspect = utils.inspect
  flag = utils.flag

  # Verifies if the subject fires a trigger 'when' events happen
  #
  # Examples:
  #   model.should.trigger("change", with: [model]).when -> model.set attribute: "value"
  #   model.should.not.trigger("change:thing").when -> model.set attribute: "value"
  #   model.should.trigger("change").and.not.trigger("change:thing").when -> model.set attribute: "value"
  #
  # @param trigger the trigger expected to be fired
  chai.Assertion.addMethod 'trigger', (trigger, options = {}) ->
    definedActions = flag(this, 'whenActions') || []

    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')

      # set up the callback to trigger
      before: (context) ->
        @callback = sinon.spy()
        flag(context, 'object').on trigger, @callback

      # verify if our callback is triggered
      after: (context) ->
        negate = flag(context, 'negate')
        flag(context, 'negate', @negate)
        context.assert @callback.calledOnce,
          "expected to trigger #{trigger}",
          "expected not to trigger #{trigger}"

        if options.with?
          context.assert @callback.calledWith(options.with...),
            "expected trigger to be called with #{inspect options.with}, but was called with #{inspect @callback.args[0]}.",
            "expected trigger not to be called with #{inspect options.with}, but was"
        flag(context, 'negate', negate)
    flag(this, 'whenActions', definedActions)

  chai.Assertion.addMethod 'when', (val) ->
    definedActions = flag(this, 'whenActions') || []

    action.before?(this) for action in definedActions
    val() # execute the 'when'
    action.after?(this) for action in definedActions

  # Verify if a url fragment is routed to a certain method on the router
  # Options:
  # - you can consider multiple routers to test routing priorities
  # - you can indicate expected arguments to test url extractions
  #
  # Examples:
  #
  #   class MyRouter extends Backbone.Router
  #     routes:
  #       "home/:page/:other": "homeAction"
  #
  #   myRouter = new MyRouter
  #
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction")
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", arguments: ["stuff", "thing"])
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", consider: [otherRouterWithPossiblyConflictingRoute])
  #
  chai.Assertion.addProperty 'route', ->
    flag(this, 'routing', true)

  routeTo = (router, methodName, options = {}) ->
    # move possible active Backbone history out of the way temporary
    current_history = Backbone.history

    # reset history to clear active routes
    Backbone.history = new Backbone.History

    spy = sinon.spy router, methodName # spy on our expected method call
    router._bindRoutes() # inject router routes into our history
    if options.considering? # if multiple routers are provided load their routes aswell
      consideredRouter._bindRoutes() for consideredRouter in options.considering

    # manually set the root option to prevent calling Backbone.history.start() which is global
    Backbone.history.options =
      root: '/'

    route = flag(this, 'object')
    # fire our route to test
    Backbone.history.loadUrl route

    # set back our history. The spy should have our collected info now
    Backbone.history = current_history
    # restore the router method
    router[methodName].restore()

    # now assert if everything went according to spec
    @assert spy.calledOnce,
      "expected `#{route}` to route to #{methodName}",
      "expected `#{route}` not to route to #{methodName}"

    # verify arguments if they were provided
    if options.arguments?
      @assert spy.calledWith(options.arguments...),
        "expected `#{methodName}` to be called with #{inspect options.arguments}, but was called with #{inspect spy.args[0]} instead",
        "expected `#{methodName}` not to be called with #{inspect options.arguments}, but was"

  chai.Assertion.addChainableMethod 'to', routeTo, -> this


  ###
  #
  # Changes Matchers
  #
  ###

  noChangeAssert = (context) ->
    relevant = flag(context, 'no-change')
    return unless relevant

    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    startValue = flag(context, 'changeStart')
    endValue = object()
    actualDelta = endValue - startValue

    result = (0 is actualDelta)
    result = !result if negate
    context.assert result,
      "not supported"
      "expected `#{formatFunction object}` not to change, but it changed by #{actualDelta}",
    flag(context, 'negate', negate)

  changeByAssert = (context) ->
    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    startValue = flag(context, 'changeStart')
    endValue = object()
    actualDelta = endValue - startValue

    result = (@expectedDelta is actualDelta)
    result = !result if negate
    context.assert result,
      "expected `#{formatFunction object}` to change by #{@expectedDelta}, but it changed by #{actualDelta}",
      "not supported"
    flag(context, 'negate', negate)

  changeToBeginAssert = (context) ->
    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    startValue = object()

    result = !utils.eql(startValue, @expectedEndValue)
    result = !result if negate
    context.assert result,
      "expected `#{formatFunction object}` to change to #{utils.inspect @expectedEndValue}, but it was already #{utils.inspect startValue}",
      "not supported"
    flag(context, 'negate', negate)

  changeToAssert = (context) ->
    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    endValue = object()

    result = utils.eql(endValue, @expectedEndValue)
    result = !result if negate
    context.assert result,
      "expected `#{formatFunction object}` to change to #{utils.inspect @expectedEndValue}, but it changed to #{utils.inspect endValue}",
      "not supported"
    flag(context, 'negate', negate)

  changeFromBeginAssert = (context) ->
    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    startValue = object()

    result = utils.eql(startValue, @expectedStartValue)
    result = !result if negate
    context.assert result,
      "expected `#{formatFunction object}` to change from #{utils.inspect @expectedStartValue}, but it changed from #{utils.inspect startValue}",
      "not supported"
    flag(context, 'negate', negate)

  changeFromAssert = (context) ->
    negate = flag(context, 'negate')
    flag(context, 'negate', @negate)
    object = flag(context, 'object')

    startValue = flag(context, 'changeStart')
    endValue = object()

    result = !utils.eql(startValue, endValue)
    result = !result if negate
    context.assert result,
      "expected `#{formatFunction object}` to change from #{utils.inspect @expectedStartValue}, but it did not change"
      "not supported"
    flag(context, 'negate', negate)

  # Verifies if the subject return value changes by given delta 'when' events happen
  #
  # Examples:
  #   (-> resultValue).should.change.by(1).when -> resultValue += 1
  #
  chai.Assertion.addProperty 'change', ->
    flag(this, 'no-change', true)

    definedActions = flag(this, 'whenActions') || []
    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')

      # set up the callback to trigger
      before: (context) ->
        startValue = flag(context, 'object')()
        flag(context, 'changeStart', startValue)
      after: noChangeAssert

    flag(this, 'whenActions', definedActions)

  formatFunction = (func) ->
    func.toString().replace(/^\s*function \(\) {\s*/, '').replace(/\s+}$/, '').replace(/\s*return\s*/, '')

  changeBy = (delta) ->
    flag(this, 'no-change', false)
    definedActions = flag(this, 'whenActions') || []
    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')
      expectedDelta: delta
      after: changeByAssert
    flag(this, 'whenActions', definedActions)

  chai.Assertion.addChainableMethod 'by', changeBy, -> this

  changeTo = (endValue) ->
    flag(this, 'no-change', false)
    definedActions = flag(this, 'whenActions') || []
    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')
      expectedEndValue: endValue
      before: changeToBeginAssert
      after: changeToAssert
    flag(this, 'whenActions', definedActions)

  chai.Assertion.addChainableMethod 'to', changeTo, -> this

  changeFrom = (startValue) ->
    flag(this, 'no-change', false)
    definedActions = flag(this, 'whenActions') || []
    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')
      expectedStartValue: startValue
      before: changeFromBeginAssert
      after: changeFromAssert
    flag(this, 'whenActions', definedActions)

  chai.Assertion.addChainableMethod 'from', changeFrom, -> this

)

