# This module is used to push messages to us, nominally the system administrators...
# It uses the action_mailer modules for rails
module NoPlanB

  require 'actionmailer'

  module Notification
  
    class Emailer < NoPlanB::Notification::Notifier

      self.mailer_name = 'emailer_templates'
      self.config_name = 'email'
      
      class <<self
        attr_accessor :subject_prefix,:from,:to, :subject_line_length
    
        
      # We should be able to read the configurations from a config.yml file
      # else they can be explicitly set here
      # options:
      #  :subject_prefix => this prefix is added to the subject line of all emails
        def configure(params={})
          @subject_prefix = params[:subject_prefix].or_if_blank Config[:email,:subject_prefix]
          @from = params[:from].or_if_blank Config[:email,:from]
          @to = params[:to].or_if_blank Config[:email,:to]
          @subject_line_length = (Config[:email,:subject_line_length] || 50).to_i
        end
    
        def notify(message,options={})
          m = deliver_notification(message,options)
          m.to
        end
      end
      
      # Notify 
      # The following keywords are special, but anything else that is in theoptions field is printed in the email message
      #   :to => recipient(s) - can be an email itself or a reference to an entry in the notification_config file
      #   :from => who it should be from - typically not changed 
      #   :subject =>  the subject
      def notification(message,options={})
        to = options.delete(:to).or_if_blank(self.class.to)
        to = to.split(',') if to.respond_to?(:split)
        to = address_for(to)
        type = options.delete(:type) 
        from(options.delete(:from).or_if_blank(self.class.from))
        recipients(to)
        subject_line = (options.delete(:subject_prefix) || (self.class.subject_prefix ? "[#{self.class.subject_prefix} #{type}]".sub(' ]',']').gsub('[ ','[') : '') +  message).split("\n").first
        subject subject_line.briefly(self.class.subject_line_length)
        # logger.tmp_debug("options = #{options.inspect}")
        body options.merge(:message => message,:params  => options)
      end

      # Make sure we have configured the thing by default
      configure
      
    end
        
  end
  
end

