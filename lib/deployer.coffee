https = require 'https'

class Deployer
  constructor: (opts) ->
    @githubUser = opts.githubUser
    @githubRepo = opts.githubRepo
    @githubToken = opts.githubToken
    @herokuApp = opts.herokuApp
    @herokuToken = opts.herokuToken

  deploy: (cb) ->
    cb('Work in process!')

  checkGithubUserAccess: (cb) ->
    https.get @githubOptions('/user'), (res) ->
      cb(res.statusCode == 200)

  checkGithubRepoAccess: (cb) ->
    https.get @githubOptions("/repos/#{@githubUser}/#{@githubRepo}"), (res) ->
      cb(res.statusCode == 200)

  githubOptions: (path) ->
    {
      hostname: 'api.github.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': "token #{@githubToken}",
        'User-Agent': 'hubot'
      }
    }

  checkHerokuAccess: (cb) ->
    https.get @herokuOptions("/apps/#{@herokuApp}"), (res) ->
      cb (res.statusCode == 200)

  herokuOptions: (path) ->
    {
      hostname: 'api.heroku.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.heroku+json; version=3',
        'Authorization': "Bearer #{@herokuToken}"
      }
    }

# ----------------------- #

module.exports = Deployer
