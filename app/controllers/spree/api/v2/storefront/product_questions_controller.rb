module Spree
  module Api
    module V2
      module Storefront
        class ProductQuestionsController < ::Spree::Api::V2::ResourceController
          include Spree::Api::V2::CollectionOptionsHelpers
          before_action :load_product, only: %i[index create]
          before_action :require_spree_current_user, only: [:create] unless SpreeProductsQa::Config[:allow_anonymous]

          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          def show
            render_serialized_payload { serialize_resource(resource) }
          end

          def create
            @product_question = Spree::ProductQuestion.new(product_question_params)
            @product_question.product = @product
            @product_question.user_id = spree_current_user&.id

            render_result(@product_question)
          end

          def update
            @product_question = Spree::ProductQuestion.find(params[:id])

            if @product_question.user_id == spree_current_user.id
              @product_question.update(product_question_params)
              render_serialized_payload { serialize_resource(@product_question) }
            else
              render_error_payload(Spree.t('products_qa.update_unauthorized'))
            end
          end

          def destroy
            @product_question = Spree::ProductQuestion.find(params[:id])

            if @product_question.user_id == spree_current_user.id
              @product_question.destroy
              render_serialized_payload { serialize_resource(@product_question) }
            else
              render_error_payload(Spree.t('products_qa.delete_unauthorized'))
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

          def product_questions
            Spree::ProductQuestion.for_user(spree_current_user).where(product: @product)
          end

          def collection
            Spree::ProductQuestion.filter_questions(product_questions, params) if @product
          end

          def load_product
            @product = Spree::Product.friendly.find(params[:product_id])
          end

          def permitted_product_question_attributes
            %i[content visible email full_name is_anonymous id]
          end

          def product_question_params
            params.require(:product_question).permit(permitted_product_question_attributes)
          end

          def render_result(product_question)
            if product_question.save
              render_serialized_payload { serialize_resource(product_question) }
            else
              # TODO: handle error from service
              render_error_payload(product_question.errors)
            end
          end
        end
      end
    end
  end
end
