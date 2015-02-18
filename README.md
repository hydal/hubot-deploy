# Hubot Deploy
Giving Hubot the ability to deploy your repos on the fly!

[![Dependency Status](https://david-dm.org/boxxenapp/hubot-deploy.svg)](https://david-dm.org/boxxenapp/hubot-deploy)

#### Commands

Below are the commands that l want hubot to be able to do:

* `hubot deploy <repo name> to heroku`
* `hubot deploy <repo name>:<repo branch> to heroku`
* `hubot deploy <repo name> to digital ocean`


#### PaaS Providers

Goal is to be able to push to nearly every single PaaS provder that exists, but lets start easy:

* Heroku
* Digital Ocean
* [All those in the provders list](http://en.wikipedia.org/wiki/Platform_as_a_service)


#### Dependencies

What libraries shall be required:

* `heroku/node-heroku-client`


#### Configuration

What conifguration keys shall be required:

* `HUBOT_GITHUB_KEY`
* `HUBOT_HEROKU_KEY`
* `HUBOT_GITHUB_ORG` (optional as should be able to pass repo name as user/repo)




