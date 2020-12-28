class UrlsController < ApplicationController
  
  def create
    url = Url.find_or_create_by(create_url_params)
    shortened_url = UrlShortener.call(url.id)
    render json: { shortened_url: shortened_url }
  end

  def show
    url_id = UrlUnshortener.call(unshortened_url_params)
    url = Url.where(id: url_id).first
    if url
      render json: { url: url.url }
    else
      head :not_found
    end
  end

  private

  def create_url_params
    params.permit(:url)
  end

  def unshortened_url_params
    params.require(:shortened)
  end
end
