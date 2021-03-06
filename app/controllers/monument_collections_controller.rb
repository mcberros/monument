class MonumentCollectionsController < ApplicationController

  before_action :find_monument_collection, only: [:show, :edit, :update, :destroy]

  def index
    @monument_collections = MonumentCollection.where(user_id: current_user.id)
  end

  def show
    check_forbidden
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
    check_forbidden
  end

  def update
    check_forbidden

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

  def check_forbidden
    if @monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument category'
    end
  end

  def find_monument_collection
    @monument_collection = MonumentCollection.find(params[:id])
  end

  def monument_collection_params
    params.require(:monument_collection).permit(:name).merge({user_id: current_user.id})
  end
end