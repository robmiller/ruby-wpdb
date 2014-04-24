require_relative '../../spec_helper'

require "open-uri"

module WPDB
  describe Config do
    it "correctly parses the sample wp-config" do
      sample_config = Pathname(__FILE__) + ".." + ".." + ".." + ".." + "data" + "wp-config-sample.php"
      live_url = "https://raw.githubusercontent.com/WordPress/WordPress/master/wp-config-sample.php"
      open(live_url) do |live|
        File.open(sample_config, "w") do |f|
          f.write live.read
        end
      end

      config = Config::WPConfig.new(sample_config).config

      config[:uri].should == "mysql2://username_here:password_here@localhost/database_name_here"
      config[:prefix].should == "wp_"
    end
  end
end
