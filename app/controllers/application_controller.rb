class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery({:with => :exception})

  before_action :login_required

  private
    def can_current_user?(action, object)
      # action == :view, :destroy, :edit
      # object == @list
      # current_user == #<User>

      # The first thing I want to do is delegate to a model.
      # current_user.can?(:view, @list)
      # current_user.can?(:view, @item)

      object.send("#{action}able_by?", current_user) #=> Dynamic Dispatch 


      # Users shouldn't be monoliths - God Objects

      # who has the answer to this question?
      # somehow from our controller, with only access to the user and the object
      # we must end up on a shared_list
    end


    def login(user)
      session[:user_id] = user.id # Logging them in as a user.
    end

    def login_required
      if !logged_in?
        redirect_to login_path, :notice => "Please login first!"
      end
    end

    def logged_in?
      !!current_user
    end
    helper_method :logged_in?

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    end
    helper_method :current_user
end
