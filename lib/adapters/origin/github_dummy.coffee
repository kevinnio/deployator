GITHUB_TOKEN = '6a31272a5b85e5936254ebd18a0e4ea31867c8b5'
USERS = ['kevindperezm']
REPOS = ['hellocat']
BRANCHES = ['add-cool-feature', 'some-other-not-so-cool-feature']

class GithubDummyAdapter
  constructor: (opts) ->
    @user = opts.user
    @repo = opts.repo
    @token = opts.token
    @messages = {
      genericError: "whoa! there was an unknown error at GitHub side. rlly srry",
      noUserAccess: "seems I'm not allowed to access #{@user} GitHub account. srry",
      noRepoAccess: "seems I'm not allowed to access to GitHub repo #{@repo}. srry",
      noBranch1: "whoa! there's no branch",
      noBranch2: "at #{@repo} repo!"
    }

  checkAccess: (cb) ->
    @checkUserAccess =>
      @checkRepoAccess cb

  branchExists: (branch, cb) ->
    if branch in BRANCHES
      cb(true)
    else
      cb(false, "#{@messages.noBranch1} '#{branch}' #{@messages.noBranch2}")

  getTarballURL: (cb) ->
    cb('http://some-tarball-url.com')

# --------------------------- #
# Private methods             #
# --------------------------- #

   checkUserAccess: (cb) ->
    if @token == GITHUB_TOKEN
      cb(true)
    else
      cb(false, @messages.noUserAccess)

  checkRepoAccess: (cb) ->
    if @token == GITHUB_TOKEN
      cb(true)
    else
      cb(false, @messages.noUserAccess)

# ------------------------- #

module.exports = GithubDummyAdapter
