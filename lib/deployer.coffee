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

  checkHerokuAccess: (cb) ->
    https.get @herokuOptions("/apps/#{@herokuApp}"), (res) ->
      cb (res.statusCode == 200)

  githubOptions: (path) ->
    headers = {
      'Accept': 'application/vnd.github.v3+json',
      'Authorization': "token #{@githubToken}"
    }
    @options 'api.github.com', path, headers

  herokuOptions: (path) ->
    headers = {
      'Accept': 'application/vnd.heroku+json; version=3',
      'Authorization': "Bearer #{@herokuToken}"
    }
    @options 'api.heroku.com', path, headers

  options: (hostname, path, headers) ->
    headers['User-Agent'] = 'hubot'
    {
      hostname: hostname,
      path: path,
      headers: headers
    }

# ----------------------- #

module.exports = Deployer
