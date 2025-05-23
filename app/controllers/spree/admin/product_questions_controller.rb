module Spree
  module Admin
    class ProductQuestionsController < ResourceController
      belongs_to 'spree/product', find_by: :slug

      def index
        @product = Spree::Product.friendly.find(params[:product_id])
        @collection = @collection.page params[:page]
      end

      def edit
        @product_question = Spree::ProductQuestion.find(params[:id])
        @product_question.build_product_answer if @product_question.product_answer.nil?
      end

      def new
        @product_question = @product.product_questions.new
        @product_question.build_product_answer
      end

      def pending
        @collection = Spree::ProductQuestion.not_answered.joins(:product).map(&:product)
      end

      private

      def product_question_params
        params.require(:product_question).permit(
          :content, :user_id, :full_name, :email, :is_visible, :is_anonymous,
          product_answer_attributes: [:id, :content, :_destroy]
        )
      end
    end
  end
end
