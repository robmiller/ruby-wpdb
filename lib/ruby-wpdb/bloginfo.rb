require "uri"

module WPDB
  class Bloginfo
    class << self
      def get_bloginfo(key)
        case key
        when "home", "siteurl", "url"
          WPDB.home_url
        when "wpurl"
          WPDB.site_url
        when "description"
          Option.get_option("blogdescription")
        when "rdf_url"
          get_feed_link("rdf")
        when "rss_url"
          get_feed_link("rss")
        when "rss2_url"
          get_feed_link("rss2")
        when "atom_url"
          get_feed_link("atom")
        when "comments_atom_url"
          get_feed_link("comments_atom")
        when "comments_rss2_url"
          get_feed_link("comments_rss2")
        when "pingback_url"
          site_url("xmlrpc.php")
        end
      end
    end
  end

  class << self
    def home_url(path = nil, scheme = nil)
      make_url(Option.get_option("home"), path, scheme)
    end

    def site_url(path = nil, scheme = nil)
      make_url(Option.get_option("siteurl"), path, scheme)
    end

    def make_url(url, path = nil, scheme = nil)
      url = URI.parse(url + "/")

      url.scheme = scheme if ["http", "https", "relative"].include?(scheme)
      url = URI.join(url, path) if path

      url
    end
  end
end
