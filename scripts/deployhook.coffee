# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    res.end()
    console.log 'Github has notified a deployment'
    payload = JSON.parse(req.body.payload).payload
    addDeployment buildDeployment(payload), robot
    console.log deployments

  robot.router.post '/deploy-status/heroku', (req, res) ->
    res.end()
    console.log 'Heroku notifies about deploy success'
    console.log req.body
    dep = findLastDeploymentOf(req.body.app)
    if dep
      console.log 'Matching deployment found'
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
