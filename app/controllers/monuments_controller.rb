class MonumentsController < ApplicationController
  include MonumentMultiStep

  before_action :find_monument, only: [:show, :edit, :update, :destroy]

  def index
    @monuments = Monument.by_user(current_user.id)
  end

  def show
    check_forbidden
  end

  def stream
    if params[:search]
      @monuments = Monument.search_by(params[:search][:criteria])
    else
      @monuments = Monument.publish.with_approved_pictures
    end
  end

  def new
    if MonumentCollection.count == 0
      redirect_to new_monument_collection_path, notice: "Please, create first a monument collection"
    else
      init_session
      @monument = Monument.new(session[:monument_params])
      @monument.current_step = session[:monument_step]
    end
  end

  def create
    multistep_control(:new, 'Monument created') do
      @monument = Monument.new session[:monument_params]
    end
  end

  def edit
    check_forbidden

    init_session
    @monument.attributes = session[:monument_params]
    @monument.current_step = session[:monument_step]
  end

  def update
    check_forbidden

    multistep_control(:edit, 'Monument updated') do
      @monument.attributes = session[:monument_params]
    end
  end

  def destroy
    check_forbidden

    @monument.destroy

    redirect_to monuments_path, notice: 'Monument deleted'
  end

  private

  def check_forbidden
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end
  end

  def find_monument
    @monument = Monument.find(params[:id])
  end

  def monument_params
    params.require(:monument).permit(:name, :description, :monument_collection_id, :category_id, :public, :previous_button,
                                     pictures_attributes: [ :id, :name, :description, :date, :_destroy, :image, :image_cache ])
  end
end