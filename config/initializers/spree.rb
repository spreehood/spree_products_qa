Rails.application.config.after_initialize do
  Rails.application.config.spree_admin.store_nav_partials << 'spree/admin/shared/products_qa_nav'

  Rails.application.config.spree_admin.product_form_sidebar_partials << 'spree/admin/shared/product_questions_link'
end
