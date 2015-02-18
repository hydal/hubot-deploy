

module.exports = (msg, organization, repo, branch="master") ->
  if !process.env.HUBOT_HEROKU_KEY
    msg.reply "In order to deploy to heroku, a valid API token must be supplied"
  else
    console.log "I GOT HERE", organization, repo, branch

    # use github.getarchivelink
      # GET /repos/:owner/:repo/:archive_format/:ref
      # e.g. https://github.com/User/repo/tarball/master

    # github.repos.getArchiveLink user, repo, ref=heads/branch, archive_format

    # create app
    # POST /apps -> name, region="eu", stack="cedar"

    # Create build
    # POST /apps/{app id or name}/builds -> source_blob_url, source_blob_version
