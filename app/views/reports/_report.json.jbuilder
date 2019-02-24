json.extract! report, :id, :start_date, :end_date, :subject, :content, :homework, :comment, :status, :read_flg, :memo, :student_id, :teacher_id, :created_at, :updated_at
json.url report_url(report, format: :json)
