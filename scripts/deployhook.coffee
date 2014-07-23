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
    res.end()

  robot.router.post '/deploy-status/heroku', (req, res) ->
    console.log 'Heroku notifies about deploy success'
    console.log req.body
    app = req.body.app
    url = req.body.url
    dep = findLastDeploymentOf app
    if dep
      console.log 'Deployment found'
      console.log dep
      robot.messageRoom dep.room, "#{dep.user}: Deployment of #{dep.name} done!"
      deleteDeployment dep
    else
      console.log 'No deployment found'
    res.end()


findLastDeploymentOf = (name) ->
  for deployment in deployments
    return deployment if deployment.name == name

deleteDeployment = (deployment) ->
  delete deployments[ deployments.indexOf(deployment) ]
