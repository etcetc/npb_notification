# NpbNotification

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'npb_notification'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install npb_notification

## Usage

This gem requires you to do two things: 1) In your initializers directory please add a file, such as notifications.rb, with the following content:

  require 'npb_notification'
  NpbNotification.setup

You also need to create the notifications config file, called notifications.yml that is placed in the config directory, and has a form like this:

  email:
    from: admin@mysite.com
    to: joe, jerry
    subject_prefix: MySite
    subject_line_length: 50
    addresses:
      joe: joe@mysite.com
      jerry: jerry@mysite.com
      harry: harry@gmail.com
      graders: jerry, joe

  sms:
    from: mysite <admin@mysite.com>
    subject_prefix: MYSITE
    to: jerry, joe
    addresses:
      joe: 2221114444@att
      jerry: 1112223333@verizon

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
