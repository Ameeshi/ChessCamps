# require needed files
require 'helpers/validations'
require 'helpers/deletions'
require 'helpers/activeable'
require 'helpers/cart'
require 'helpers/simple_cart'
require 'helpers/demo_cart'

# create AppHelpers
module AppHelpers
  include AppHelpers::Validations
  include AppHelpers::Deletions
  include AppHelpers::Cart
  include AppHelpers::SimpleCart
  include AppHelpers::DemoCart
  include AppHelpers::Activeable::ClassMethods
  include AppHelpers::Activeable::InstanceMethods
end