# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    console.log 'Github has notified a deployment status change'
    payload = JSON.parse req.body.payload
    deploymentPayload = payload.deployment.payload
    deployments.push({
      name: deploymentPayload.name,
      room: deploymentPayload.notify.room,
      user: deploymentPayload.notify.user
    })
    console.log deployments
