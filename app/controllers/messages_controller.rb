class MessagesController < ApplicationController
  protect_from_forgery except: :create

  before_action :teacher_logged_in

  def index
    @rooms = current_teacher.sent_messages.group(:from_id, :to_id)
    .or(current_teacher.recieved_messages.group(:from_id, :to_id))
    .reorder(created_at: :desc)
    @receiver_ids = []
    @teacher = Teacher.new
    @teachers = Teacher.all
  end

  def show
    @messages = Message.where(from_id: current_teacher.id, to_id: params[:id])
    .or(Message.where(from_id: params[:id], to_id: current_teacher.id)).last(100)
    @message = Message.new
    @to_teacher = Teacher.find(params[:id])
  end

  def new
    redirect_to "/messages/#{params[:teacher][:id]}"
  end

  def create
    to_id = params[:to_id].to_i
    current_teacher.sent_messages.create(content: params[:content], to_id: to_id)
    redirect_to message_url(to_id)
  end

end
