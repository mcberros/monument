class CategoriesController < ApplicationController

  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.where(user_id: current_user.id)
  end

  def show
    check_forbidden
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      redirect_to categories_path, notice: 'Category created'
    else
      render :new
    end
  end

  def edit
    check_forbidden
  end

  def update
    check_forbidden

    if @category.update category_params
      redirect_to categories_path, notice: 'Category updated'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy

    redirect_to categories_path, notice: 'Monument Category deleted'
  end

  private

  def check_forbidden
    if @category.user != current_user
      render status: 403, text: 'Forbidden category'
    end
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name).merge({user_id: current_user.id})
  end
end