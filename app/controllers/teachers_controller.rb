class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  def index
    @teachers = Teacher.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.new(teacher_params)
    if @teacher.save
      format.html { redirect_to @teacher, notice: 'Teacher was successfully created.' }
      format.json { render :show, status: :created, location: @teacher }
    else
      format.html { render :new }
      format.json { render json: @teacher.errors, status: :unprocessable_entity }
    end
  end

  
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: 'Teacher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:name, :email, :status, :password, :password_confirmation)
    end
end
