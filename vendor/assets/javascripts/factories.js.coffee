sequencer = (property) ->
  value = if @sequences[property]?
    @sequences[property] += 1
  else
    @sequences[property] = 0
  if typeof(property) is 'function'
    property(value)
  else
    value

window.Factory =
  factories: {}

  define: (factoryName, builder) ->
    if factoryName.indexOf('-') > 0
      throw "Factory name '#{factoryName}' can't use - in name. It clashes with the traits construct"
    if @factories[factoryName]?
      throw "Factory #{factoryName} is already defined"
    @factories[factoryName] =
      sequences: {}
      factory: builder
      sequence: sequencer

  create: (nameWithTraits, options) ->
    traits = nameWithTraits.split '-'
    factoryName = traits.pop()
    unless @factories[factoryName]?
      throw "Factory #{factoryName} does not exist"
    @factories[factoryName].factory options, traits...

  resetFactories: ->
    @factories = []



