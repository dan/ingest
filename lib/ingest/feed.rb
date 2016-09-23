module Ingest
  class Feed
    attr_accessor :copyright, :description, :etag, :items, :itunes_author,
                  :itunes_block, :itunes_categories, :itunes_email,
                  :itunes_explicit, :itunes_image, :itunes_keywords,
                  :itunes_new_feed_url, :itunes_name, :itunes_subtitle,
                  :itunes_summary, :language, :last_modified, :link,
                  :managing_editor, :published_at, :title

    # Fetches and parses an iTunes RSS feed based on the given URL.
    # Returns a Feed
    def self.fetch_and_parse(url)
      # Setup the content and etag variables
      content, etag = ''

      # Open the given URL and read the content and etag
      open(url, allow_redirections: :safe) do |source|
        content = source.read
        etag    = source.meta['etag']
      end
      
      # Parse the feed data
      rss = RSS::Parser.parse(content, false, false)

      # Create a new Feed
      feed = Ingest::Feed.new

      # Assign values from the parsed RSS
      feed.description          = rss.channel.description
      feed.etag                 = etag
      feed.itunes_author        = rss.channel.itunes_author
      feed.itunes_block         = rss.channel.itunes_block
      feed.itunes_explicit      = rss.channel.itunes_explicit
      feed.itunes_image         = rss.channel.itunes_image.href
      feed.itunes_keywords      = rss.channel.itunes_keywords.join(',')
      feed.itunes_new_feed_url  = rss.channel.itunes_new_feed_url
      feed.itunes_name          = rss.channel.itunes_owner.itunes_name
      feed.itunes_email         = rss.channel.itunes_owner.itunes_email
      feed.itunes_subtitle      = rss.channel.itunes_subtitle
      feed.itunes_summary       = rss.channel.itunes_summary
      feed.language             = rss.channel.language
      feed.link                 = rss.channel.link
      feed.managing_editor      = rss.channel.managingEditor
      feed.published_at         = rss.channel.pubDate
      feed.title                = rss.channel.title
    
      # iTunes categories are special snowflakes
      feed.itunes_categories = {}
      rss.channel.itunes_categories.each do |category|
        # Set the sub-category to be nil
        sub_category = nil
        unless category.itunes_category.nil?
          # Set a sub_category
          sub_category = category.itunes_category.text
        end
        # Add a new element to the hash and assign its sub-category
        feed.itunes_categories[category.text] = sub_category
      end

      # Setup the Feed's items array
      feed.items = []

      # Loop through the parsed RSS feed's items
      rss.items.each do |item|
        # Create a new FeedItem for each item from the RSS feed
        feed_item = Ingest::FeedItem.new

        # Assign values based on the RSS feed item
        feed_item.author           = item.author
        feed_item.content          = item.content_encoded
        feed_item.description      = item.description
        feed_item.enclosure_length = item.enclosure.length
        feed_item.enclosure_type   = item.enclosure.type
        feed_item.enclosure_url    = item.enclosure.url
        feed_item.guid             = item.guid.content
        feed_item.itunes_author    = item.itunes_author
        feed_item.itunes_block     = item.itunes_block
        feed_item.itunes_duration  = item.itunes_duration.content.to_s
        feed_item.itunes_explicit  = item.itunes_explicit
        feed_item.itunes_subtitle  = item.itunes_subtitle
        feed_item.itunes_summary   = item.itunes_summary
        feed_item.link             = item.link
        feed_item.published_at     = item.pubDate
        feed_item.title            = item.title
        if item.itunes_keywords.present?
          feed_item.itunes_keywords  = item.itunes_keywords.join(',')
        else
          feed_item.itunes_keywords  = ''
        end

        # Put the FeedItem into the Feed's items array
        feed.items << feed_item
      end

      # Return the Feed
      return feed
    end
  end
end
