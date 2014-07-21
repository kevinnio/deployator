fs = require 'fs'

class Deployable
  constructor: (name, originAdapter, targetAdapter, data) ->
    @name = name
    @origin = originAdapter
    @target = targetAdapter

# ----------------- #

Deployable.loadFile = (file, cb) ->
  contents = fs.readFileSync file, 'utf8'
  if contents
    deployables = []
    try
      deployables = buildDeployables JSON.parse(contents)
    catch err
      console.log err
  else
    # Error
  deployables

buildDeployables = (deployables) ->
  result = []
  for name, data of deployables
    origin = originAdapter(data.origin.adapter, data.origin)
    target = targetAdapter(data.target.adapter, data.target)
    result.push new Deployable(name, origin, target, data)
  result

originAdapter = (klass, data) ->
  buildAdapter('origin', klass, data)

targetAdapter = (klass, data) ->
  buildAdapter('target', klass, data)

buildAdapter = (type, klass, data) ->
  Adapter = require("./adapters/#{type}/#{klass}.coffee")
  new Adapter(data)

# ----------------- #

module.exports = Deployable

