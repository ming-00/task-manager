class TasksController < ApplicationController
before_action :correct_user

  def index
    @user = User.find(params[:user_id])
    @tasks = @user.tasks.order(created_at: :desc)
    if !params[:q].blank?
      @tags = Tag.where(tag_name: params[:q])
      if @tags.empty?
        flash[:warning] = "There are no tags with name " + params[:q] + ".";
      else
        @task_ids = []
        @tags.each do |tag|
          @task_ids.push(tag.task_id)
        end
        @tasks = @user.tasks.where(id: @task_ids).order(created_at: :desc)
      end
    end
    @ongoing_tasks = @tasks.where(completed: false)
    @completed_tasks = @tasks.where(completed: true)
  end

  def show
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @task = @user.tasks.build
  end

  def edit
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    @tags = @task.tags
    if @tags.empty?
      @task.tags.build(task_id: @task.id)
    end
  end

  def create
    @user = User.find(params[:user_id])
    @task = @user.tasks.new(task_params)
    #if params[:task][:tags]
    #  params[:task][:tags].each do |tag|
    #    @task.tags.build(task_id: @task.id, tag_name: tag[:tag_name],
    #                    _destroy: tag[:_destroy])
    #  end
    #end
    if helpers.has_duplicate_tag_names?
      render 'new'
    elsif @task.save
      flash[:success] = "Task added!"
      redirect_to user_tasks_url
    else
      render 'new'
    end
  end

  def complete
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    @task.update(completed: true)
    flash[:success] = "Task completed!"
    redirect_to user_tasks_url
  end

  def uncomplete
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    @task.update(completed: false)
    flash[:success] = "Add the task back to the ongoing tasks"
    redirect_to user_tasks_url
  end

  def update
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    #if params[:task][:tags]
    #  params[:task][:tags].each do |tag|
    #    @task.tags.build(task_id: @task.id, tag_name: tag[:tag_name],
    #                    _destroy: tag[:_destroy])
    #  end
    #end
    if helpers.has_duplicate_tag_names?
      render 'edit'
    elsif @task.update(task_params)
      flash[:success] = "Task updated!"
      redirect_to user_tasks_url
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
    @task.destroy
    flash[:success] = "Task deleted!"
    redirect_to user_tasks_url
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline,
        tags_attributes: [:id, :tag_name, :_destroy])
    end

    # Confirms a logged_in user_
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
