class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  protect_from_forgery unless: -> { request.format.json? }

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end
end
