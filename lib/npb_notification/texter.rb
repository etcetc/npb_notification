# This module is used to push messages to us, nominally the system administrators...
# It uses the action_mailer modules for rails
module NoPlanB

  module Notification
  
    # This texter sends the sms messages via email using the SMS email gateway
    class Texter < NoPlanB::Notification::Notifier
    
      self.mailer_name = 'emailer_templates'
      self.config_name = 'sms'
    
      class <<self
        attr_accessor :subject_prefix,:from,:to, :subject_line_length
        def notify(message,options={})
          recipients = Array(address_for(options[:to] || Config[:sms,:to] )).select { |r| r.to_s.match(/(^|:)\d+/) }
          recipients.each do |to|
            deliver_notification(message,to,options)
          end
          recipients
        end
        
        def load_gateways
          @@gateways = YAML.load(File.open(File.join(File.dirname(__FILE__),"..","config","gateways.yml")))
        end
        
      end
      
      # Notify 
      def notification(message,to,options={})
        if m = to.match(/:/) 
          carrier, to = m.pre_match,m.post_match
        elsif !to.index("@")
          carrier = options[:carrier] 
        end
        if carrier && @@gateways[carrier]
          to = "#{to}@#{@@gateways[carrier]}"
        end
        puts "to = #{to}, carrier=#{carrier}"
        unless to.blank?
          from(options[:from] || Config[:sms,:from])
          recipients(to)
          body message
        end
      end

      # private

      # def phone_number_for(key)
      #   key = key.strip
      #   # puts "finding phone for #{key.inspect}"
      #   if key.match(/^[\d -]+$/)
      #     num = key.sub(/\D/,'')
      #   else
      #     addresses = Config[:sms,:addresses]
      #     unless addresses.blank? 
      #       num = addresses[key]
      #     end
      #   end
      #   num
      # end

      load_gateways
      
    end
       
     
  end
  
end
