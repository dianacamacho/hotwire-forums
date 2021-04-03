class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]

  def index
    @discussions = Discussion.order(updated_at: :desc)
  end

  def show
    @new_post = @discussion.posts.new
    @posts = @discussion.posts.order(:created_at)
  end

  def new
    @discussion = Discussion.new
    @discussion.posts.new
  end

  def create
    @discussion = Discussion.new(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: "Discussion created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        @discussion.broadcast_replace(partial: "discussions/header", locals: { discussion: @discussion})

        if @discussion.saved_change_to_category_id?
          old_category_id, new_category_id = @discussion.saved_change_to_category_id
          old_category = Category.find(old_category_id)
          new_category = Category.find(new_category_id)
        end

        # remove discussion from old category discussion list / insert into new category list
        @discussion.broadcast_remove_to(old_category)
        @discussion.broadcast_prepend_to(new_category)

        # update categories by replacing them with latest
        # this updates the category discussion counters in the sidebar
        old_category.reload.broadcast_replace_to("categories")
        new_category.reload.broadcast_replace_to("categories")

        format.html { redirect_to @discussion, notice: "Discussion updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion.destroy!
    redirect_to discussions_path, notice: "Discussion removed"
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def discussion_params
    params.require(:discussion).permit(:name, :category_id, :pinned, :closed, posts_attributes: :body)
  end
end
