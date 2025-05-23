module SpreeProductsQa
  class Configuration < Spree::Preferences::Configuration
    # allow anonymous questions
    preference :allow_anonymous, :boolean, default: false
  end
end
