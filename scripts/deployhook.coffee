# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []
deployment_timeout = parseInt(process.env.HUBOT_DEPLOY_TIMEOUT) || 15

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    res.end()
    addDeploymentToQueue JSON.parse(req.body.payload), robot

  robot.router.post '/deploy-status/heroku', (req, res) ->
    res.end()
    notifyDeploymentSuccess(req.body.app, robot)


addDeploymentToQueue = (payload, robot) ->
  payload = payload.payload
  deployment = buildDeployment(payload)
  addDeployment(deployment, robot)
  console.log "Github has notified a deployment of #{deployment.name}"

notifyDeploymentSuccess = (app, robot) ->
  console.log 'Heroku notifies about deployment success'
  deployment = findLastDeploymentOf app
  if deployment
    console.log "Matching deployment found: Deployment of #{deployment.name}"
    robot.messageRoom(
      deployment.room,
      "#{deployment.user}: Deployment of #{deployment.name} done!"
    )
    deleteDeployment deployment
  else
    console.log 'No matching deployment found'

buildDeployment = (payload) ->
  {
    name: payload.name,
    room: payload.notify.room,
    user: payload.notify.user
  }

addDeployment = (deployment, robot) ->
  setErrorTimeout(deployment, robot)
  deployments.push(deployment)

setErrorTimeout = (deployment, robot) ->
  setTimeout (-> errorTimeout(deployment, robot)), minutes(deployment_timeout)

errorTimeout = (deployment, robot) ->
  if deployment in deployments
    console.log "Heroku never notified about a deployment of #{deployment.name}"
    console.log "Deployment of #{deployment.name} failed"
    robot.messageRoom(
      deployment.room,
      "#{deployment.user}: " +
      "Seems that your deploy of #{deployment.name} has failed..."
    )
    deleteDeployment deployment

minutes = (quantity) ->
  quantity * 1000 * 60

findLastDeploymentOf = (name) ->
  for deployment in deployments
    return deployment if deployment.name == name

deleteDeployment = (deployment) ->
  index = deployments.indexOf(deployment)
  delete deployments[index]
