https = require 'https'

class HerokuAdapter
  constructor: (opts) ->
    console.log opts
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

  checkForStatus: (res, status, err, cb) ->
    if res.statusCode == status then cb(true) else cb(false, err)

# ---------------------- #

module.exports = HerokuAdapter
