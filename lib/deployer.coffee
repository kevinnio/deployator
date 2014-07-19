https = require 'https'
GithubAdapter = require './adapters/github'

class Deployer
  constructor: (opts = {}) ->
    @githubAdapter = opts.githubAdapter
    @herokuAdapter = opts.herokuAdapter

  deploy: (repo, branch, environment, cb) ->
    @checkForRequiredAccess =>
      @do_deploy(branch, environment, cb)

  checkForRequiredAccess: (cb) ->
    @githubAdapter.checkUserAccess (access, err) =>
      if access then @checkForNextAccess(cb) else cb(false, err)

  checkForNextAccess: (cb) ->
    @githubAdapter.checkRepoAccess (access, err) =>
      if access then @checkForLastAccess(cb) else cb(false, err)

  checkForLastAccess: (cb) ->
    @herokuAdapter.checkAccess (access, err) =>
      if access then cb(true) else cb(false, err)

  do_deploy: (branch, env, cb) ->
    mssg = "Deploy requested: Send #{@githubAdapter.repo}/#{branch} to #{env}"
    console.log mssg
    cb(true)

# ----------------------- #

module.exports = Deployer
