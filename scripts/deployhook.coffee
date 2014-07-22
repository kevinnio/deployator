# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    console.log 'Github has notified a deployment status change'
    deployment = JSON.parse(req.body.payload).payload.notify
    deployments.push deployment
    console.log deployments
