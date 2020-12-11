module Spree
  module Api
    module V2
      module Storefront
        class ProductQuestionsController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers
          before_action :load_product, only: [:index, :create]
          before_action :load_product_question, only: [:update, :destroy]

          def index
            render_serialized_payload {serialize_collection(paginated_collection)}
          end

          def show
            render_serialized_payload { serialize_resource(resource) }
          end

          def create
            @product_question = Spree::ProductQuestion.new(product_question_params)
            @product_question.product = @product
            @product_question.user = spree_current_user if spree_user_signed_in?

            render_result(@product_question)
          end

          def update
            if @product_question.update(product_question_params)
              render_serialized_payload {serialize_resource(@product_question)}
            else
              render_error_payload(product_question.errors)
            end
          end

          def destroy
            # TODO: fix permission
            # authorize! :destroy, @product_question
            if @product_question.destroy
              render_serialized_payload { serialize_resource(@product_question) }
            else
              render_error_payload('Something went wrong')
            end
          end

          private

          def create_service
            Spree::Api::Dependencies.storefront_account_create_address_service.constantize
          end

          def scope
            Spree::ProductQuestion
          end

          def resource
            scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def collection_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def paginated_collection
            collection_paginator.new(collection, params).call
          end

          def collection
            Spree::ProductQuestion.visible.where(product: @product)
          end

          def load_product
            @product = Spree::Product.friendly.find(params[:product_id])
          end

          def load_product_question
            @product_question = Spree::ProductQuestion.find(params[:id])
          end

          def permitted_product_question_attributes
            [:content, :visible]
          end

          def product_question_params
            params.require(:product_question).permit(permitted_product_question_attributes)
          end

          def render_result(product_question)
            if product_question.save
              render_serialized_payload {serialize_resource(product_question)}
            else
              # TODO handle error from service
              render_error_payload(product_question.errors)
            end
          end
        end
      end
    end
  end
end
