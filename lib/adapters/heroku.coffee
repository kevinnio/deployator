https = require 'https'

class HerokuAdapter
  constructor: (opts) ->
    @app = opts.app
    @token = opts.token

  checkAccess: (cb) ->
    https.get @request("/apps/#{@app}"), (res) =>
      @checkForStatus res, 200, "Can't access Heroku app data!", cb

  request: (path) ->
    {
      hostname: 'api.heroku.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.heroku+json; version=3',
        'Authorization': "Bearer #{@token}",
        'User-Agent': 'hubot'
      }
    }

  checkForStatus: (res, status, err, cb) ->
    if res.statusCode == status then cb(true) else cb(false, err)

# ---------------------- #

module.exports = HerokuAdapter
