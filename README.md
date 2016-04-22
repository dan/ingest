# Ingest

Ingest is a library designed to help fetch and parse podcast RSS feeds.

Installation:

```
gem 'ingest', '~> 1.0.4'
```

## Example Usage for Importing a Bunch of Episodes from a Podcast RSS Feed

```
def import_episodes_from_rss!(rss_feed_url)
  parsed_feed = Ingest::Feed.fetch_and_parse(rss_feed_url)
  parsed_feed.items.sort_by(&:published_at).each do |item|
    episode = Episode.create(
      imported_guid:      item.guid,
      title:              item.title,
      short_description:  item.itunes_subtitle,
      long_description:   item.description,
      publish_at:         item.published_at,
      explicit:           item.itunes_explicit,
      keywords:           item.itunes_keywords
    )
    Rails.logger.info("Imported: #{episode.title}")
  end
end
```
