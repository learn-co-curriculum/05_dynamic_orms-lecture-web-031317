require 'bundler' # requires the bundler gem
Bundler.require # go look at the gem file, require all the gems that are listed

DB = {
  conn: SQLite3::Database.new('db/twitter.db')
}

DB[:conn].results_as_hash = true


require_relative '../lib/tweet.rb'
require_relative '../lib/tweets_app.rb'
