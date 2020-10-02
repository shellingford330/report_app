# frozen_string_literal: true

module Teachers
	class BaseController < ApplicationController
		before_action :teacher_logged_in
	end
end