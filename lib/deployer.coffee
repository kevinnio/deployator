https = require 'https'

class Deployer
  deploy: (deployable, environment, cb) ->
    cb(true)


# ----------------------- #

module.exports = Deployer
