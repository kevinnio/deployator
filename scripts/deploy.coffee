# Description:
#   Deploys from GitHub repo to Heroku.
#
# Commands:
#   hubot deploy - deploys a GitHub repo to Heroku
#

module.exports = (robot) ->
  robot.respond /(deploy)/i, (mssg) ->
    mssg.send 'Work in progress!'
