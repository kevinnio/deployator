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
    https.get @githubOptions('/user'), (res) =>
      @checkForStatus res, 200, "Can't access GitHub user data!", cb

  checkGithubRepoAccess: (cb) ->
    https.get @githubOptions("/repos/#{@githubUser}/#{@githubRepo}"), (res) =>
      @checkForStatus res, 200, "Can't access GitHub repo data!", cb

  checkHerokuAccess: (cb) ->
    https.get @herokuOptions("/apps/#{@herokuApp}"), (res) =>
      @checkForStatus res, 200, "Can't access Heroku app data!", cb

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

  checkForStatus: (res, status, err, cb) ->
    if res.statusCode == status then cb(true) else cb(false, err)

  options: (hostname, path, headers) ->
    headers['User-Agent'] = 'hubot'
    {
      hostname: hostname,
      path: path,
      headers: headers
    }

# ----------------------- #

module.exports = Deployer
