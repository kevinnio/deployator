# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

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
  dep = findLastDeploymentOf app
  if dep
    console.log "Matching deployment found: Deployment of #{dep.name}"
    robot.messageRoom dep.room, "#{dep.user}: Deployment of #{dep.name} done!"
    deleteDeployment dep
  else
    console.log 'No matching deployment found'

buildDeployment = (payload) ->
  {
    name: payload.name,
    room: payload.notify.room,
    user: payload.notify.user
  }

addDeployment = (dep, robot) ->
  setErrorTimeout(dep, robot)
  deployments.push(dep)

setErrorTimeout = (dep, robot) ->
  setTimeout (-> errorTimeout(dep, robot)), minutes(15)

errorTimeout = (dep, robot) ->
  if dep in deployments
    console.log "Heroku never notified about a deployment of #{dep.name}"
    console.log "Deployment of #{dep.name} failed"
    robot.messageRoom(
      dep.room,
      "#{dep.user}: Seems that deploy of #{dep.name} has failed..."
    )
    deleteDeployment dep

minutes = (quantity) ->
  quantity * 1000 * 60

findLastDeploymentOf = (name) ->
  for deployment in deployments
    return deployment if deployment.name == name

deleteDeployment = (deployment) ->
  index = deployments.indexOf(deployment)
  delete deployments[index]
