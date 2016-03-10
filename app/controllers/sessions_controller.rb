class SessionsController < ApplicationController
  skip_before_action :login_required, :only => [:new, :create]

  def new
  end

  def create   
    if params[:email].present? && params[:password].present?
      user = User.find_by(:email => params[:email])
      if user && user.authenticate(params[:password])
        login(user)
        redirect_to root_path
      else
        flash.now[:notice] = "Could not find that person, sorry!"
        render :new
      end
    elsif request.env['omniauth.auth'].present?
      # is this the first time I've seen you?
      user = User.login_from_omniauth(request.env['omniauth.auth'])
      login(user)
      redirect_to root_path
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out!"
    render :new
  end

end
