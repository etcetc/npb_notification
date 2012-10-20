module NpbNotification
  class Config 
    class << self
      # Set the absolute location of the config file
      def config_file=(config_file)
        @config_file = config_file
      end

      def config_file
        @config_file || (defined?(Rails) ? File.join(Rails.root,"config","notifications.yml") : nil)
      end

      def load_config_file
        @config = symbolize_all_keys(YAML.load_file(config_file)) || {}
      end

      # Show the config file data
      def data
        @config || load_config_file
      end

      # Symbolize keys recursively
      def symbolize_all_keys(hashie)
        if Hash === hashie
          h = hashie.symbolize_keys
          h.each do |key,value|
            h[key] = symbolize_all_keys(value) if Hash === value
          end
        end
      end

      # Return the hash 
      # Note that if value is in dot-separated format, such as x.y, then
      # we consider it as data[x][y], with the difference that if data[x] is nil
      # we don't throw up an exception, but return nil
      def [](value)
        x = data
        value.to_s.split('.').each do |v|
          x = x[v.to_sym]
          break unless x
        end
        x
      end
    end

  end
end

if __FILE__ == $0
  require 'rubygems'
  require 'active_support'
  require 'test/unit'

  class TestConfig < Test::Unit::TestCase

    def test_symbolize_keys
      h = {"x" => {"y" => {"z" => "v"}},"x2" => [1,2],'x3' => {3 => 10}}
      h2 = NpbNotification::Config.symbolize_all_keys(h.clone)
      puts h2.inspect
      assert(Hash === h2[:x] )
      assert(Hash === h2[:x][:y] )
      assert("v" === h2[:x][:y][:z] )
    end

  end
end