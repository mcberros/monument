class PicturesController < ApplicationController

  def index
    render status: 403, text: 'Forbidden' unless current_user.admin

    @pictures = Picture.joins(:monument)
                .where('monuments.public = ?', true)
                .where(approved: false)
  end

  def approve
    picture = Picture.find(params[:id])
    if picture.update(approved: true)
      redirect_to pictures_path, notice: 'Picture approved'
    else
      render :index
    end
  end
end
