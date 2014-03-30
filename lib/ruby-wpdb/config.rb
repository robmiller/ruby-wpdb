module WPDB
  module Config
    class YAML
      def initialize(file)
        if file.respond_to? :read
          @contents = file.read
        else
          @contents = File.read(file)
        end

        parse
      end

      def parse
        @config = ::YAML::load(@contents)
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

    class WPConfig
      def initialize(file)
        if file.respond_to? :read
          @contents = file.read
        else
          @contents = File.read(file)
        end

        parse
      end

      def parse
        @config = Hash[@contents.scan(/define\((?:'|")(.+)(?:'|"), *(?:'|")(.+)(?:'|")\)/)]
        @config['DB_PREFIX'] ||= 'wp_'
      end

      def config
        uri  = 'mysql2://'
        uri += "#{@config['DB_USER']}:#{@config['DB_PASSWORD']}"
        uri += "@#{@config['DB_HOST']}"
        uri += "/#{@config['DB_NAME']}"

        { uri: uri, prefix: @config['DB_PREFIX'] }
      end
    end
  end
end
