module Spree
  module Admin
    class ProductQuestionSettingsController < Spree::Admin::BaseController
      def update
        preference_params.each do |name, value|
          integer_prefs = [:preview_size, :paginate_size]
          
          if integer_prefs.include?(name.to_sym)
            value = value.to_i
          else
            value = ActiveModel::Type::Boolean.new.cast(value)
          end
          
          preference_key = "spree_products_qa/config/#{name}"
          Spree::Preference.where(key: preference_key).destroy_all
          Spree::Preference.create(key: preference_key, value: value)
          
          SpreeProductsQa::Config[name] = value if SpreeProductsQa::Config.respond_to?("#{name}=")
        end

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:product_question_settings, scope: :products_qa))
        redirect_to edit_admin_product_question_settings_path
      end

      private

      def preference_params
        params.permit(
          :allow_anonymous
        )
      end
    end
  end
end
