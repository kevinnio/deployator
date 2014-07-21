fs = require 'fs'

class Deployable
  constructor: (name, originAdapter, targetAdapter, data) ->
    @name = name
    @origin = originAdapter
    @target = targetAdapter

# ----------------- #

Deployable.loadFile = (file, cb) ->
  fs.readFile file, 'utf8', (err, contents) ->
    if err
      # con error
    else
      deployables = []
      try
        deployables = buildDeployables JSON.parse(contents)
      catch err
        console.log err
      cb(deployables)

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

