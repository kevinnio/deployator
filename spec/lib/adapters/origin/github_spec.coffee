GithubAdapter = require '../../../../lib/adapters/origin/github'

options = {
  user: 'kevindperezm',
  repo: 'hellocat',
  token: '6a31272a5b85e5936254ebd18a0e4ea31867c8b5'
}
badOptions = {
  user: 'kevindperezm',
  repo: 'hellocat',
  token: 'fakeToken'
}
adapter = new GithubAdapter(options)
badAdapter = new GithubAdapter(badOptions)

describe 'The Github adapter', ->
  describe 'fulfills an origin adapter definition', ->
    it 'has a checkAccess method', ->
      expect(adapter.checkAccess).toBeDefined()

    it 'has a branchExists method', ->
      expect(adapter.branchExists).toBeDefined()

    it 'has a getTarballURL method', ->
    expect(adapter.getTarballURL).toBeDefined()

  describe 'checks correctly for', ->
    it 'github user access', (done) ->
      adapter.checkUserAccess (access, err) ->
        expect(access).toBe true
        done()

    it 'github repo access', (done) ->
      adapter.checkRepoAccess (access, err) ->
        expect(access).toBe true
        done()

  describe 'when there are access errors', ->
    describe 'returns a simple error message for', ->
      it 'github user', (done) ->
        badAdapter.checkUserAccess (access, err) ->
          expect(access).toBe false
          expect(err).toBeTruthy()
          done()

      it 'github repo', (done) ->
        badAdapter.checkRepoAccess (access, err) ->
          expect(access).toBe false
          expect(err).toBeTruthy()
          done()

  describe 'when trying to access a github repo branch', ->
    it 'checks if it exists', (done)->
      adapter.branchExists 'add-cool-feature', (exists, err) ->
        expect(exists).toBe true
        done()

    it 'returns an error message if it not exists', (done) ->
      adapter.branchExists 'non-existing-branch', (exists, err) ->
        expect(exists).toBe false
        expect(err).toBeTruthy()
        done()
