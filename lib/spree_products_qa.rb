require 'spree_core'
require 'spree_products_qa/engine'
require 'spree_products_qa/configuration'

module SpreeProductsQa
  def self.send_email?
    return false
    # defined?(Redis) && Redis.current.connected?
  end

  def config(*)
    yield(Spree::ProductsQa::Config)
  end
end
