# This module is used to push messages to us, nominally the system administrators...
# It uses the action_mailer modules for rails

module NpbNotification

  class Emailer < NpbNotification::Notifier

    self.config_name = :email
    
    class <<self
        
      def subject_line_length
        (Config[:email][:subject_line_length] || 50).to_i
      end

      def notify(message,options={})
        recipients = Array(address_for(options.delete(:to) || Config[:email][:to] ))        
        m = notification(message,recipients, options)
        m.deliver
        m
      end
    end
    
    # Notify 
    # The following keywords are special, but anything else that is in theoptions field is printed in the email message
    #   :to => recipient(s) - can be an email itself or a reference to an entry in the notification_config file
    #   :from => who it should be from - typically not changed 
    #   :subject =>  the subject
    def notification(message,to, options={})
      type = options.delete(:type) 
      @params = options
      @message = message

      subject_line = options.delete(:subject) || ((self.class.subject_prefix ? "[#{self.class.subject_prefix} #{type}]".sub(' ]',']').gsub('[ ','[') : '') +  message).split("\n").first
      mail(:to => to, 
           :from => options.delete(:from).or_if_blank(Config[:email][:from]),
           :subject => subject_line.briefly(self.class.subject_line_length),
           :template_path => ""
        )

    end
    
  end
      
end


