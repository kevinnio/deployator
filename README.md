# Deployator - a deploy-capable Hubot

This is a customized version of Hubot, enhanced to do automatic deployment from 
GitHub to Heroku with just sending a chat message from your company's Slack.
It's easy to use. Just deploy the bot, configure it and you're done!

## If you deploy your bot at Heroku

By default, Heroku is going to idle your bot after a while of inactivity. That will make impossible for your bot to stay aware of your team chat activity and GitHub/Heroku responses. Set this env vars to make your bot rockin' all day!

* <b>HEROKU_URL</b>: The url where your bot is deployed, e.g. "mybot.herokuapp.com". Your bot is going to ping itself constantly in order to prevent being idled.

## Configure

This bot integrates services from different providers by using theirs web API.
So, in order for this bot to work, you have to do some things at your bot's side
and at each service's side.


### Slack

Your bot needs access to your team chat. Here's a way you can give access to it.

#### Service's side

Slack offers a Hubot integration that you can use to make your bot aware of what's happenning inside your team.

To setup this integration:

1. Go to https://:yourcompany.slack.com/services/new/hubot (put your company's name in place).
2. Click in the 'Add Hubot integration' button.
3. In the 'Service Configuration' section, put the url where the bot is deployed.
4. Change any other settings you want.
5. Click on 'Save integration'.

#### Bot's side

The bot needs some environment vars in order to access your company's Slack channels.

* <b>HUBOT_SLACK_BOTNAME</b>: Your bot's name. Your bot is going to respond to this name.
* <b>HUBOT_SLACK_TEAM</b>: The team the bot will join. Usually, it's the domain of your company's Slack (e.g. for <i>http://mycompany.slack.com</i>, this var has to be setted to <i>mycompany</i>).
* <b>HUBOT_SLACK_TOKEN</b>: A Slack access token.

You can get this data from the Slack's side, in the 'Setup Instructions' section.

### GitHub

When you send a deploy command, your bot is going to deliver a deployment request to GitHub's API. Then, GitHub has to notify your bot when a deployment event is fired at its side. Also, a GitHub service needs to be in place, waiting for deployment events to push your code into Heroku.

#### Service's side

To make GitHub notify your bot when a deployment event has fired on a repo, you have to add a GitHub webhook to your repo, indicating the url where your bot is deployed. For convenience, run the command below. Make sure you replace the brackets with your data. btw, the GitHub token here has to have <i>repo</i> and <i>gists</i> scope, preferably.

`curl https://api.github.com/hub -F "hub.mode=subscribe" -F "hub.topic=https://github.com/[owner]/[repo]/events/deployment" -F "hub.callback=[url_to_my_bot]" -H "Authorization: token [github_token]" -v`

If you got a `200 OK` status code in the response, you're on fire. If this method doesn't work for some reason, you can always do it manual in your repo's settings.

Now you have to the HerokuBeta GitHub service to your repo. To add it:

1. Go to https://github.com/:owner/:repo/settings/hooks.
2. In the 'Add service' select box, click on 'HerokuBeta'.
3. In 'Name', put the name of your Heroku app.
4. In 'Heroku token', put a direct authorization token (go [here](https://devcenter.heroku.com/articles/oauth#direct-authorization) to know how to get one).
5. In 'GitHub token', put a GitHub token with <i>repo</i> and <i>gists</i> scope.
6. Make sure 'Active' checkbox is checked.
7. Lastly, Click on 'Add service'.

#### Bot's side

As with Slack, your bot is gonna need some env vars to connect with GitHub.

* <b>HUBOT_GITHUB_TOKEN</b>: A GitHub token with <i>repo_deployment</i> scope.

### Heroku

Lastly, you have to make Heroku notify your bot when a successful deployment is done. You're gonna add a webhook to your Heroku app in order to make this possible.

#### Service's side

1. Add the `deployhooks:http` addon to your Heroku app. You have to pass info about where Heroku is going to send a post request after a successful deployment. The easiest way is using the Heroku Toolbelt: `heroku addons:add deployhooks:http --url=[url_to_my_bot] --app [my_app_name]`

#### Bot's side

You don't need to do anything at bot's side for Heroku integration.

## Notices

This bot is part of my internship project at [Crowd Interactive](http://crowdint.com).
