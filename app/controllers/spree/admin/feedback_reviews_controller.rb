module Spree
  module Admin
    class FeedbackReviewsController < ResourceController
      belongs_to 'spree/review'
      helper Spree::ReviewsHelper
      before_action :load_review, only: [:create, :update]

      def index
        @collection = parent.feedback_reviews
      end

      def create
        if @review.present?
          @feedback_review = @review.feedback_reviews.new(feedback_review_params)
          @feedback_review.user = spree_current_user
          @feedback_review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]
          authorize! :create, @feedback_review
          @feedback_review.save
        end

        redirect_to :back
      end

      def update
        if @review.present?
          @feedback_review = Spree::FeedbackReview.find(params[:id])
          authorize! :update, @feedback_review
          @feedback_review.update_attributes(feedback_review_params)
        end
        redirect_to :back
      end

      private

      def load_review
        @review ||= Spree::Review.find_by_id!(params[:review_id])
      end

      def permitted_feedback_review_attributes
        [:rating, :comment]
      end


      def feedback_review_params
        params.require(:feedback_review).permit(permitted_feedback_review_attributes)
      end

    end
  end
end
