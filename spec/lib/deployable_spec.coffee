Deployable = require '../../lib/deployable'
deployableList = []

describe 'The Deployable class', ->
  it 'can instantiate deployable objects from a file', (done) ->
    Deployable.loadFile 'spec/deployables.json', (deployables) ->
      deployableList = deployables
      expect(deployableList.length).toBeGreaterThan 0
      done()

  it 'adds some singleton methods to deployables array', (done) ->
    Deployable.loadFile 'spec/deployables.json', (deployables) ->
      deployableList = deployables
      expect(deployableList.find).toBeDefined()
      done()
