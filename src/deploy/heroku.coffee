Heroku = require 'heroku-client'
_ = require 'lodash'
heroku =
github =



module.exports = (msg, options, config={ appname: "#{[options.repo, options.branch].join '-'}" }, gh) ->
  github = gh
  return msg.reply "To deploy to Heroku you need a HEROKU_KEY" if !process.env.HUBOT_HEROKU_KEY
  heroku = new Heroku({ token: process.env.HUBOT_HEROKU_KEY })
  config.appname = (config[options.branch] && config[options.branch].appname) || config.other.appname if not config.appname


  console.log config
  github.repos.getArchiveLink user: options.org, repo: options.repo, ref: "heads/#{options.branch}", archive_format: "tarball", (err, res) ->
    return msg.reply "Unable to get the github download link for: `#{options.org}/#{options.repo}/#{options.branch}`" if err
    config.tarball = res.meta.location
    config.appname = config.appname.substring(0, 40)
    checkApps msg, config


# check if the user has app already
checkApps = (msg, config) ->
  heroku.apps().list (err, res) ->
    app = _.find(res, { name: config.appname })
    msg.send "You already have an app called: #{config.appname}, deploying code to this app" if app
    config.url = app.web_url if app
    return createBuild msg, config, new Date() if app
    createApp msg, config



createApp = (msg, config) ->
  heroku.apps().create name: config.appname, (err, app) ->
    return msg.reply "Couldn't create the app: #{config.appname}, this name could be taken" if err
    msg.send "The app: #{config.appname} was successfully created!"
    config.url = app.web_url
    createBuild msg, config, app.released_at



createBuild = (msg, config, version) ->
    heroku.apps(config.appname).builds().create source_blob: url: config.tarball, version: version, (err, build) ->
      console.log err, build
      return msg.reply "The build failed" if err
      msg.send "The app #{config.appname} was successfully deployed to heroku - #{config.url}"
      # robot.emit = { "color": "#7CD197", "fallback": "", text: "", title: "", title_link: "" }
