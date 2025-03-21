# frozen_string_literal: true

module Spree
  module Api
    module V2
      module Vendor
        class ProductQuestionsController < ResourceController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/questions
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          # GET /api/v2/vendor/vendors/:vendor_id/questions/:id
          def show
            question = resource.find(params[:id])

            if question
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          # PUT/PATCH /api/v2/vendor/vendors/:vendor_id/questions/:id
          def update
            question = resource.find(params[:id])

            if question.update(product_question_params)
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          # DELETE /api/v2/vendor/vendors/:vendor_id/questions/:id
          def destroy
            question = resource.find(params[:id])

            if question.destroy
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          private

          def paginated_collection
            collection_paginator.new(resource, params).call
          end

          def collection_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def resource_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def product_question_params
            params.require(:product_question).permit(:is_visible, product_answer_attributes: [:content])
          end

          def resource
            Spree::ProductQuestion.vendor_product_questions(@vendor.id)
          end

          def load_vendor
            @vendor ||= Spree::Vendor.friendly.find(params[:vendor_id])
          end

          def require_vendor_access
            raise CanCan::AccessDenied unless @vendor.users.include?(spree_current_user)
          end
        end
      end
    end
  end
end
