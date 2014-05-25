Automating Puppet Testing - A Step-by-Step Guide
================================================

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
