class MonumentsController < ApplicationController

  before_action :find_monument, only: [:show, :edit, :update, :destroy]

  def index
    @monuments = Monument.joins(:monument_collection).where('monument_collections.user_id = ?', current_user.id)
  end

  def show
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end
  end

  def new
    if MonumentCollection.count == 0
      redirect_to new_monument_collection_path, notice: "Please, create first a monument collection"
    else
      @monument = Monument.new
    end
  end

  def create
    @monument = Monument.new monument_params
    if @monument.save
      redirect_to monuments_path, notice: 'Monument created'
    else
      render :new
    end
  end

  def edit
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end
  end

  def update
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end

    if @monument.update monument_params
      redirect_to monuments_path, notice: 'Monument updated'
    else
      render :edit
    end
  end

  def destroy
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end

    @monument.destroy

    redirect_to monuments_path, notice: 'Monument deleted'
  end

  private

  def find_monument
    @monument = Monument.find(params[:id])
  end

  def monument_params
    params.require(:monument).permit(:name, :description, :monument_collection_id, :category_id, :public)
  end
end