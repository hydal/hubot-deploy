# Hubot Deploy

[![npm version](https://badge.fury.io/js/hubot-deployer.svg)](http://badge.fury.io/js/hubot-deployer)
[![Dependency Status](https://david-dm.org/boxxenapp/hubot-deploy.svg)](https://david-dm.org/boxxenapp/hubot-deploy)

> Deploy any GitHub repo to Heroku via Hubot

Hubot-Deployer gives `Hubot` the ability to **deploy any github repository/branch to heroku** without getting your hands dirty. It can even be configured by having a **<bot name>.yml** file within the repository you are deploying. The only dependency required, is having a [GitHub](http://github.com/) & [Heroku](http://heroku.com/) account! (oh and maybe [Node.js](http://nodejs.org/) and [npm](http://npmjs.org/) aswell)

When deploying, in order to make the process as seamless as possible, it is recommended that you have a [Procfile](https://devcenter.heroku.com/articles/procfile) within your repo.

**FYI: This is hubot-script will only work for slack right now**



## Installation

In hubot project repository, run:

```sh
$ npm install --save hubot-deployer
```

Then add **hubot-deployer** to your `external-scripts.json`:

```json
[
    "hubot-deployer"
]
```




## Configuration

**Environmental variables**

```
HUBOT_GITHUB_KEY - Github Application Key (personal access token)
HUBOT_GITHUB_ORG - Github Organization Name (optional, as you can specify org name in command)
HUBOT_HEROKU_KEY - Heroku Application Key (required if you are deploying to heroku)
```


**YAML File (<bot name>.yml)**

If you are using the `yaml` file in your repo, its layout must adhere to the following:

```yaml
deploy:
    heroku:
        master: (default branch - required)
            appname: foobar-123
        feature-branch: (name of a specific branch you have)
            appname: foobar-feature-123
        other: (the catch all - so required!)
            appname: foobar-dev-123
```

This file must be called the name of your hubot setup, e.g. if you called your Hubot `ruby`, then the file would be called `ruby.yml`.



**Heroku Specifics**

If you are deploying to `heroku`, to make the deployment smooth and successful, it is suggested that you make sure you have a [Procfile](https://devcenter.heroku.com/articles/procfile) already defined in your repo, so that when the build is created, the app will automatically be started.




## Commands

Below are the commands that l want hubot to be able to do:

```
hubot:
- deploy <repo-name> to heroku - deploys the master branch of your org repo to heroku
- deploy <repo-name>/<repo-branch> to heroku - deploys the specified branch of this repo to heroku
- deploy <org-name>/<repo-name>/<repo-branch> to heroku - deploy this specific repo and branch to heroku
- deploy <user-name>/<repo-name>/<repo-branch> to heroku - same as above, but can be for user
```


## Changelog

**2015-03-04**: [Release Notes](https://github.com/boxxenapp/hubot-deploy/releases/tag/v0.2.1)




### So how does this work?

1. The script parses the message sent to hubot to `extract` the details of the repository
2. Using the [GitHub API](https://developer.github.com/v3/), hubot checks to make sure the repo and branch exist
3. As long as the repo/branch exists, hubot then checks to see if there is a `<bot name>.yml` file present
4. If the yaml file exists, then hubot will use the config specified in there to deploy, else it will use hubots default config
5. Hubot then uses the GitHub API to grab the specific repo/branch `tarball` url
6. It then uses the [Heroku API](https://devcenter.heroku.com/categories/platform-api) to check if the app already exists on `heroku`
7. If the app **does** exists, and you are the **owner**, then hubot will create a new build using the `tarball` url
8. If the app **doesn't** exist, then hubot will create the new app using it's config, with the `tarball` url
9. If all of the above steps are successful, then hubot will return the **url** of the new app/build




### PaaS Providers Implemented

* [Heroku](http://heroku.com/)


