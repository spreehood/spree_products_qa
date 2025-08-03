require 'spree_core'
require 'spree_products_qa/engine'

module SpreeProductsQa
  def self.send_email?
    defined?(Redis) && Redis.new.ping == 'PONG'
  rescue Redis::CannotConnectError, Redis::ConnectionError
    false
  end

  def config(*)
    yield(Spree::ProductsQa::Config)
  end
end
