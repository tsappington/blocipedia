class WikisController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new
    @wiki.assign_attributes(wiki_params)
    @wiki.user_id = current_user.id

    if @wiki.save
      flash[:notice] = "Wiki was saved successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    @collab_users = @wiki.collab_users.all

    users_all = User.all
    users_available = []
    users_all.each do |user|
      if current_user.id != user.id && !@collab_users.include?(user)
        users_available << user
      end
    end
    @collaborators = users_available

  end


  def collab_add
    @wiki = Wiki.find(params[:wiki_id])
    user = User.find(params[:user_id])

    @wiki.collaborators.create(user: user)
    flash[:notice] = "Collaborator Added"
    redirect_to edit_wiki_path(@wiki)
  end


  def collab_remove
    @wiki = Wiki.find(params[:wiki_id])
    user = User.find(params[:user_id])
    collaborator = @wiki.collaborators.where(user_id: user)

    if @wiki.collaborators.destroy(id = collaborator)
      flash[:notice] = "Collaborator Removed"
    else
      flash.now[:alert] = "There was an error removing that collaborator. Please try again."
    end
    redirect_to edit_wiki_path(@wiki)
  end


  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    authorize @wiki
    if @wiki.save
      flash[:notice] = "Wiki was updated successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end

  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end


end
