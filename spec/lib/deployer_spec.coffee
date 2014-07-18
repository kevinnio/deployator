Deployer = require '../../lib/deployer'
GithubAdapter = require '../../lib/adapters/github'

options = {
  githubAdapter: new GithubAdapter({
    user: 'kevinpderezm',
    repo: 'hellocat',
    token: '6a31272a5b85e5936254ebd18a0e4ea31867c8b5'
  }),
  herokuApp: 'hellocat',
  herokuToken: 'fc87fa24-4d8d-4073-94ca-4c0d09649e75'
}
badOptions = {
  herokuApp: 'hellocat',
  herokuToken: 'fakeToken2'
}
deployer = new Deployer(options)
badDeployer = new Deployer(badOptions)

describe 'The Deployer class', ->
  it 'has a deploy method', ->
    expect(deployer.deploy).toBeDefined()

  describe 'checks correctly for', ->
    it 'heroku app access', (done) ->
      deployer.checkHerokuAccess (access, err) ->
        expect(access).toBe true
        done()

  describe 'when there are access errors', ->
    describe 'returns a simple error message for access to', ->
      it 'heroku app', (done) ->
        badDeployer.checkHerokuAccess (access, err) ->
          expect(access).toBe false
          expect(err).toEqual "Can't access Heroku app data!"
          done()

