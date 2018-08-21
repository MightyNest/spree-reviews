class Spree::Admin::ReviewsController < Spree::Admin::ResourceController
  helper Spree::ReviewsHelper

  def index
    @reviews = collection
  end

  def approve
    review = Spree::Review.find(params[:id])
    if review.update_attribute(:approved, true)
      flash[:notice] = Spree.t(:info_approve_review)
    else
      flash[:error] = Spree.t(:error_approve_review)
    end
    redirect_to admin_reviews_path
  end

  def edit
    return if @review.product
    flash[:error] = Spree.t(:error_no_product)
    @edit_feedback_rating_stars = false

    redirect_to admin_reviews_path
  end

  def edit_product
  end

  def update_product
    variant = Spree::Variant.find(params[:variant_id])
    @review.product = variant.product
    if @review.save
      flash[:success] = "Updated product on review to #{variant.product.name}"
    else
      flash[:error] = "Could not update review. Errors: #{@review.errors.full_messages.join(' ')}"
    end

    redirect_to edit_admin_review_path(@review)
  end

  private

  def collection
    params[:q] ||= {}
    @search = Spree::Review.ransack(params[:q])
    @collection = @search.result.includes([:product, :user, :feedback_reviews]).page(params[:page]).per(params[:per_page])
  end
end
