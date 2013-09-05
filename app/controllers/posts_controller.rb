class PostsController < ApplicationController
  before_action :set_post, except: [:new, :create, :index]
  before_action :require_login, except: [:show, :index, :callback]
  before_action :require_post_ownership, only: [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:callback]

  def show
    impressionist(@post)
    @images = @post.images
    @profile = ProfilePresenter.new(@post.user)
  end

  def index
    @posts = Post.active.order("cached_votes_score DESC")
  end

  def new
    @post = Post.new
  end

  def upvote
    @post.liked_by current_user
    redirect_to :back, notice: "upvote :)"
  end

  def downvote
    @post.downvote_from current_user
    redirect_to :back, notice: "downvote :("
  end

  def callback
    @paypay = @post.build_paypal_callback(callback_params)
    @paypay.response = callback_params
    @paypay.save
    @paypay.trigger_status_change
    render nothing: true
  end

  def callback_params
    params.permit(
      :payment_date, :payment_type, :payment_status, :payer_status, :payer_id, :payer_email, :payment_fee, :payment_gross,
      :handling_amount, :shipping, :first_name, :last_name ,
      :address_name, :address_status, :address_street, :address_city, :address_state, :address_zip, :address_country_code, :address_country,
      :transaction_subject, :receiver_email, :receiver_id, :business, :protection_eligibility,
      :verify_sign, :ipn_track_id, :txn_id, :txn_type, :residence_country)
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      @post.liked_by current_user
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:brand, :title, :size_id, :price, :body, :status_enum)
  end
end
