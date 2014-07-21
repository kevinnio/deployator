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
    env = @getEnv(env)
    https.get @request(env, "/apps/#{env.app}"), (res) =>
      switch res.statusCode
        when 200 # OK
          cb true
        when 401 # Unauthorized
          cb false, @messages.accessDenied
        else
          cb false, @messages.genericError

  appExists: (env, cb) ->
    env = @getEnv(env)
    https.get @request(env, "/apps/#{env.app}"), (res) =>
      switch res.statusCode
        when 200 # OK
          cb true
        when 404 # Not Found
          cb false, @messages.appDoesntExists
        else
          cb false, @messages.genericError

  deploy: (env, tarballURL, cb) ->
    env = @getEnv(env)
    request = https.request @deployOpts(env), (res) =>
      switch res.statusCode
        when 201 # Created
          cb true
        else
          cb false, @messages.genericError
    request.write JSON.stringify(@deployBody(tarballURL))
    request.end()

  getEnv: (name) ->
    if @environments[name]
      @environments[name]
    else
      throw InvalidEnvError("No such environment '#{name}'")

  deployOpts: (env) ->
    opts = @request(env, "/apps/#{env.app}/builds")
    opts.method = 'POST'
    opts

  request: (env, path) ->
    encodedToken = new Buffer(":#{env.token}").toString('base64')
    {
      hostname: 'api.heroku.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.heroku+json; version=3',
        'Authorization': encodedToken,
        'User-Agent': 'hubot'
      }
    }

  deployBody: (tarballURL) ->
    {
      source_blob: {
        url: tarballURL,
      }
    }

# ---------------------- #

module.exports = HerokuAdapter
