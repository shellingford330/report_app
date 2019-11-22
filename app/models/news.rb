class News < ApplicationRecord
	attr_accessor :upfile

	has_and_belongs_to_many :students
	belongs_to :teacher
	has_many :replies, as: :replyable
	
	default_scope { order(created_at: :desc) }

	enum status: { draft: 0, released: 1, deleted: 2 }

	validates :title,
		presence: true,
		length: { maximum: 32 }
	validates :content, presence: true
	validates :status,
		presence: true,
		inclusion: { in: [ "draft", "released", "deleted" ], allow_nil: true }
	validates :teacher_id, presence: true
	validate :file_invalid?

	private
		def file_invalid?
			if ( file = self.upfile )
				name = file.original_filename
				perms = ['.jpg', '.jpeg', '.gif', '.png', '.xlsx', '.pdf', '.pptx', '.docx']
				if !perms.include?(File.extname(name).downcase)
					errors.add(:base, 'アップロード可能な種類のファイルではありません')
				elsif file.size > 1.megabyte
					errors.add(:base, 'ファイルサイズは1MBサイズまでです')
				end
			end
		end
end
