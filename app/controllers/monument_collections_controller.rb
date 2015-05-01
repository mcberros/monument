class MonumentCollectionsController < ApplicationController

  def index
    @monument_collections = MonumentCollection.all
  end

  def show
    @monument_collection = MonumentCollection.where(id: params[:id])
  end

  def new
    @monument_collection = MonumentCollection.new
  end

  def create
    @monument_collection = MonumentCollection.new monument_collection_params
    if @monument_collection.save
      redirect_to @monument_collection, notice: 'Collection created'
    else
      render :new
    end
  end

  def edit
    @monument_collection = MonumentCollection.where(id: params[:id])
  end

  def update
    @monument_collection = MonumentCollection.update monument_collection_params
    if @monument_collection.save
      redirect_to @monument_collection, notice: 'Collection updated'
    else
      render :edit
    end
  end

  def destroy
  end

  private
  def monument_collection_params
    params.require(:monument_collection).permit(:name)
  end
end