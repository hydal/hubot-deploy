

module.exports = (msg, organization, repo, branch="master") ->
  if !process.env.HUBOT_HEROKU_KEY
    msg.reply "In order to deploy to heroku, a valid API token must be supplied"
  else
    console.log "I GOT HERE", organization, repo, branch
    # use github.repo.getBranch to see if the branch exists
    # if so, use the sha from the resp to deploy to heroku
