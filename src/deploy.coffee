# Description:
#   Allow Hubot to deploy GitHub repos+branches to a PaaS
#
# Dependencies:
#   "github": "latest"
#   "heroku-client": "latest"
#   "js-yaml": "latest"
#   "lodash": "latest"
#
# Configuration:
#   HUBOT_GITHUB_ORG - Github Organization Name (optional)
#   HUBOT_GITHUB_KEY - GitHub API Token
#   HUBOT_HEROKU_KEY - Heroku API Token
#
# Commands:
#   hubot where can l deploy? - returns a list of PaaS where you can deploy to
#   hubot deploy <repo name> to heroku - deploys specific org repo to heroku
#   hubot deploy <repo name>/<repo branch> to heroku - deploys specific org repo and branch to heroku
#   hubot deploy <org name>/<repo name>/<repo branch> to heroku - deploy specific org repo and branch to heroku
#
# Author:
#   Ollie Jennings <ollie@olliejennings.co.uk>


deploy = require "./deploy/index"
yaml = require 'js-yaml'

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


extractValues = (msg, cb) ->
  repo = msg.match[1].split '/'
  return msg.reply "An organization is required." if !process.env.HUBOT_GITHUB_ORG and repo.length < 3
  return msg.reply "Msg format must be of `org/repo/branch`" if repo.length > 3
  return cb org: repo[0], repo: repo[1], branch: (repo[2] or "master"), service: msg.match[2] if repo.length is 3
  return cb org: process.env.HUBOT_GITHUB_ORG, repo: repo[0], branch: (repo[1] or "master"), service: msg.match[2] if repo.length < 3


validateRepo = (msg, options, cb) ->
  github.repos.getBranch user: options.org, repo: options.repo, branch: options.branch, (err, res) ->
    return msg.reply "Error: the repo: #{options.org}/#{options.repo}/#{options.branch} was not found."  if err
    cb()



getConfig = (msg, options, cb) ->
  github.repos.getContent user: options.org, repo: options.repo, path: "#{options.yaml}.yml", ref: options.branch, (err, res) ->
    return cb(null) if err
    config = yaml.safeLoad(new Buffer(res.content, 'base64').toString())
    return msg.reply "There is an error with your #{options.yaml}.yml file" if !config.deploy or !config.deploy[options.service]
    return cb(config.deploy[options.service])



module.exports = (robot) ->

  ensureConfig console.log
  github.authenticate type: "oauth", token: process.env.HUBOT_GITHUB_KEY

  robot.respond /where can l deploy[?]?/i, (msg) ->
    msg.reply "\nYou can deploy to:\n\t- `Heroku`"

  robot.respond /deploy (\w.+) to (heroku)/i, (msg) ->
    extractValues msg, (options) ->
      msg.send "Checking if the repo: `#{options.org}/#{options.repo}/#{options.branch}` exists"
      validateRepo msg, options, () ->
        options.yaml = robot.name
        getConfig msg, options, (config) ->
          deploy[options.service](msg, options, config, github)
          # todo slack attachments do, robot.emit 'slack.attachment'
