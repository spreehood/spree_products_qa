module SpreeProductsQa
  class Configuration < Spree::Preferences::Configuration
    # allow anonymous questions
    preference :allow_anonymous, :boolean, default: false

    def load_preferences
      stored_prefs = Spree::Preference.where("key LIKE 'spree_products_qa/config/%'")
      
      stored_prefs.each do |pref|
        preference_name = pref.key.gsub('spree_products_qa/config/', '')
        self[preference_name] = pref.value if respond_to?("#{preference_name}=")
      end
    end
  end
end
