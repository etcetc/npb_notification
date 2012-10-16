# -*- encoding: utf-8 -*-
require File.expand_path('../lib/npb_notification/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Farhad Farzaneh"]
  gem.email         = ["ff@onebeat.com"]
  gem.description   = %q{Makes it easy to send short email and sms messages to predefined users}
  gem.summary       = %q{Sometimes, especially in early production, you want to send a message when a meaningful event happens.  This gem makes it easy to do this using a simple npb_mail or npb_sms method}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "npb_notification"
  gem.require_paths = ["lib"]
  gem.version       = NpbNotification::VERSION
end
