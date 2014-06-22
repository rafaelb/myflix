class CategoriesController < ApplicationController


  def index

  end

  def show
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end