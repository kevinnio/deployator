Deployer = require '../../lib/deployer'
options = {
  githubUser: 'kevindperezm',
  githubRepo: 'hellocat',
  githubToken: '6a31272a5b85e5936254ebd18a0e4ea31867c8b5',
  herokuApp: 'hellocat',
  herokuToken: 'fc87fa24-4d8d-4073-94ca-4c0d09649e75'
}
deployer = new Deployer(options)

describe 'The Deployer class', ->
  it 'has a deploy method', ->
    expect(deployer.deploy).toBeDefined()

  expectSuccessfulAccess = (access, err) ->
    expect(err).toBeUndefined()
    expect(access).toBe true

  it 'checks for github user access', (done) ->
    deployer.checkGithubUserAccess (access, err) ->
      expectSuccessfulAccess(access, err)
      done()

  it 'checks for github repo access', (done) ->
    deployer.checkGithubRepoAccess (access, err) ->
      expectSuccessfulAccess(access, err)
      done()

  it 'checks for heroku app access', (done) ->
    deployer.checkHerokuAccess (access, err) ->
      expectSuccessfulAccess(access, err)
      done()

