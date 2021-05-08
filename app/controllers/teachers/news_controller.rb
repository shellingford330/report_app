# frozen_string_literal: true

module Teachers
  class NewsController < Teachers::BaseController
    def index
      @news = News.preload(:replies).paginate(page: params[:page], per_page: 16)
    end

    def show
      @news = News.find(params[:id])
      @students = @news.students
    end
  end
end
