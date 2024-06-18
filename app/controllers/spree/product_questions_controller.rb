module Spree
  if Spree::Core::Engine.frontend_available?
    class ProductQuestionsController < StoreController
      before_action :load_data

      def create
        question = @product.product_questions.new(allowed_params)
        question.user_id = current_spree_user.id
        if question.save
          flash[:notice] = t('question.sent')
          redirect_to @product
        else
          flash[:error] = question.errors.full_messages.to_sentence
          redirect_to @product
        end
      end

      private

      def load_data
        @product = Spree::Product.find(allowed_params[:product_id])
      end

      def allowed_params
        params.require(:product_question).permit(:content, :product_id)
      end
    end
  else
    class ProductQuestionsController
      # Dummy class to satisfy Zeitwerk autoloading
    end
  end
end