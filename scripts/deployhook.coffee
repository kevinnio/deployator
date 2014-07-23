# Description:
#   Listens for webhooks that notify about deploy events.
#

deployments = []

module.exports = (robot) ->
  robot.router.post '/deploy-status/github', (req, res) ->
    console.log 'Github has notified a deployment'
    payload = JSON.parse req.body.payload
    console.log payload
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


addDeployment = (dep, robot) ->
  setErrorTimeout(dep, robot)
  deployments.push(dep)

setErrorTimeout = (dep, robot) ->
  setTimeout(->
    if dep in deployments
      robot.messageRoom(
        dep.room,
        "#{dep.user}: Seems that deploy of #{dep.name} has failed..."
      )
      deleteDeployment dep
  , minutes(15))

minutes = (quantity) ->
  quantity * 1000 * 60

findLastDeploymentOf = (name) ->
  for deployment in deployments
    return deployment if deployment.name == name

deleteDeployment = (deployment) ->
  index = deployments.indexOf(deployment)
  delete deployments[index]
