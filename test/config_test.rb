require_relative 'test_helper'

require "open-uri"

describe "Config" do
  it "correctly parses the sample wp-config" do
    sample_config = Pathname(__FILE__) + ".." + ".." + "data" + "wp-config-sample.php"
    live_url = "https://raw.githubusercontent.com/WordPress/WordPress/master/wp-config-sample.php"
    open(live_url) do |live|
      File.open(sample_config, "w") do |f|
        f.write live.read
      end
    end

    config = WPDB::Config::WPConfig.new(sample_config).config

    assert_equal "mysql2://username_here:password_here@localhost/database_name_here", config[:uri]
    assert_equal "wp_", config[:prefix]
  end
end
