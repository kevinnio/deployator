Deployer = require '../../lib/deployer'
deployer = new Deployer

describe 'The Deployer class', ->
  it 'has a deploy method', ->
    expect(deployer.deploy).toBeDefined()

