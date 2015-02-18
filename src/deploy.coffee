# Description:
#   Allow Hubot to deploy GitHub repos+branches to a PaaS
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GITHUB_ORG - Github Organization Name (optional)
#   HUBOT_HEROKU_KEY - Heroku API Token
#
# Commands:
#   hubot where can l deploy? - returns a list of PaaS where you can deploy to
#
# Author:
#   Ollie Jennings <ollie@olliejennings.co.uk>


deploy = require "./deploy/index"



##############################
# API Methods
##############################

ensureConfig = (out) ->
  out "Error: Heroku API Token is not specified" if not process.env.HUBOT_HEROKU_KEY
  out "Error: Github organization name is not specified" if not process.env.HUBOT_GITHUB_ORG
  return false unless (process.env.HUBOT_HEROKU_KEY and process.env.HUBOT_GITHUB_ORG)
  true

parse = (msg, repo, paas) ->
  repo = repo.split '/'
  deploy[paas] msg, repo[0], repo[1], repo[2] if repo.length == 3
  deploy[paas] msg, process.env.HUBOT_GITHUB_ORG, repo[0], repo[1] if repo.length < 3 and process.env.HUBOT_GITHUB_ORG
  msg.reply "You must specify a valid organization or user" if !process.env.HUBOT_GITHUB_ORG
  msg.reply "The repo: `#{repo.join '/'}` is invalid, the format is: `organization/repo-name/repo-branch`" if repo.length > 3



module.exports = (robot) ->

  ensureConfig console.log

  robot.respond /where can l deploy[?]?/i, (msg) ->
    msg.reply "\nYou can deploy to:\n - `Heroku`"

  robot.respond /deploy (\w.+) to (heroku)/i, (msg) ->
    console.log deploy
    parse msg, msg.match[1], msg.match[2]
