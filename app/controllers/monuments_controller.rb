class MonumentsController < ApplicationController

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
      session[:monument_params] ||= {}
      session["monument_files"] ||= {}
      @monument = Monument.new(session[:monument_params])
      @monument.current_step = session[:monument_step]
    end
  end

  def create
    if params[:cancel_button]
      session[:monument_step] = session[:monument_params] = session["monument_files"] = nil
      redirect_to monuments_path
      return
    end

    is_finished = false

    images = is_there_picture_params? ? move_images_from_params_to_array : []

    merge_session_with_monument_params

    @monument = Monument.new session[:monument_params]

    unless session["monument_files"].nil?
      @monument.pictures.each_with_index do |picture_model, i|
        img = images[i]
        if img.nil?
          File.open(session["monument_files"][i.to_s]) do |f|
            picture_model.image = f
          end unless session["monument_files"][i.to_s].nil?
        else
          picture_model.image = img
          session["monument_files"][i.to_s] = picture_model.image.file.file
        end
      end
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
      render :new
    else
      session[:monument_step] = session[:monument_params] = session["monument_files"] = nil
      redirect_to monuments_path, notice: 'Monument created'
    end
  end

  def edit
    check_forbidden

    session[:monument_params] ||= {}
    session["monument_files"] ||= {}
    @monument.attributes = session[:monument_params]
    @monument.current_step = session[:monument_step]
  end

  def update
    check_forbidden

    if params[:cancel_button]
      session[:monument_step] = session[:monument_params] = session["monument_files"] = nil
      redirect_to monuments_path
      return
    end

    is_finished = false

    images = is_there_picture_params? ? move_images_from_params_to_array : []

    session[:monument_params].deep_merge!(monument_params) unless params[:monument].nil?

    @monument.attributes = session[:monument_params]

    unless session["monument_files"].nil?
      @monument.pictures.each_with_index do |picture_model, i|
        img = images[i]
        if img.nil?
          File.open(session["monument_files"][i.to_s]) do |f|
            picture_model.image = f
          end unless session["monument_files"][i.to_s].nil?
        else
          picture_model.image = img
          session["monument_files"][i.to_s] = picture_model.image.file.file
        end
      end
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
      session[:monument_step] = session[:monument_params] = session["monument_files"] = nil
      redirect_to monuments_path, notice: 'Monument updated'
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

  def move_images_from_params_to_array
    params[:monument]["pictures_attributes"]
        .map{|k,picture| picture.delete("image")}
  end

  def merge_session_with_monument_params
    session[:monument_params].deep_merge!(monument_params) if is_there_monument_params?
  end

  def is_there_monument_params?
    !params[:monument].nil?
  end

  def is_there_picture_params?
    is_there_monument_params? && !params[:monument]["pictures_attributes"].nil?
  end

  def monument_params
    params.require(:monument).permit(:name, :description, :monument_collection_id, :category_id, :public, :previous_button,
                                     pictures_attributes: [ :id, :name, :description, :date, :_destroy, :image, :image_cache ])
  end
end