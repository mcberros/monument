class MonumentCollectionsController < ApplicationController

  before_action :find_monument_collection, only: [:show, :edit, :update, :destroy]

  def index
    @monument_collections = MonumentCollection.all
  end

  def show
  end

  def new
    @monument_collection = MonumentCollection.new
  end

  def create
    @monument_collection = MonumentCollection.new monument_collection_params
    if @monument_collection.save
      redirect_to monument_collections_path, notice: 'Collection created'
    else
      render :new
    end
  end

  def edit
  end

  def update

    if @monument_collection.update monument_collection_params
      redirect_to monument_collections_path, notice: 'Collection updated'
    else
      render :edit
    end
  end

  def destroy

    if @monument_collection.has_monuments?
      notice = 'Please delete the monuments before deleting the monument collection.'
    else
      @monument_collection.destroy
      notice = 'Monument collection deleted'
    end

    redirect_to monument_collections_path, notice: notice
  end

  private

  def find_monument_collection
    @monument_collection = MonumentCollection.find(params[:id])
  end

  def monument_collection_params
    params.require(:monument_collection).permit(:name)
  end
end