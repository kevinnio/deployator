# Description:
#   Listens for webhooks that notify about deploy events.
#

module.exports = (robot) ->
  robot.router.post '/hubot/deploy_status', (req, res) ->
    robot.messageRoom 'bot-testing', req.body.app
    robot.messageRoom 'bot-testing', req.body.user
    robot.messageRoom 'bot-testing', req.body.url
    robot.messageRoom 'bot-testing', req.body.head
    robot.messageRoom 'bot-testing', req.body.head_long
    robot.messageRoom 'bot-testing', req.body.git_log

