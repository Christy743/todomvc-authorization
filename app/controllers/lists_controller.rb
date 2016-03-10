class ListsController < ApplicationController
  # skip_before_action :login_required, :only => [:index]

  def show
    @list = List.find(params[:id])
    if !can_current_user?(:view, @list) # the answer should be no.
      redirect_to root_path, :notice => "Can't find that..."
    end
  end

  def index
    @lists = current_user.lists
    @list = List.new
  end

  def new
    @list = List.new
    @list.items.build
  end

  def create
    @list = List.new(list_params)

    if @list.save
      redirect_to @list
    else
      render :new
    end
  end

  def edit
    @list = List.find(params[:id])
    if !can_current_user?(:edit, @list) # the answer should be no.
      redirect_to root_path, :notice => "Can't find that..."
    end

  end

  private
    def list_params
      params.require(:list).permit(:name, :items_attributes => [:description, :priority])
    end
end
