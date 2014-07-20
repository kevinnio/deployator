https = require 'https'

class GithubAdapter
  constructor: (opts) ->
    @user = opts.user
    @repo = opts.repo
    @token = opts.token
    @messages = {
      genericError: "whoa! there was an unknown error at GitHub side. rlly srry",
      noUserAccess: "seems I'm not allowed to access #{@user} GitHub account. srry",
      noRepoAccess: "seems I'm not allowed to access to GitHub repo #{@repo}. srry",
      noBranch1: "whoa! there's no branch '",
      noBranch2: "' at #{@repo} repo!"
    }

  checkUserAccess: (cb) ->
    https.get @request('/user'), (res) =>
      switch res.statusCode
        when 200
          cb true
        when 401
          cb false, @messages.noUserAccess
        else
          cb false, @messages.genericError

  checkRepoAccess: (cb) ->
    https.get @request("/repos/#{@user}/#{@repo}"), (res) =>
      switch res.statusCode
        when 200
          cb true
        when 401
          cb false, @messages.noRepoAccess
        else
          cb false, @messages.genericError
        
  branchExists: (branch, cb) ->
    path = "/repos/#{@user}/#{@repo}/git/refs/heads/#{branch}"
    https.get @request(path), (res) =>
      switch res.statusCode
        when 200
          cb true
        when 401
          cb false, "#{@messages.noBranch1} #{branch} #{@messages.noBranch2}"
        else
          cb false, @messages.genericError

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
