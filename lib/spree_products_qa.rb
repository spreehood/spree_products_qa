require 'spree_core'
require 'spree_products_qa/engine'

module SpreeProductsQa
  def self.send_email?
    defined?(Redis) && Redis.current.connected?
  end

  def config(*)
    yield(Spree::ProductsQa::Config)
  end
end
