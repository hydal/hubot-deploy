Heroku = require 'heroku-client'
heroku =

module.exports = (msg, organization, repository, branch, github) ->
  if !process.env.HUBOT_HEROKU_KEY
    msg.reply "In order to deploy to heroku, a valid API token must be supplied"
  else
    heroku = new Heroku({ token: process.env.HUBOT_HEROKU_KEY });

    github.repos.getArchiveLink user: organization, repo: repository, ref: "heads/#{branch}", archive_format: "tarball", (err, res) ->
      if err
        msg.reply "There was an error getting the download link for repo: `#{repository}` and branch: `#{branch}`"
      else
        appName = [repository, branch].join '-'
        createApp msg, appName, res.meta.location



createApp = (msg, appName, tarball) ->

    appName = appName.substring(0, 30)

    # create app
    msg.send "Creating the heroku app called: `#{appName}`"
    heroku.apps().create name: appName, (err, apps) ->
      console.log err, apps
      if err
        if err.body.message == "Name is already taken"
          msg.reply "The heroku app: `#{appName}` already exists, therefore creating a new build, this will fail if you don't own this app"
          createBuild msg, appName, tarball, Date.now()
        else
          msg.reply "There was an error trying to create the heroku app: `#{appName}`"
      else
        msg.send "Creating a new build for the new heroku app: `#{apps.name}`"
        createBuild msg, apps.name, tarball, apps.released_at


    # Create build
    # POST /apps/{app id or name}/builds -> source_blob_url, source_blob_version
