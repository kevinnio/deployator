https = require 'https'
GithubAdapter = require './adapters/github'

class Deployer
  constructor: (opts) ->
    @githubAdapter = opts.githubAdapter
    @herokuApp = opts.herokuApp
    @herokuToken = opts.herokuToken

  deploy: (cb) ->
    cb('Work in process!')

  checkForRequiredAccess: (cb) ->
    @githubAdapter.checkUserAccess (access, err) =>
      if access then @checkForNextAccess(cb) else cb(false, err)

  checkForNextAccess: (cb) ->
    @githubAdapter.checkRepoAccess (access, err) =>
      if access then @checkForLastAccess(cb) else cb(false, err)

  checkForLastAccess: (cb) ->
    @checkHerokuAccess (access, err) =>
      if access then cb(true) else cb(false, err)

  checkHerokuAccess: (cb) ->
    https.get @herokuOptions("/apps/#{@herokuApp}"), (res) =>
      @checkForStatus res, 200, "Can't access Heroku app data!", cb

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
