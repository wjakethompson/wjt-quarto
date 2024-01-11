---
title: "Integrating Blogdown with GitHub Pages and Travis-CI"
date: 2017-05-31
subtitle: ""
description: "Get up and running with automated builds for your blogdown website"
image: "featured-blogdown-hex.png"
twitter-card:
  image: "featured-blogdown-hex.png"
open-graph:
  image: "featured-blogdown-hex.png"
categories:
  - R
  - blogdown
  - gh-pages
  - travis-ci
---



I recently converted my website from [Jekyll](https://jekyllrb.com/) to [Hugo](https://gohugo.io/) with [**blogdown**](https://github.com/rstudio/blogdown). If you haven't tried out **blogdown** yet, Yihui Xie just hosted a [webinar](https://www.rstudio.com/resources/webinars/introducing-blogdown-a-new-r-package-to-make-blogs-and-websites-with-r-markdown/) that does a great job of introducing the package. This post won't focus on how to use **blogdown** to create a website, but rather how to host that website on GitHub pages and use Travis-CI to automatically update the website. For this post, I'm assuming that you're making a user or organization site. However, the changes for a project site are fairly straightforward, and I'll point those out as we go through the example.

## Step 1: Create your website

This is probably the most important and time consuming step, so naturally I'll be spending the least amount of time on it. There are extensive resources already for how to create and modify a **blogdown** website (for example [here](https://www.rstudio.com/resources/webinars/introducing-blogdown-a-new-r-package-to-make-blogs-and-websites-with-r-markdown/) and [here](https://bookdown.org/yihui/blogdown/)). I will note two specific settings that are important. First, when creating the **blogdown** project in RStudio, initialize a git repository. Second, because Hugo never cleans up the `public/` directory, old pages that you no longer wish to be published will still be present in that directory. Therefore, I suggest adding "public" to the .gitignore file. If you aren't using RStudio, you can accomplish these tasks by executing the following commands in your terminal (assuming you are in the directory of your project)


```bash
# Initialize git repository
git init

# Create .gitignore with "public"
echo "public" > .gitignore

# Commit .gitignore
git add .gitignore
git commit -m "add .gitignore"

# Commit website files
git add --all
git commit -m "initial website commit"
```

At the end of this step, you should have a directory with all of the website files (e.g., `blogdown/`, `content/`, `public/`, `themes/`, etc.), and a local git repository that you've committed all of the files to. Note that we haven't pushed anything to a remote repository on GitHub yet. That is what comes next!

## Step 2: Push files to GitHub

Now that you have a website that is ready to be published, we can push the files to GitHub. However, we face a complication in that for user or organization pages, the content has to be built from the `master` branch. This means that we'll have to do a little extra work to make things publish correctly. I should note that there is more than one way to do this. Amber Thomas outlined one way this can be accomplished [here](https://proquestionasker.github.io/blog/Making_Site/). However, this involves creating sub-branches inside the public folder. As someone is far from an expert in git and GitHub I found this process to be very confusing, and despite my best efforts, I always ended up with merge conflicts that were difficult for me to trace. So here I outline a different strategy based on the instructions Yihui provided for [hosting a **bookdown** book](https://bookdown.org/yihui/bookdown/github.html) that I think is more straightforward.

First, we need to create a new repository by logging into GitHub and going to https://github.com/new. For user and organization pages, the repository name must be `<username>.github.io` (for me this is `wjakethompson.github.io`). For project pages, this can be anything you want. Add a description if you want, and then accept the default settings of the repository (i.e., don't initialize with a README, .gitignore, or license).

Now, back on our local machine, we'll make a new branch called `sources`, and make this the default branch. Then, delete the `master` branch. To push the `sources` branch to GitHub, we'll add the remote repository, and then push (you may have to authenticate GitHub if you haven't done this before).


```bash
# Create sources branch
git branch -b sources

# Make sources the default branch
git symbolic-ref HEAD refs/heads/sources

# Delete the master branch
git branch -d master

# Add remote repository
git remote add origin https://github.com/<username>/<repo-name>.git

# Verify remote
git remote -v

# Push sources to remote
git push -u origin sources
```

Now if you go look at the repository on GitHub, you should see that there is one branch (`sources`), that has all of the files in your local directory (except for the `public/` directory and any other files in your .gitignore).

Now we need to publish the static files from the public folder to a new master branch. We create a new branch called `master` and then remove all files from this branch. Then we can add a file called .nojekyll that tell GitHub pages not to use Jekyll to build the website (Hugo has already generated the static files for us). We can then commit this file and push to the master branch in our remote repository.


```bash
# Create master branch and clean all files
git checkout --orphan master
git rm -rf .

# Create file to tell GitHub not to use Jekyll
touch .nojekyll

# Push master branch to remote
git add .nojekyll
git commit -m "initial commit"
git push origin master
```

Now when you look at the GitHub repository, you should see there are two branches, and when you look at the `master` branch, you'll only see the .nojekyll file.

If you're creating a project page instead of a user or organization page, you can skip moving everything to a `sources` branch and just leave in on the `master` branch. Then, instead of creating a new branch called `master` containing the .nojekyll file, name the new branch `gh-pages`, and in the last line use `git push origin gh-pages`.

## Step 3: Let Travis-CI build the website

Travis is a continuous integration software. Essentially, it's a virtual machine that can run commands for you, and it's free for public GitHub repositories. To activate Travis for your website, log in to https://travis-ci.org/ using your GitHub account. Then under your name at the top, click "Accounts", and then turn on your website's repository.

There a few things you'll need to do in order to make Travis work for building your website. First, you need to grant Travis write access to your repository. To do this, create a [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) on GitHub. Then go to https://travis-ci.org/username/repo-name/settings, and create a new environment variable called `GITHUB_PAT` with the personal access token you just generated. Alternatively, you can use the Travis command line tool to encrypt your GitHub token using `travis encrypt GITHUB_PAT=TOKEN`.

Finally, there are four files that you'll need to add to the top level of your website directory. The first two are `_build.sh` and `_deploy.sh`. These are the scripts that Travis will execute to build and deploy your website whenever you push changes to GitHub. Because the `public/` directory isn't in your git repository (by design), we have to build the website on Travis. This can be done with build script that looks like this:


```bash
#!/bin/sh

Rscript -e "blogdown::install_hugo(); blogdown::build_site(local = FALSE,
  method = 'html_encoded')"
```

We first make sure that Hugo is installed on Travis, and then build the website using `blogdown::build_site`. For my website I use `method = 'html_encoded'`, but you can change this to whichever method you prefer. This will create a `public/` directory on the virtual Travis machine. We can then publish the files in this directory to our `master` branch on GitHub using the deploy script.


```bash
#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "sources" ] && exit 0

# Configure GitHub username and email
git config --global user.email "your_email@email.com"
git config --global user.name "Your Name"

# Clone repository into blog-output directory
git clone -b master \
  https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git \
  blog-output

# Move to blog-output directory
cd blog-output

# Copy website files from public/ to blog-output/
cp -r ../public/* ./

# Add and commit files to the master branch
git add --all *
git commit -m "Update the blog" || true
git push -q origin master
```

In the deploy script we first do some checks to make sure the script should run (e.g., `GITHUB_PAT` is defined, the `sources` branch is being built). Then we configure our username and email for GitHub, these should match what you used to set up your GitHub account. Once the setup is complete, we clone the `master` branch into a new `blog-output/` directory, and copy the contents of the `public/` directory (which was created in the build script) to the `blog-output/` directory as well. Finally we add, commit, and push all of these files to the `master` branch. Once the files are on the `master` branch, the website will be hosted!

There are two more files that need to be in place for this to work. The first is a DESCRIPTION file. Because Travis is normally used for checking *R* packages, it requires a DESCRIPTION file to be present in order to know what packages to install as dependencies. This doesn't need to be a full DESCRIPTION file given that this is only being used for Travis, so you might have a file that looks like this:

```dcf
Package: username.github.io
Title: My blog!
Version: 1.0
URL: https://github.com/username/username.github.io
Imports:
  blogdown,
  ggplot2,
  knitr
Remotes:
  rstudio/blogdown,
  tidyverse/ggplot2
```

The most important thing to note is that if a dependency isn't on CRAN (like **blogdown** for instance) it needs to be listed under `Remotes`. Any package listed under `Remotes` will be installed from GitHub using **devtools**.

The final file you need is a `.travis.yml` file. This is the file tells Travis what it's supposed to be doing. The `travis.yml` file for my website looks like this:

```yaml
language: R
pandoc_version: 1.17.2
cache: packages
repos:
  CRAN: https://cran.rstudio.com/
  KRAN: http://rweb.crmda.ku.edu/kran/

before_script:
  - chmod +x ./_build.sh
  - chmod +x ./_deploy.sh

script:
  - ./_build.sh
  - ./_deploy.sh
```

The first section of commands sets up the Travis environment. Here we define the language we're using, the version of *pandoc* that we want, and the CRAN repositories that we want to use to download packages. We can also tell Travis to cache our packages so that they don't have to be installed every time the website is built. If you used `travis encrypt` for you GitHub token, you'll need to add a section to define the encrypted token that looks like this:

```yaml
env:
  global:
    - secure: ENCRYPTED_GITHUB_TOKEN
```

In `before_script` we run two commands that ensure the `_build.sh` and `_deploy.sh` scripts can be run. Then in `script`, we tell Travis to first run the build script and then the deploy script. Once all four of these files have been created, add and commit them using RStudio or the command line terminal (make sure you're on the `sources` branch), and then push to GitHub. Once you push you can go to the Travis repository and watch your build happen in real time. Once it completes, your website will be live!

## Step 4: Update your website

Once you have GitHub and Travis set up, adding posts to your website or making changes is super easy. Just create new posts or edit old files, commit the changes, and when you're ready to publish your changes, push to GitHub. Travis will automatically build and deploy every time you push. As an added perk, if you happen to make a change that breaks everything (as I have been known to do), Travis will send you an email letting you know that your build failed so you can go back and fix it.

For an example of what the GitHub repository and all the scripts should look like to make this work, checkout the repository for my website at https://wjakethompson.com.
