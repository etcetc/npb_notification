module NpbNotification

  class Notifier < ActionMailer::Base 
    # configure this so that it just looks here for the templates to use for the email

    class <<self
      attr_accessor :config_name
      
      def subject_prefix
        Config[config_name][:subject_prefix]  
      end

      # You can pass in a comma-separated string and it will return an array
      # if it doesn't find the address, it returns what was inside
      def address_for(a)
        a = a.split(',') if String === a
        addresses = Config[config_name][:addresses] || {}
        # logger.tmp_debug "config_name = #{config_name}, Addresses = #{addresses.inspect}, a=#{a.inspect}"
        if Array === a
          a.map { |b| (addresses[b.strip.to_sym] || b.strip).to_s }
        else
          a = a.strip
          # puts "finding address for #{alias.inspect}"
          addresses[a.to_sym].to_s || a
        end
      end

    end
    
    def address_for(*args)
      self.class.address_for(*args)
    end
    
  end
  
end

