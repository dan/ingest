require 'open-uri'
require 'open_uri_redirections'
require 'rss'

module Ingest
  autoload :Feed,     'ingest/feed'
  autoload :FeedItem, 'ingest/feed_item'
end
