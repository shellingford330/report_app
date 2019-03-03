module RepliesHelper

	# 渡されたリプライの書いた先生を返す
	def reply_teacher(reply)
		teacher_id = reply.writeable_id
		return Teacher.find(teacher_id)
	end

	# 渡されたリプライの書いた生徒を返す
	def reply_student(reply)
		student_id = reply.writeable_id
		return Student.find(student_id)
	end
end