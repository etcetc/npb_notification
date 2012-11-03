require "npb_notification/version"

module NpbNotification

  require 'extensions/object'
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
      NpbNotification::Emailer.notify(*args)
    end
    alias_method :npb_email,:npb_mail
    
    def npb_sms(*args)
      NpbNotification::Texter.notify(*args)
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

  # Setup the notifications
  def self.setup
    ActionController::Base.send(:include,NpbNotification)
    ActiveRecord::Base.send(:include,NpbNotification)
    ActionMailer::Base.append_view_path(File.join(File.dirname(__FILE__),"npb_notification","views"))
  end

end
