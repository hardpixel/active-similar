# Active Similar

Ruby gem to find similar Active Record models through most common associations.

[![Gem Version](https://badge.fury.io/rb/active_similar.svg)](https://badge.fury.io/rb/active_similar)
[![Build](https://github.com/hardpixel/active-similar/actions/workflows/build.yml/badge.svg)](https://github.com/hardpixel/active-similar/actions/workflows/build.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/741c7fbb7ebb32bc0559/maintainability)](https://codeclimate.com/github/hardpixel/active-similar/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_similar'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_similar

## Usage

```ruby
require 'active_similar'

class Post < ActiveRecord::Base
  include ActiveSimilar

  has_many :categories
  has_many :tags

  scope :published, -> { where status: 'published' }
  scope :featured,  -> { where featured: true }

  has_similar :related, through: %i[categories tags], scope: :published
end

post = Post.find(1)
post.related # Returns similar posts to post #1

similar = ActiveSimilar::Query.new(Post.published, through: %i[categories tags])
similar.with(2) # Returns similar posts to post #2

similar = ActiveSimilar::Query.new(Post.featured, through: %i[categories])
similar.with(3) # Returns similar posts to post #3
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/active-similar.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
