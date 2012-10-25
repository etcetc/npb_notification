# This module is used to push messages to us, nominally the system administrators...
# It uses the action_mailer modules for rails

module NpbNotification

  # This texter sends the sms messages via email using the SMS email gateway
  class Texter < NpbNotification::Notifier

    self.config_name = :sms

    class <<self

      # main method for sending texts.  You can add multiple 
      def notify(message,options={})
        recipients = Array(address_for(options.delete(:to) || Config[:sms][:to] ))
        recipients.each do |to|
          notification(message,to,options).deliver
        end
        recipients
      end

      # load the gateways file if one exists in the config directory, else use the one we're providing
      def load_gateways
        gateway_file = defined?(Rails) && Rails.root && File.join(Rails.root,'config','sms_gateways.yml') 
        gateway_file = File.join(File.dirname(__FILE__),"..","config","sms_gateways.yml") unless gateway_file && File.exist?(gateway_file)

        @@gateways = YAML.load_file(gateway_file)
      end
      
      def address_for(a)
        Array(super).map { |to| 
          m = to.strip.match("([^@]+)@(.+)")
          if m[2].index('.')
            to
          else
            carrier = m[2].downcase
            to = "#{m[1]}@#{@@gateways[carrier]}"
          end
        }
      end
    end
    

    # The to part of the notification is simply the full address, including the full gateway name, such as joe@txt.att.net,
    # or joe@att, in which case we pull the gateway address from the gateways file
    def notification(message,to,options={})
      unless to.blank?
        mail(
          :from => options[:from] || Config[:sms][:from],
          :to => to,
          :body => message
          )
      end
    end

    load_gateways
    
  end


end

