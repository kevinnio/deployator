https = require 'https'

class Deployer
  constructor: (opts) ->
    @githubToken = opts.githubToken

  deploy: (cb) ->
    cb('Work in process!')

  checkGithubUserAccess: (cb) ->
    https.get @githubOptions('/user'), (res) ->
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

# ----------------------- #

module.exports = Deployer
