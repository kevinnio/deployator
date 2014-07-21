Deployer = require '../../lib/deployer'
deployer = new Deployer()

describe 'The Deployer class', ->
  it 'has a deploy method', ->
    expect(deployer.deploy).toBeDefined()

  it 'can find a deployable given its name', ->
    deployable = deployer.findDeployable('hellocat')
    expect(deployable).toBeTruthy()
    expect(deployable.name).toEqual 'hellocat'

  it 'deploys a repo branch to a target environment', (done) ->
    deployer.deploy 'hellocat', 'master', 'production', (message, err) ->
      expect(message).toBeTruthy()
      console.log err
      done()
  , 15000

