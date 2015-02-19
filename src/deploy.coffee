# Description:
#   Allow Hubot to deploy GitHub repos+branches to a PaaS
#
# Dependencies:
#   "github": "latest"
#
# Configuration:
#   HUBOT_GITHUB_ORG - Github Organization Name (optional)
#   HUBOT_GITHUB_KEY - GitHub API Token
#   HUBOT_HEROKU_KEY - Heroku API Token
#
# Commands:
#   hubot where can l deploy? - returns a list of PaaS where you can deploy to
#
# Author:
#   Ollie Jennings <ollie@olliejennings.co.uk>


deploy = require "./deploy/index"

GitHubAPI = require "github"
github = new GitHubAPI version: "3.0.0", debug: true, headers: Accept: "application/vnd.github.moondragon+json"



##############################
# API Methods
##############################

ensureConfig = (out) ->
  out "Error: Heroku API Token is not specified" if not process.env.HUBOT_HEROKU_KEY
  out "Error: Github organization name is not specified" if not process.env.HUBOT_GITHUB_ORG
  out "Error: Github API Token is not specified" if not process.env.HUBOT_GITHUB_KEY
  return false unless (process.env.HUBOT_HEROKU_KEY and process.env.HUBOT_GITHUB_ORG and process.env.HUBOT_GITHUB_KEY)
  true


parse = (msg, repo, paas) ->
  repo = repo.split '/'
  console.log paas
  if !process.env.HUBOT_GITHUB_ORG and repo.length < 3
    msg.reply "You must specify a valid organization or user"
  else if repo.length > 3
    msg.reply "The repo: `#{repo.join '/'}` is invalid, the format is: `organization/repo-name/repo-branch`"
  else if repo.length == 3
    repoExists msg, repo[0], repo[1], repo[2], paas
  else if repo.length < 3
    repoExists msg, process.env.HUBOT_GITHUB_ORG, repo[0], repo[1], paas



repoExists = (msg, organization, repository, repoBranch="master", paas) ->
  github.repos.getBranch user: organization, repo: repository, branch: repoBranch, (err, res) ->
    if err
      msg.reply "The repository: `#{organization + '/' + repository}` or branch: `#{repoBranch}` does not exist"
    else
      msg.send "Started deployment of repo: `#{organization + '/' + repository}`, branch: `#{repoBranch}` to: `#{paas}`"
      deploy[paas] msg, organization, repository, repoBranch, github



module.exports = (robot) ->

  ensureConfig console.log
  github.authenticate type: "oauth", token: process.env.HUBOT_GITHUB_KEY

  robot.respond /where can l deploy[?]?/i, (msg) ->
    msg.reply "\nYou can deploy to:\n - `Heroku`"

  robot.respond /deploy (\w.+) to (heroku)/i, (msg) ->
    parse msg, msg.match[1], msg.match[2]
