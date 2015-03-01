# Hubot Deploy

[![npm version](https://badge.fury.io/js/hubot-deployer.svg)](http://badge.fury.io/js/hubot-deployer)
[![Dependency Status](https://david-dm.org/boxxenapp/hubot-deploy.svg)](https://david-dm.org/boxxenapp/hubot-deploy)


`SLACK ONLY`


This `hubot-script` gives Hubot the ability to deploy any github user  or organization repository/branch to heroku (and other PaaS providers in the future). You can also specifiy a `<hubot name>.yml` file in the repository you are wanting to deploy. For example, in the `yaml` file you could put the name of the heroku app, meaning that when you ask Hubot to deploy that repository, it will read the appname specified in the `yaml` file. If there is no `yaml` file present in the repository, then this script will just fallback to default configuration.


#### Installation

In hubot project repository, run:

`npm install hubot-deploy --save`

Then add **hubot-deploy** to your `external-scripts.json`:

```json
[
    "hubot-deploy"
]
```


#### Configuration

**Environmental variables**

```
HUBOT_GITHUB_KEY - Github Application Key (personal access token)
HUBOT_GITHUB_ORG - Github Organization Name (optional, as you can specify org name in command)
HUBOT_HEROKU_KEY - Heroku Application Key (required if you are deploying to heroku)
```

**YAML File (<bot name>.yml)**

If you are using the `yaml` file in your repo, its layout must adhere to below:

```
deploy:
    heroku: (if deploying to heroku)
        appname: foobar-123
```

This file must be called the name of your hubot setup, e.g. if you called your Hubot `ruby`, then the file would be called `ruby.yml`.


**Heroku Specifics**

If you are deploying to `heroku`, to make the deployment smooth and successful, it is suggested that you make sure you have a [Procfile](https://devcenter.heroku.com/articles/procfile) already defined in your repo, so that when the build is created, the app will automatically be started.




#### Commands

Below are the commands that l want hubot to be able to do:

`hubot`:

* `deploy <repo-name> to heroku` - deploys the master branch of your org repo to heroku
* `deploy <repo-name>/<repo-branch> to heroku` - deploys the specified branch of this repo to heroku
* `deploy <org-name>/<repo-name>/<repo-branch> to heroku` - deploy this specific repo and branch to heroku
* `deploy <user-name>/<repo-name>/<repo-branch> to heroku` - same as above, but can be for user



#### Under the Hood

If you are interested in what this script actually does, below is list of the tasks it does in order:

* Extract the relevant information from the hubot command
* Check if the repo that was specified exists
* Checks to see if the repo has a `.yml` file for config
* Uses the config from the `.yml` file, if not available, then uses default config
* Grabs the `tarball` link for the repository
* Checks to see if this app already exists on `heroku`
* If the app exists, then it creates a new build for this app
* If the app doesn't exist, then it creates a brand new app, with a new build
* If all successfull, then hubot will return the url of the new app/build




#### PaaS Providers

Goal is to be able to push to nearly every single PaaS provder that exists, but lets start easy:

* Heroku
* Digital Ocean (coming soon)
* [All those in the provders list](http://en.wikipedia.org/wiki/Platform_as_a_service)


