module MonumentMultiStep
  extend ActiveSupport::Concern

  def multistep_control(form_to_render, notice_msg)
    if params[:cancel_button]
      clear_session
      redirect_to monuments_path
      return
    end

    images = is_there_picture_params? ? move_images_from_params_to_array : []

    merge_session_with_monument_params if is_there_monument_params?

    yield

    store_in_session_uploaded_images_path(images)
    populate_model_pictures_with_files_in_session

    is_saved = perform_step_action

    unless is_saved
      render form_to_render
    else
      clear_session
      redirect_to monuments_path, notice: notice_msg
    end
  end

  def perform_step_action
    is_saved = false

    @monument.current_step = session[:monument_step]

    if @monument.valid?
      if params[:next_button]
        @monument.next_step
      elsif params[:previous_button]
        @monument.previous_step
      elsif params[:save_button]
        is_saved = @monument.save
      end

      session[:monument_step] = @monument.current_step
    end

    is_saved
  end

  def init_session
    session[:monument_params] ||= {}
    session["monument_files"] ||= {}
  end

  def clear_session
    session[:monument_step] = session[:monument_params] = session["monument_files"] = nil
  end

  def move_images_from_params_to_array
    # TODO: We need to test if the picture has image
    #TODO: pero no incluir las imagenes de momumentos con params[:monument][:pictures_attributes]._destroy es 1
    params[:monument]["pictures_attributes"]
        .map{|k,picture| picture.delete("image")}
  end

  def merge_session_with_monument_params
    #TODO: borrar de session[:monument_params] y de session[:monument_files] pictures con _destroy igual 1
    session[:monument_params].deep_merge!(monument_params)
  end

  def populate_model_pictures_with_files_in_session
    if is_there_files_in_session?
      @monument.pictures.each_with_index do |picture_model, i|
        unless session["monument_files"][i.to_s].nil?
          File.open(session["monument_files"][i.to_s]) do |f|
            picture_model.image = f
          end
        end
      end
    end
  end

  def store_in_session_uploaded_images_path(images_param)
    if is_there_files_in_session?
      @monument.pictures.each_with_index do |picture_model, i|
        img = images_param[i]
        unless img.nil?
          picture_model.image = img
          session["monument_files"][i.to_s] = picture_model.image.file.file
        end
      end
    end
  end

  def is_there_files_in_session?
    !session["monument_files"].nil?
  end

  def is_there_monument_params?
    !params[:monument].nil?
  end

  def is_there_picture_params?
    is_there_monument_params? && !params[:monument]["pictures_attributes"].nil?
  end

end
