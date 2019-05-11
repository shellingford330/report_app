module ContactsHelper

	# 未読確認

	# 生徒側が講師からの返信を確認していればtrue, していなければfalseを返す
	def student_checked?(contact)
		contact.replies.where(writeable_type: "Teacher", read_flg: false).exists?
	end

	# 講師側が生徒からのお問い合わせや返信を確認していればtrue, していなければfalseを返す
	def	teacher_checked?(contact)
		!contact.read_flg || contact.replies.where(writeable_type: "Student", read_flg: false).exists?
	end

	
	#返信有無確認

	# 講師から返信があるか確認
	def	reply_exists?(contact)
		contact.replies.where(writeable_type: "Teacher").exists?
	end


end
