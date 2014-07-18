https = require 'https'
GithubAdapter = require './adapters/github'

class Deployer
  constructor: (opts = {}) ->
    @githubAdapter = opts.githubAdapter
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
    @herokuAdapter.checkAccess (access, err) =>
      if access then cb(true) else cb(false, err)

# ----------------------- #

module.exports = Deployer
