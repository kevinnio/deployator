https = require 'https'
Deployable = require './deployable'

class Deployer
  deploy: (name, branch, env, cb) ->
    deployable = @findDeployable(name)
    if deployable
      origin = deployable.origin
      target = deployable.target
      origin.checkAccess (access, err) =>
        cb(false, err) unless access
        origin.branchExists branch, (exists, err) =>
          cb(false, err) unless exists
          origin.getTarballURL branch, (tarball, err) =>
            cb(false, err) unless tarball
            try
              target.appExists env, (exists, err) =>
                cb(false, err) unless exists
                target.checkAccess env, (access, err) =>
                  cb(false, err) unless access
                  target.deploy env, tarball, (success, err) =>
                    if success
                      cb("deployment of #{name}/#{branch} to #{env} just started!")
                    else
                      cb(false, err)
            catch DeployError
              cb(false, "srry but I dunno target env #{env} for #{name}...")
    else
      cb(false, "#{name}? I don't know that app, srry.")

  findDeployable: (name) ->
    @deployables = Deployable.loadFile 'deployables.json' unless @deployables
    for deployable in @deployables
      return deployable if deployable.name == name

# ----------------------- #

module.exports = Deployer
