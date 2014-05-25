Automating Puppet Testing - A Step-by-Step Guide
================================================

[![Build Status](https://travis-ci.org/Millenux/puppet-testguide.png?branch=master)](https://travis-ci.org/Millenux/puppet-testguide)

So you want to develop a puppet module and want to use all these nice tools
like GitHub (version control / collaboration), Travis CI (continuous
integration) and puppet-rspec (unit testing for puppet code).

This document will guide you step by step through the process, from uploading
your puppet module to GitHub to releasing it on the [PuppetForge][]

Let's get started!

0. Initial Situation
--------------------

The starting point for this guide is a simple module, lets call it
"testguide". The layout of this module on the filesystem is
as follows:

    /testguide/
      manifests/
        init.pp

A _really_ simple module. For details on how to structure module have a look
at the official [ModuleLayoutDocumentation][] on this topic.
And while you are there read the [PuppetStyleGuide][] also.

To have something to test later on, init.pp contains a clase containing one
file resource:

    class testguide ( $world ) {
      file { '/tmp/hello.txt':
        ensure  => file,
        content => "Hello ${world}!\\n"
      }
    }

This small class (with the mandatory parameter $world) will create a fille
`/tmp/hello.txt` containing the text "Hello ..." with whatever you passed
as the $world parameter. I will not go into the details of Puppet itself so
if you need an introduction I suggest you head to the [LearningPuppet][] 
website.

1. Version Control with Git and GitHub
--------------------------------------

Now that we have our module, we want to track changes to it and allow others
to contribute. A really nice way to do this is by using [Git][] and to publish
your code on [GitHub][]. If you do not already have an account there, I suggest
you create one and follow the steps in the [SettingUpGitGuide][].

So we have our GitHub account. As the next step we need to
[CreateAGitRepository][] on our new account. I will call the repository
"puppet-testguide". The "puppet-" prefix allows me to easily distinguish this
repository as a puppet module. I suggest you do the same with your puppet module
repository as this is also common practice.

Lets add our small module to the puppet-testguide repository:

    [mgruener@devel testguide]$ git init
    Initialized empty Git repository in /home/mgruener/git/testguide/.git/
    [mgruener@devel testguide]$ git add .
    [mgruener@devel testguide]$ git commit -m 'Initial commit'
    [master (root-commit) dbb6293] Initial commit
     1 file changed, 6 insertions(+)
     create mode 100644 manifests/init.pp
    [mgruener@devel testguide]$ git remote add origin https://github.com/Millenux/puppet-testguide.git
    [mgruener@devel testguide]$ git push origin master
    Username for 'https://github.com': mgruener
    Password for 'https://mgruener@github.com':
    Counting objects: 4, done.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (4/4), 364 bytes | 0 bytes/s, done.
    Total 4 (delta 0), reused 0 (delta 0)
    To https://github.com/Millenux/puppet-testguide.git
     * [new branch]      master -> master
    [mgruener@devel testguide]$

Our code is now available online. To allow others to contribute we should add
a readme explaining what our puppet module does and we should add a license
to explain under which conditions others can use/modify our code.

For the sake of this document the readme will be this document itself and the
license will be [GPL][]. GPL is normally a safe bet when choosing a license. It is
widely known and it is easy to publish GPL licensed puppet modules on the
Puppet Forge.

The readme should be called `README.md` and be written in the [Markdown][]
format. This file will be rendered as HTML when accessing the GitHub repository
from a browser. You probably read this guide right now like this. This file
will later also be used as documentation for your module on the Puppet Forge.

The license should be documented in a file called `LICENSE`. You could name
it anyway you want but calling it `LICENSE` is common practice and will also
be recogniced by GitHub when determining under which license your repository
operates.

    [mgruener@devel testguide]$ touch README.md
    # describe your puppet module in your README.md
    [mgruener@devel testguide]$ touch LICENSE
    # add whatever license you desire
    [mgruener@devel testguide]$ git add README.md LICENSE
    [mgruener@devel testguide]$ git commit -m 'Add readme and license'
    [mgruener@devel testguide]$ git push origin master

We now have a module that is version controlled and available to whoever wants
to contribute. The module has a readme explaining what it does and a license
permitting others to use and modify the code. In the following parts of this
guide I will assume that you know how to handle git well enought without
me mentioning each and every step to upload your new code to the repository.
If you need help with that I suggest you read a [GitGuide][].

2. Continuous integration for syntax checking using Travis CI
-------------------------------------------------------------

If you followed this guide up till now, you will probably have read some
guides regarding Puppet and GitHub. Maybe you even stumbled over this
nice Puppetlabs blog post regarding [AutomatedTestingForPuppet][].

__If__ you have, the following steps should seem familiar to you:

    [mgruener@devel testguide]$ puppet parser validate manifests/init.pp
    [mgruener@devel testguide]$ puppet-lint manifests/init.pp
    WARNING: parameterised class parameter without a default value on line 1
    WARNING: class not documented on line 1
    [mgruener@devel testguide]$

The first command performs a syntax check on your puppet code, the second one
performs a style check. If you see these commands for the first time, remember
them and use them. Really. They will save you from a lot of headaches and help
keeping your code maintainable. 

So now we check our puppet code for syntax and style problems __before__
commiting the changes. But what about contributions from other people or when
we forget to do these checks manually? These steps should be performed
whenever new code enters our upstream repository on GitHub. And it should
be easily visible to everyone to see if our code passed these basic tests.

Maybe you have seen some puppet modules on the Puppet Forge and on GitHub
which had a small icon stating "build passing" (or even "build failing") in
their README.md. The same as the one that can be found at the top of this
guide.

This is the build status for this repository on [TravisCI][]. Travis CI is
a free (at least for public repositories) continuous integration service
neatly integrated with GitHub. Everytime someone pushes code to a registered
repository, Travis CI "builds" the code contained in this repository according
to a set of specifications. For puppet "building" means "run some tests".

Now to automate our syntax/style checks we need a Travis CI account. Nothing is
easier than that because you can create one with your GitHub credentials. Go
[SignIn][] to Travis CI and [ActivateGitHubWebhook][] for your repository.

The basic preparations for our automated checks are now complete. Now we have
to tell Travis CI what to do when someone pushes code to our repository. From
a Travis CI point of view a puppet module is Ruby code so we can use the
[TravisCIRubyDocumentation][] as basis for our configuration. To build a ruby
project we will need 3 files:

  * [.travis.yml][]
  
    The main Travis CI configuration file for this repository. Defines what
    should be build how (especially with which versions)

  * Gemfile

    Defines which Ruby [Gems][] should be installed for the build. This file
    is used by the Ruby tool "[bundler][]". If Travis CI finds this file in a
    repository, it treats the repository as Ruby code.

  * Rakefile

    A Makefile, just for Ruby. It is used by the Ruby tool "[rake][]".

We need these files because in the basic configuration, Travis CI performs
the following actions when it detects a new push to the repository:

    $ git clone --depth=50 --branch=master <repo>
    $ git checkout -qf <commitid>
    $ ... <setup ruby version> ...
    $ bundle install
    $ bundle exec rake

Nothing spectacular and really nothing that defines _how_ our code is tested.
We are free to define this however we want, using the files mentioned above.
Lets start with defining the environment in which we want to test, meaning the
Ruby and Puppet versions we want to use while testing:

    .travis.yml:
    ---
    rvm:
      - 1.8.7
      - 1.9.3
    env:
      - PUPPET_VERSION=">= 3.0.0"
      - PUPPET_VERSION="~> 2.7"

This is all there is Travis CI itself needs to now about our code. The rvm
part is interpreted by Travis CI and the "PUPPET_VERSION" is an environment
variable that we will use in the next step. The configuration shown above
will test our code in four environments:

  * Ruby 1.8.7 + Puppet 3.x.x
  * Ruby 1.8.7 + Puppet 2.7.x
  * Ruby 1.9.3 + Puppet 3.x.x
  * Ruby 1.9.3 + Puppet 2.7.x

Now that we have defined our build environments, we have to tell bundler what
to install in each environment. For this we have the Gemfile:

    Gemfile:
    source 'https://rubygems.org'

    if ENV.key?('PUPPET_VERSION')
      puppetversion = "#{ENV['PUPPET_VERSION']}"
    else
      puppetversion = ['~> 2.7']
    end

    gem 'puppet', puppetversion, :require => false
    gem 'puppet-lint'
    gem 'rake'

Here you can see how the PUPPET_VERSION environment variable from the
`.travis.yml` file is used. The if/else construct is just a safety net in case
no Puppet version was specified in the environment. This will probably not
happen when building with Travis CI but it can happen when you execute bundler
for example on your development system (I will provide an example on how to do
this later in this guide).

Puppet as well as puppet-lint are both Ruby gems so we can install them on this
way, and in the case of puppet, also with a specific version.

The real "magic" happens in the Rakefile. Here the actual tasks that should be
performed in our build environment are defined.

    Rakefile:
    require 'rubygems'
    require 'puppet-lint/tasks/puppet-lint'
    PuppetLint.configuration.send('disable_80chars')
    PuppetLint.configuration.send('disable_class_inherits_from_params_class')
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp","examples/**/*.pp"]

    desc "Validate manifests, templates, and ruby files in lib."
    task :validate do
      Dir['manifests/**/*.pp'].each do |manifest|
        sh "puppet parser validate --noop #{manifest}"
      end
    end

    task :default => [:lint, :validate]

In this file we tell Ruby we want to use code from the rubygems and puppet-lint
Gems. We also set some basic options for puppet-lint (the lines with
PuppetLint.configuration directives). For details see the [PuppetLintChecks][]
documentationWe also tell Ruby which "tasks" have to be performed. When
executing rake without parameters it will perform the ":default" task. In our
case this will in turn perform the ":lint" task (defined in the puppet-lint
gem) and the ":validate" task (defined in this file).

And thats it with the basic Travis CI integration. When you create these files
and push them to your repository, Travis CI will pick up the change and perform
the steps we just described. And hopefully it will say "build passed".

3. Adding advanced puppet features - templates and plugins
----------------------------------------------------------

In the previous step we integrated our puppet module repository hosted on GitHub
with Travis CI to automate some basic checks for our module. In this small step
we add some advanced features to our module. These features are [templates][]
and plugins. Calling templates an "advanced" feature of puppet may seem far
fetched but they involve touching raw ruby code with all the advantages and
especially risks.

Before we can test anything we have to extend our module so lets do that first.
And because they are pretty common we will start with adding a template. The
directory structure of the module has to be extended like this:

    /testguide/
      manifests/
        init.pp
      templates/
        hello.erb

And the contents of the template are as follows:

    <% if @world -%>
    Hello <%= @world %>
    <% end -%>

Nothing really creative but...well, this is a guide on testing and not on
creating nice puppet modules. Now we only have to modify our puppet manifest
`init.pp` to look like this:

    class testguide ( $world ) {
      file { '/tmp/hello.txt':
        ensure  => file,
        content => template('testguide/hello.erb')
      }
    }
 
This does exactly the same as before but it uses a template to accomplish that.
To syntax check our template, we would have to execute the following statement:

    [mgruener@devel testguide]$ erb -P -x -T '-' templates/hello.erb | ruby -c

The last step, at least in regard to templates, is to integrate this into our
test setup. The only file we have to modify is the Rakefile where we extend the
":validate" task:

    require 'rubygems'
    require 'puppet-lint/tasks/puppet-lint'
    PuppetLint.configuration.send('disable_80chars')
    PuppetLint.configuration.send('disable_class_inherits_from_params_class')
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp","examples/**/*.pp"]

    desc "Validate manifests, templates, and ruby files in lib."
    task :validate do
      Dir['manifests/**/*.pp'].each do |manifest|
        sh "puppet parser validate --noop #{manifest}"
      end
      Dir['templates/**/*.erb'].each do |template|
        sh "erb -P -x -T '-' #{template} | ruby -c"
      end
    end

    task :default => [:lint, :validate]

  [PuppetForge]: https://forge.puppetlabs.com/ "Puppet Forge"
  [ModuleLayoutDocumentation]: http://docs.puppetlabs.com/puppet/3.6/reference/modules_fundamentals.html#module-layout "Puppetlabs module-layout documentation"
  [PuppetStyleGuide]: http://docs.puppetlabs.com/guides/style_guide.html "Puppet Style Guide"
  [LearningPuppet]: http://docs.puppetlabs.com/learning/ "Learning Puppet"
  [Git]: http://git-scm.com/ "Git"
  [GitHub]: https://github.com/ "GitHub"
  [SettingUpGitGuide]: https://help.github.com/articles/set-up-git
  [CreateAGitRepository]: https://help.github.com/articles/create-a-repo#make-a-new-repository-on-github "Create a Git repository"
  [Markdown]: http://daringfireball.net/projects/markdown/syntax "Markdown"
  [GPL]: http://choosealicense.com/licenses/gpl-v3/ "GPL"
  [GitGuide]: https://stackoverflow.com/questions/315911/git-for-beginners-the-definitive-practical-guide "Git for beginners: The definitive practical guide"
  [AutomatedTestingForPuppet]: http://puppetlabs.com/blog/verifying-puppet-checking-syntax-and-writing-automated-tests "Verifying Puppet: Checking Syntax and Writing Automated Tests"
  [TravisCI]: https://travis-ci.org/ "Travis CI"
  [SignIn]: http://docs.travis-ci.com/user/getting-started/#Step-one%3A-Sign-in "Sign in to Travis CI"
  [ActivateGitHubWebhook]: http://docs.travis-ci.com/user/getting-started/#Step-two%3A-Activate-GitHub-Webhook "Activate GitHub Webhook for Travis CI"
  [TravisCIRubyDocumentation]: http://docs.travis-ci.com/user/languages/ruby/ "Building a Ruby Project with Travis CI"
  [.travis.yml]: http://docs.travis-ci.com/user/build-configuration/ "Configuring your build for Travis CI"
  [Gems]: https://rubygems.org/ "Ruby Gems"
  [bundler]: https://rubygems.org/gems/bundler "bundler"
  [rake]: http://rake.rubyforge.org/ "rake"
  [PuppetLintChecks]: http://puppet-lint.com/checks/ "Puppet Lint Check Documentation"
  [templates]: http://docs.puppetlabs.com/guides/templating.html "Using Puppet Templates"
