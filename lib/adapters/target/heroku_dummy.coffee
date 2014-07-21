HEROKU_TOKEN = 'fc87fa24-4d8d-4073-94ca-4c0d09649e75'
APPS = ['hellocat', 'my-other-app']

class HerokuDummyAdapter
  constructor: (opts) ->
    @environments = opts.environments
    @messages = {
      genericError: "whoa! there was an unknown error at Heroku side. rlly srry"
      accessDenied: "seems I'm not allowed to go into #{@app}! srry",
      appDoesntExists: "wait! there's no '#{@app}' app hosted at Heroku!"
    }

  checkAccess: (env, cb) ->
    env = @environments[env]
    if env.token == HEROKU_TOKEN
      cb(true)
    else
      cb(false, @messages.accessDenied)

  appExists: (env, cb) ->
    env = @environments[env]
    if env.app in APPS
      cb(true)
    else
      cb(false, @messages.appDoesntExists)

# ---------------------- #

module.exports = HerokuDummyAdapter
