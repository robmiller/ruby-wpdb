module WPDB
  module Config
    module ConfigFormat
      def initialize(file)
        if file.respond_to? :read
          @contents = file.read
        else
          @contents = File.read(file)
        end

        parse
      end

      def config
        uri  = 'mysql2://'
        uri += "#{@config['username']}:#{@config['password']}"
        uri += "@#{@config['hostname']}"
        uri += ":#{@config['port']}" if @config['port']
        uri += "/#{@config['database']}"

        { uri: uri, prefix: @config['prefix'] }
      end
    end

    class YAML
      include ConfigFormat

      def parse
        @config = ::YAML::load(@contents)
      end
    end

    class WPConfig
      include ConfigFormat

      def parse
        config = Hash[@contents.scan(/define\((?:'|")(.+)(?:'|"), *(?:'|")(.+)(?:'|")\)/)]
        @config = {
          "username" => config["DB_USER"],
          "password" => config["DB_PASSWORD"],
          "hostname" => config["DB_HOST"],
          "database" => config["DB_NAME"],
          "prefix"   => config["DB_PREFIX"] || "wp_"
        }
      end
    end
  end
end
