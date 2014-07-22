# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    console.log 'Github has notified a deployment status change'
    deployments.push req.body.payload.payload.notify
    console.log deployments
