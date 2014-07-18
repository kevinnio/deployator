# Description:
#   Deploys from GitHub repo to Heroku.
#
# Commands:
#   hubot deploy - deploys a GitHub repo to Heroku
#

Deployer = require '../lib/deployer'

module.exports = (robot) ->
  robot.respond /(deploy)/i, (mssg) ->
    deployer = new Deployer
    deployer.deploy (message) ->
      mssg.send(message)
