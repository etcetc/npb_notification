require "npb_notification/version"

module NoPlanB::Notification

  require 'npb_notification/config'
  require 'npb_notification/notifier'
  require 'npb_notification/emailer'
  require 'npb_notification/texter'
  
  def self.included(base)
    base.send(:extend,ClassMethods)
    base.send(:include,InstanceMethods)
  end
  
  module ClassMethods
    
    def npb_mail(*args)
      NoPlanB::Notification::Emailer.notify(*args)
    end
    alias_method :npb_email,:npb_mail
    
    def npb_sms(*args)
      NoPlanB::Notification::Texter.notify(*args)
    end
    alias_method :npb_text,:npb_sms
    
    def npb_notify(*args)
      npb_mail(*args)
      npb_sms(*args)
    end
  end
  
  module InstanceMethods

    def npb_mail(*args)
      self.class.npb_mail(*args)
    end
    alias_method :npb_email,:npb_mail
    
    def npb_sms(*args)
      self.class.npb_sms(*args)
    end
    alias_method :npb_text,:npb_sms
    
    def npb_notify(*args)
      npb_mail(*args)
      npb_sms(*args)
    end

  end


end
