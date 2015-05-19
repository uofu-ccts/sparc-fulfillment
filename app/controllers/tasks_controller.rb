class TasksController < ApplicationController

  before_action :find_task, only: [:show, :update, :task_reschedule]

  respond_to :json, :html

  def index
    respond_to do |format|
      format.html { render }
      format.json do
        if params[:show_tasks]
          toggle_all_tasks(params)
        else
          toggle_completed_tasks(params)
        end

        render
      end
    end
  end

  def show
    @partial = ["show", @task.assignable_type.downcase, "task"].join("_")
  end

  def new
    @task = Task.new()
  end

  def create
    task_parameters = task_params.to_h.except("notes")
    if task_params[:notes]
      task_parameters[:body] = task_params[:notes][:comment]
    end
    @task = Task.new(task_parameters.merge!({ identity: current_identity}))
    if @task.valid?
      @task.save
      @procedure = Procedure.find(task_params[:assignable_id]) unless task_params[:assignable_type] != "Procedure"
      if task_params[:notes]
        create_note(task_parameters)
      end
      flash[:success] = t(:flash_messages)[:task][:created]
    else
      @errors = @task.errors
    end
  end

  def update
    if @task.update_attributes(task_params)
      flash[:success] = t(:flash_messages)[:task][:updated]
    end
  end

  def task_reschedule
  end

  private

  def create_note(task_parameters)
    unless task_parameters[:body].empty?
      notes_params = task_params[:notes]
      notes_params[:identity] = current_identity
      Note.create(notes_params)
    end
  end


  def to_boolean string
    if string == 'true'
      return true
    elsif string == 'false'
      return false
    end
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.
      require(:task).
      permit(:complete, :body, :due_at, :assignee_id, :assignable_type, :assignable_id, notes: [:kind, :comment, :notable_type, :notable_id])
  end

  def toggle_all_tasks params
    show_tasks = to_boolean(params[:show_tasks])
    @tasks = Task.my_tasks(current_user, show_tasks)
  end

  def toggle_completed_tasks params
    show_complete = to_boolean(params[:complete])
    @tasks = Task.my_completed_tasks(current_user, show_complete)
  end
end
