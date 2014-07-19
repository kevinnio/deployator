GithubAdapter = require '../../lib/adapters/github_dummy'
HerokuAdapter = require '../../lib/adapters/heroku_dummy'
Deployer = require '../../lib/deployer'

githubAdapter = new GithubAdapter({
  user: 'kevindperezm',
  repo: 'hellocat',
  token: '6a31272a5b85e5936254ebd18a0e4ea31867c8b5'
})
herokuAdapter = new HerokuAdapter({
  app: 'hellocat',
  token: 'fc87fa24-4d8d-4073-94ca-4c0d09649e75'
})

deployer = new Deployer({
  githubAdapter: githubAdapter,
  herokuAdapter: herokuAdapter
})

describe 'The Deployer class', ->
  it 'has a deploy method', ->
    expect(deployer.deploy).toBeDefined()

  it 'deploys a branch to a heroku app', (done) ->
    deployer.deploy 'hellocat', 'add-cool-feature', 'production', (success, err) ->
      expect(success).toBe true
      done()

