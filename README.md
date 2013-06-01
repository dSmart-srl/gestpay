# Gestpay

[![Build Status](https://travis-ci.org/momitians/gestpay.png?branch=master)](https://travis-ci.org/momitians/gestpay)
[![Dependency Status](https://gemnasium.com/momitians/gestpay.png)](https://gemnasium.com/momitians/gestpay)
[![Code Climate](https://codeclimate.com/github/momitians/gestpay.png)](https://codeclimate.com/github/momitians/gestpay)

Service wrapper for BancaSella Gestpay interface.

## Installation

Add this line to your application's Gemfile:

    gem 'gestpay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gestpay

## Usage

You can setup the gem in a Rails project using an initializer like this:

```ruby
Gestpay.setup do |config|
  config.account = 'GESPAY12345'
  config.environment = :test # default, change it to :production when ready
end
```

or using an export:

```shell
export GESTPAY_ACCOUNT=GESPAY12345
export GESTPAY_ENVIRONMENT=test
```

You then have two different classes: `Gestpay::Digest` will help with the Crypt/Decrypt web service, while `Gestpay::Gateway` with the server-to-server webservice operations.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

Released under the [MIT License](http://www.opensource.org/licenses/MIT). © 2013 [Momit S.r.l.](http://momit.it/)
