Heroku = require 'heroku-client'
_ = require 'lodash'
heroku =
github =



module.exports = (msg, options, config={ appname: "#{[options.repo, options.branch].join '-'}" }, gh) ->
  github = gh
  return msg.reply "To deploy to Heroku you need a HEROKU_KEY" if !process.env.HUBOT_HEROKU_KEY
  heroku = new Heroku({ token: process.env.HUBOT_HEROKU_KEY })
  github.repos.getArchiveLink user: options.org, repo: options.repo, ref: "heads/#{options.branch}", archive_format: "tarball", (err, res) ->
    return msg.reply "Unable to get the github download link for: `#{options.org}/#{options.repo}/#{options.branch}`" if err
    config.tarball = res.meta.location
    config.appname = config.appname.substring(0, 40)
    checkApps msg, config


# check if the user has app already
checkApps = (msg, config) ->
  heroku.apps().list (err, res) ->
    app = _.find(res, { name: config.appname })
    msg.send "You already have an app called this name, deploying code to this app" if app
    return createBuild msg, config if app
    createApp msg, config





createApp = (msg, config) ->
  msg.send "Creating the heroku app: #{config.appname}"


# createApp = (msg, appName, tarball) ->

#     appName = appName.substring(0, 30)

#     # create app
#     msg.send "Creating the heroku app called: `#{appName}`"
#     heroku.apps().create name: appName, (err, apps) ->
#       console.log err, apps
#       if err
#         if err.body.message == "Name is already taken"
#           msg.reply "The heroku app: `#{appName}` already exists, therefore creating a new build, this will fail if you don't own this app"
#           createBuild msg, appName, tarball, Date.now()
#         else
#           msg.reply "There was an error trying to create the heroku app: `#{appName}`"
#       else
#         msg.send "Creating a new build for the new heroku app: `#{apps.name}`"
#         createBuild msg, apps.name, tarball, apps.released_at


    # Create build
    # POST /apps/{app id or name}/builds -> source_blob_url, source_blob_version
