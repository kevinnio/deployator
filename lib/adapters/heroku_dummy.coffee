HEROKU_TOKEN = 'fc87fa24-4d8d-4073-94ca-4c0d09649e75'
APPS = ['hellocat', 'my-other-app']

class HerokuDummyAdapter
  constructor: (opts) ->
    @app = opts.app
    @token = opts.token
    @messages = {
      genericError: "whoa! there was an unknown error at Heroku side. rlly srry"
      accessDenied: "seems I'm not allowed to go into #{@app}! srry",
      appDoesntExists: "wait! there's no '#{@app}' app hosted at Heroku!"
    }

  checkAccess: (cb) ->
    if @token == HEROKU_TOKEN
      cb(true)
    else
      cb(false, @messages.accessDenied)

  appExists: (app, cb) ->
    if app in APPS
      cb(true)
    else
      cb(false, @messages.appDoesntExists)

# ---------------------- #

module.exports = HerokuDummyAdapter
