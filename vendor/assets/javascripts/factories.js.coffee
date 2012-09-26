
window.Factory =
  factories: {}

  define: (factoryName, builder) ->
    if factoryName.indexOf('-') > 0
      throw "Factory name '#{factoryName}' can't use - in name. It clashes with the traits construct"
    if @factories[factoryName]?
      throw "Factory #{factoryName} is already defined"
    @factories[factoryName] = builder

  create: (nameWithTraits, options) ->
    traits = nameWithTraits.split '-'
    factoryName = traits.pop()
    unless @factories[factoryName]?
      throw "Factory #{factoryName} does not exist"
    @factories[factoryName] options, traits...

  resetFactories: ->
    @factories = []



