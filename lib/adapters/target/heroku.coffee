https = require 'https'

class HerokuAdapter
  constructor: (opts) ->
    @environments = opts.environments
    @messages = {
      genericError: "whoa! there was an unknown error at Heroku side. rlly srry"
      accessDenied: "seems I'm not allowed to go into #{@app}! srry",
      appDoesntExists: "wait! there's no '#{@app}' app hosted at Heroku!"
    }

  checkAccess: (cb) ->
    https.get @request("/apps/#{@app}"), (res) =>
      switch res.statusCode
        when 200
          cb true
        when 401
          cb false, @messages.accessDenied
        else
          cb false, @messages.genericError

  appExists: (app, cb) ->
    https.get @request("/apps/#{app}"), (res) =>
      switch res.statusCode
        when 200
          cb true
        when 404
          cb false, @messages.appDoesntExists
        else
          cb false, @messages.genericError

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
