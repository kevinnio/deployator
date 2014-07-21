https = require 'https'

class HerokuAdapter
  constructor: (opts) ->
    @environments = opts.environments
    @messages = {
      genericError: "whoa! there was an unknown error at Heroku side. rlly srry"
      accessDenied: "seems I'm not allowed to go into #{@app}! srry",
      appDoesntExists: "wait! there's no '#{@app}' app hosted at Heroku!"
    }

  checkAccess: (env, cb) ->
    env = @environments[env]
    https.get @request(env, "/apps/#{env.app}"), (res) =>
      switch res.statusCode
        when 200 # OK
          cb true
        when 401 # Unauthorized
          cb false, @messages.accessDenied
        else
          cb false, @messages.genericError

  appExists: (env, cb) ->
    env = @environments[env]
    https.get @request(env, "/apps/#{env.app}"), (res) =>
      switch res.statusCode
        when 200 # OK
          cb true
        when 404 # Not Found
          cb false, @messages.appDoesntExists
        else
          cb false, @messages.genericError

  deploy: (env, tarballURL, cb) ->
    env = @environments[env]
    request = https.request @deployOpts(env), (res) =>
      switch res.statusCode
        when 201 # Created
          cb true
        else
          cb false, @messages.genericError
    request.write JSON.stringify(@deployBody(tarballURL))
    request.end()

  deployOpts: (env) ->
    opts = @request(env, "/apps/#{env.app}/builds")
    opts.method = 'POST'
    opts

  request: (env, path) ->
    {
      hostname: 'api.heroku.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.heroku+json; version=3',
        'Authorization': "Bearer #{env.token}",
        'User-Agent': 'hubot'
      }
    }

  deployBody: (tarballURL) ->
    {
      source_blob: {
        url: tarballURL,
      }
    }

  checkForStatus: (res, status, err, cb) ->
    if res.statusCode == status then cb(true) else cb(false, err)

# ---------------------- #

module.exports = HerokuAdapter
