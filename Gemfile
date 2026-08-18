source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4.4.1"

# The site uses its own layouts in _layouts/, so no theme gem is needed.
# jekyll-sass-converter and kramdown are dependencies of jekyll itself and are
# deliberately not repeated here.

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-seo-tag"   # {% seo %} in _includes/head.html
  gem "jekyll-sitemap"   # sitemap.xml, referenced from robots.txt
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0" if Gem.win_platform?

# Necessary to run 'jekyll serve' (webrick left the stdlib in Ruby 3.0).
gem "webrick", "~> 1.9"

# Security floors that are stricter than what the dependency tree guarantees on its own.
# rexml is only reached through kramdown.
gem "rexml", ">= 3.4.4"

# Security fix for CVE-2021-32740 (>= 2.8.0); jekyll itself only asks for "~> 2.4"
gem "addressable", ">= 2.8.0"
