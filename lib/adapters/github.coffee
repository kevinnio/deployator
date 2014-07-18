https = require 'https'

class GithubAdapter
  constructor: (opts) ->
    @user = opts.user
    @repo = opts.repo
    @token = opts.token

  checkUserAccess: (cb) ->
    https.get @request('/user'), (res) =>
      @checkForStatus res, 200, "Can't access GitHub user data!", cb

  checkRepoAccess: (cb) ->
    https.get @request("/repos/#{@user}/#{@repo}"), (res) =>
      @checkForStatus res, 200, "Can't access GitHub repo data!", cb

  branchExists: (branch, cb) ->
    path = "/repos/#{@user}/#{@repo}/git/refs/heads/#{branch}"
    https.get @request(path), (res) =>
      err = "Looks like branch '#{branch}' doesn't exists!"
      @checkForStatus(res, 200, err, cb)

  request: (path) ->
    {
      hostname: 'api.github.com',
      path: path,
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': "token #{@token}",
        'User-Agent': 'hubot'
      }
    }

  checkForStatus: (res, status, err, cb) ->
    if res.statusCode == status then cb(true) else cb(false, err)

# ------------------------- #

module.exports = GithubAdapter
