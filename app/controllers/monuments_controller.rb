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
      session[:monument_params] ||= {}
      @monument = Monument.new(session[:monument_params])
      @monument.current_step = session[:monument_step]
    end
  end

  def create
    is_finished = false
    session[:monument_params].deep_merge!(monument_params) unless params[:monument].nil?
    @monument = Monument.new session[:monument_params]

    @monument.current_step = session[:monument_step]
    if @monument.valid?
      if params[:previous_button]
        @monument.previous_step
      elsif @monument.last_step?
        is_finished = @monument.save
      else
        @monument.next_step
      end
      session[:monument_step] = @monument.current_step
    end

    unless is_finished
      render :new
    else
      session[:monument_step] = session[:monument_params] = nil
      redirect_to monuments_path, notice: 'Monument created'
    end
  end

  def edit
    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end

    session[:monument_params] ||= {}
    @monument.attributes = session[:monument_params]
    @monument.current_step = session[:monument_step]
  end

  def update
    is_finished = false

    session[:monument_params].deep_merge!(monument_params) unless params[:monument].nil?

    @monument.attributes = session[:monument_params]

    if @monument.monument_collection.user != current_user
      render status: 403, text: 'Forbidden monument'
    end

    @monument.current_step = session[:monument_step]
    if @monument.valid?
      if params[:previous_button]
        @monument.previous_step
      elsif @monument.last_step?
        is_finished = @monument.save
      else
        @monument.next_step
      end
      session[:monument_step] = @monument.current_step
    end

    unless is_finished
      render :edit
    else
      session[:monument_step] = session[:monument_params] = nil
      redirect_to monuments_path, notice: 'Monument updated'
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
    params.require(:monument).permit(:name, :description, :monument_collection_id, :category_id, :public, :previous_button, pictures_attributes: [ :id, :name, :description, :date, :_destroy ])
  end
end