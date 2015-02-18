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




##############################
# API Methods
##############################

ensureConfig = (out) ->
  out "Error: Heroku API Token is not specified" if not process.env.HUBOT_HEROKU_KEY
  out "Error: Github organization name is not specified" if not process.env.HUBOT_GITHUB_ORG
  return false unless (process.env.HUBOT_HEROKU_KEY and process.env.HUBOT_GITHUB_ORG)
  true



module.exports = (robot) ->

  ensureConfig console.log

  robot.respond /where can l deploy[?]?/i, (msg) ->
    msg.reply "\nYou can deploy to:\n - `Heroku`"

