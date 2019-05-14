class GroupsController < ApplicationController
  before_action :teacher_logged_in
  before_action :admin_logged_in, only: [:new, :create, :destroy]
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all.order(created_at: :asc)
  end

  # GET /groups/1
  def show
    @students = @group.students
  end

  # GET /groups/new
  def new
    @group = Group.new
		@students_id = []
  end

  # POST /groups
  def create
    @group = Group.new(params.require(:group).permit(:name))
    @students_id = params[:students_id] ? params[:students_id] : []
    @group.students = Student.where(id: @students_id)
    if @group.save
      flash[:success] = "グループを作成しました"
      redirect_to @group
    else
      flash[:danger] = '入力情報をご確認下さい'
      render :new
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url
    flash[:success] = 'グループが削除されました' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    
end
