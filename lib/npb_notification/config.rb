module NoPlanB
  module Notification
    class Config 
      class << self
        # Set the location of the config file
        def set_config_file(config_file)
          @config_file = config_file
        end

        def config_file
          @config_file
        end

        def load_config_file
          @config = symbolize_all_keys(YAML.load_file(config_file)) || {}
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
        def [](value)
          @config[value]
        end
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
      h2 = NoPlanB::Notification::Config.symbolize_all_keys(h.clone)
      puts h2.inspect
      assert(Hash === h2[:x] )
      assert(Hash === h2[:x][:y] )
      assert("v" === h2[:x][:y][:z] )
    end


    def test_config_file
      NoPlanB::Notification::Config.set_config_file("")
    end
  end
end