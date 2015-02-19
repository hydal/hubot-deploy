

module.exports = (msg, organization, repository, branch, github) ->
  if !process.env.HUBOT_HEROKU_KEY
    msg.reply "In order to deploy to heroku, a valid API token must be supplied"
  else
    github.repos.getArchiveLink user: organization, repo: repository, ref: "heads/#{branch}", archive_format: "tarball", (err, res) ->
      if err
        msg.reply "There was an error getting the download link for repo: `#{repository}` and branch: `#{branch}`"
      else
        console.log res.meta.location



createApp = (appName, tarball) ->

    # create app
    # POST /apps -> name, region="eu", stack="cedar"
    # if app already exists, just post new build, if actual err then send back error

    # Create build
    # POST /apps/{app id or name}/builds -> source_blob_url, source_blob_version
