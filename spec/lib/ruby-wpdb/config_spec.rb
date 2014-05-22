require_relative '../../spec_helper'

require "open-uri"

module WPDB
  describe Config do
    let(:sample_yaml) {
      <<-EOYML
username: username_here
password: password_here
hostname: localhost
database: database_name_here
prefix: wp_
      EOYML
    }

    let(:sample_wordpress) {
      <<-EOWP
define('DB_USER',     "username_here");
define('DB_PASSWORD', 'password_here');
define('DB_HOST',     'localhost');
define('DB_PREFIX',   "wp_");
define('DB_NAME',     'database_name_here');
      EOWP
    }

    let(:different_prefix_yaml) {
      <<-EOYML
username: username_here
password: password_here
hostname: localhost
database: database_name_here
prefix: prefix_
      EOYML
    }

    let(:different_prefix_wordpress) {
      <<-EOWP
define('DB_USER',     "username_here");
define('DB_PASSWORD', 'password_here');
define('DB_HOST',     'localhost');
define('DB_PREFIX',   "prefix_");
define('DB_NAME',     'database_name_here');
      EOWP
    }

    let(:valid_uri) { "mysql2://username_here:password_here@localhost/database_name_here" }

    describe Config::WPConfig do
      it "correctly parses the sample wp-config" do
        sample_config = Pathname(__FILE__) + ".." + ".." + ".." + ".." + "data" + "wp-config-sample.php"
        live_url = "https://raw.githubusercontent.com/WordPress/WordPress/master/wp-config-sample.php"
        open(live_url) do |live|
          File.open(sample_config, "w") do |f|
            f.write live.read
          end
        end

        config = Config::WPConfig.new(sample_config).config

        config[:uri].should == valid_uri
        config[:prefix].should == "wp_"
      end

      it "parses wp-config files" do
        File.should_receive(:read).with("path/to/wp-config.php").and_return(sample_wordpress)

        config = Config::WPConfig.new("path/to/wp-config.php").config

        config[:uri].should == valid_uri
        config[:prefix].should == "wp_"
      end

      it "parses IO objects that return wp-config data" do
        io = StringIO.new(sample_wordpress)

        config = Config::WPConfig.new(io).config

        config[:uri].should == valid_uri
        config[:prefix].should == "wp_"
      end

      it "accepts different prefixes" do
        io = StringIO.new(different_prefix_wordpress)

        config = Config::WPConfig.new(io).config

        config[:prefix].should == "prefix_"
      end
    end

    describe Config::YAML do
      it "loads a local YAML file" do
        File.should_receive(:read).with("path/to/file.yaml").and_return(sample_yaml)

        config = Config::YAML.new("path/to/file.yaml").config

        config[:uri].should == valid_uri
        config[:prefix].should == "wp_"
      end

      it "parses IO objects that return YAML" do
        io = StringIO.new(sample_yaml)

        config = Config::YAML.new(io).config

        config[:uri].should == valid_uri
        config[:prefix].should == "wp_"
      end

      it "accepts different prefixes" do
        io = StringIO.new(different_prefix_yaml)

        config = Config::YAML.new(io).config

        config[:prefix].should == "prefix_"
      end
    end

    describe Config::AutoDiscover do
      let(:dir) { Pathname("path/to/dir") }

      describe "#file" do
        def test_config_file(file)
          File.stub(:exist?).and_call_original
          File.should_receive(:exist?).with(file).and_return(true)

          Config::AutoDiscover.new(dir).file.should == file
        end

        it "loads a wp-config.php file if there's one in the current directory" do
          test_config_file(dir + "wp-config.php")
        end

        it "loads a wp-config.php file if there's one in the directory above" do
          test_config_file(dir + ".." + "wp-config.php")
        end

        it "loads a wp-config.php file if there's one in a directory called wp/" do
          test_config_file(dir + "wp" + "wp-config.php")
        end

        it "loads a wp-config.php file if there's one in a directory called wordpress/" do
          test_config_file(dir + "wordpress" + "wp-config.php")
        end

        it "loads a config.yml file if there's one in the current directory" do
          test_config_file(dir + "config.yml")
        end

        it "should memoize the result" do
          file = dir + "wp-config.php"

          File.stub(:exist?).and_call_original
          File.should_receive(:exist?).exactly(1).times.with(file).and_return(true)

          config = Config::AutoDiscover.new(dir)
          config.file.should == file
          config.file.should == file
        end
      end
    end

    describe Config::AutoFormat do
      let(:dir) { Pathname("path/to/dir") }

      describe "#format" do
        it "recognises PHP files" do
          file = dir + "wp-config.php"

          config = Config::AutoFormat.new(file)
          config.format.should == Config::WPConfig
        end

        it "recognises YAML files" do
          file = dir + "test.yml"

          config = Config::AutoFormat.new(file)
          config.format.should == Config::YAML
        end
      end
    end
  end
end
