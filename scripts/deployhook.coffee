# Description:
#   Listens for webhooks that notify about deploy events.
#

module.exports = (robot) ->
  robot.router.post '/hubot/deploy_status', (req, res) ->
    console.log req.body

