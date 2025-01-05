
<!-- <p align="right">
    <a href="https://badge.fury.io/rb/just-the-docs"><img src="https://badge.fury.io/rb/just-the-docs.svg" alt="Gem version"></a> <a href="https://github.com/just-the-docs/just-the-docs/actions/workflows/ci.yml"><img src="https://github.com/just-the-docs/just-the-docs/actions/workflows/ci.yml/badge.svg" alt="CI Build status"></a> <a href="https://app.netlify.com/sites/just-the-docs/deploys"><img src="https://api.netlify.com/api/v1/badges/9dc0386d-c2a4-4077-ad83-f02c33a6c0ca/deploy-status" alt="Netlify Status"></a>
</p>
<br><br>
<p align="center">
    <h1 align="center">Just the Docs</h1>
    <p align="center">A modern, highly customizable, and responsive Jekyll theme for documentation with built-in search.<br>Easily hosted on GitHub Pages with few dependencies.</p>
    <p align="center"><strong><a href="https://just-the-docs.com/">See it in action!</a></strong></p>
    <br><br><br>
</p>

<p align="center">A video walkthrough of various Just the Docs features</p>

https://user-images.githubusercontent.com/85418632/211225192-7e5d1116-2f4f-4305-bb9b-437fe47df071.mp4 -->

## Quiz feature added!

Heavily inspired by [mkdocs-jekyll](https://github.com/vsoch/mkdocs-jekyll) please check them out
I followed their [PR](https://github.com/vsoch/mkdocs-jekyll/commit/bcdae2d5b86f436441ff9ec273662445d49b78c9) to implement my quiz feature :D Thanks again!

## PageCrypt was used as static github page encrptions
> It was inspired by [github-pages-jekyll-password-protection](https://github.com/evanbaldonado/github-pages-jekyll-password-protection)
> Further enhanced with password read in from GITHUB_SECRETS instead of _protected_pages.txt


## Ruby (update from ruby 3.1.0p0 --> 3.3.1): Fixing Ruby compiler issue
> I pretty much gave up on using RVM and used asdf instead (RVM = manages Ruby Version, asdf = manages more than Ruby, could be python ...) 
> There are some conflicts with rvm & asdf, hence rvm was removed. Use `rvm implode` to remove all /rvm & `gem uninstall rvm` removing all rvm gems rubies

note: both rvm and asdf are dependencies managing tools 

### Reference  from (https://gorails.com/setup/ubuntu/24.04)

1. Install all Ruby deps: <br/>

```bash 
sudo apt-get update && sudo apt-get install git-core zlib1g-dev build-essential libssl-dev && libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev  && libcurl4-openssl-dev software-properties-common libffi-dev 
```

For MacOS using homebrew:
```bash
brew update && brew install git zlib openssl readline libyaml sqlite libxml2 libxslt curl libffi
```

2. Install Ruby version manager : ASDF <br/>

```bash
cd
git clone https://github.com/excid3/asdf.git ~/.asdf
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
echo 'legacy_version_file = yes' >> ~/.asdfrc
echo 'export EDITOR="code --wait"' >> ~/.bashrc
exec $SHELL # MacOS: source ~/.bashrc or source ~/.bashrc
```

3. Install ASDF plugin
```bash
asdf plugin add ruby
asdf plugin add nodejs
```

4. Install desired Ruby
```bash
asdf install ruby 3.3.1
asdf global ruby 3.3.1
```

5. Update latest Rubygems version
```bash
gem update --system
```

6. Check Ruby version and which Ruby dir
```bash
which ruby && ruby -v
``` 

7. cd back to the-docs dir and insatll/update all the bundle exes
```bash
bundle install
```

8. Update to Latest Gem & install bundler (= Ruby dep manager)
```bash
gem update --system && gem install bundler
```
9. Gem install the missing deps and bundle install again
```bash
gem install io-event -v 1.2.3
gem install ruby2_keywords -v 0.0.5
bundle install --force
```

10. cd back to the-docs and start up server:
```bash
bundle exec jekyll serve --livereload
```

Note: In case there are any errors/ warning messages when calling Gem
You can try `gem pristine <affected gem deps> --version <targeted-version>`
(i.e. gem pristine gem-wrappers --version 1.4.0)

## Setting up deployment (Jekyll -> Github Page Site):
Refer to this Github [document](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll#creating-your-site)

High-level logic:
- Prereqs:
    - Jekyll (a Gem)
    - Bundler (a Gem and a Ruby dep orchestraor)
    - Ruby

1. Deploying Jekyll to GitHub Pages:
Github repo -> Settings -> Pages -> Branch select main, /root 

2. The default Github Action will run
Based on this workflow file: Not 100% sure what this is

Default by github: pages build and deployment 
Manually create workflows please click [here](https://jekyllrb.com/docs/continuous-integration/github-actions/)

## Installation

### Use the template

The [Just the Docs Template] provides the simplest, quickest, and easiest way to create a new website that uses the Just the Docs theme. To get started with creating a site, just click "[use the template]"!

Note: To use the theme, you do ***not*** need to clone or fork the [Just the Docs repo]! You should do that only if you intend to browse the theme docs locally, contribute to the development of the theme, or develop a new theme based on Just the Docs.

You can easily set the site created by the template to be published on [GitHub Pages] – the [template README] file explains how to do that, along with other details.

If [Jekyll] is installed on your computer, you can also build and preview the created site *locally*. This lets you test changes before committing them, and avoids waiting for GitHub Pages.[^2] And you will be able to deploy your local build to a different platform than GitHub Pages.

More specifically, the created site:

- uses a gem-based approach, i.e. uses a `Gemfile` and loads the `just-the-docs` gem
- uses the [GitHub Pages / Actions workflow] to build and publish the site on GitHub Pages

Other than that, you're free to customize sites that you create with the template, however you like. You can easily change the versions of `just-the-docs` and Jekyll it uses, as well as adding further plugins.

### Use RubyGems

Alternatively, you can install the theme as a Ruby Gem, without creating a new site.

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "just-the-docs"
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: just-the-docs
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install just-the-docs

Alternatively, you can run it inside Docker while developing your site

    $ docker-compose up

## Usage

[View the documentation][Just the Docs] for usage information.

## Contributing

Bug reports, proposals of new features, and pull requests are welcome on GitHub at https://github.com/just-the-docs/just-the-docs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Submitting code changes:

- Submit an [Issue](https://github.com/just-the-docs/just-the-docs/issues) that motivates the changes, using the appropriate template
- Discuss the proposed changes with other users and the maintainers
- Open a [Pull Request](https://github.com/just-the-docs/just-the-docs/pulls)
- Ensure all CI tests pass
- Provide instructions to check the effect of the changes
- Await code review

### Design and development principles of this theme:

1. As few dependencies as possible
2. No build script needed
3. First class mobile experience
4. Make the content shine

## Development

To set up your environment to develop this theme: fork this repo, the run `bundle install` from the root directory.

A modern [devcontainer configuration](https://code.visualstudio.com/docs/remote/containers) for VSCode is included.

Your theme is set up just like a normal Jekyll site! To test your theme, run `bundle exec jekyll serve` and open your browser at `http://localhost:4000`. This starts a Jekyll server using your theme. Add pages, documents, data, etc. like normal to test your theme's contents. As you make modifications to your theme and to your content, your site will regenerate and you should see the changes in the browser after a refresh, just like normal.

When this theme is released, only the files in `_layouts`, `_includes`, and `_sass` tracked with Git will be included in the gem.

## License

The theme is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[^2]: [It can take up to 10 minutes for changes to your site to publish after you push the changes to GitHub](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll#creating-your-site).
fortunately for me, the cicd rendering takes no more than 2 mins.


[Jekyll]: https://jekyllrb.com
[Just the Docs Template]: https://just-the-docs.github.io/just-the-docs-template/
[Just the Docs]: https://just-the-docs.com
[Just the Docs repo]: https://github.com/just-the-docs/just-the-docs
[GitHub Pages]: https://pages.github.com/
[Template README]: https://github.com/just-the-docs/just-the-docs-template/blob/main/README.md
[GitHub Pages / Actions workflow]: https://github.blog/changelog/2022-07-27-github-pages-custom-github-actions-workflows-beta/
[use the template]: https://github.com/just-the-docs/just-the-docs-template/generate
