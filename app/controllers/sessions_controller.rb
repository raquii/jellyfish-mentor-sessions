class SessionsController < ApplicationController
  skip_before_action :require_authentication
  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
