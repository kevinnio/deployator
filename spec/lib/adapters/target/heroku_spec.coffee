HerokuAdapter = require '../../../../lib/adapters/target/heroku'
adapter = new HerokuAdapter({
  environments: {
    production: {
      app: "hellocat",
      token: "fc87fa24-4d8d-4073-94ca-4c0d09649e75"
    }
  }
})
badAdapter = new HerokuAdapter({
  environments: {
    production: {
      app: "non-existent-app",
      token: "fake-token"
    }
  }
})

describe 'The Heroku adapter', ->
  describe 'fulfills a target adapter definition', ->
    it 'has a checkAccess method', ->
      expect(adapter.checkAccess).toBeDefined()

    it 'has a appExists method', ->
      expect(adapter.appExists).toBeDefined()

    it 'has a requestBuild method', ->
      expect(adapter.requestBuild).toBeDefined()

  describe 'checks correctly for', ->
    it 'heroku app access', (done) ->
      adapter.checkAccess 'production', (access, err) ->
        expect(access).toBe true
        done()

  describe 'when there are access errors', ->
    describe 'returns a simple error message for access to', ->
      it 'heroku app', (done) ->
        badAdapter.checkAccess 'production', (access, err) ->
          expect(access).toBe false
          expect(err).toBeTruthy()
          done()

  describe 'can tell if a Heroku app', ->
    it "exists", (done) ->
      adapter.appExists 'production', (exists, err) ->
        expect(exists).toBe true
        done()

    it "doesn't exists", (done) ->
      badAdapter.appExists 'production', (exists, err) ->
        expect(exists).toBe false
        expect(err).toBeTruthy()
        done()

