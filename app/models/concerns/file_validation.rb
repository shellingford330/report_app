module FileValidation
	###################################################
	########### Include：お知らせ・お問い合わせ ###########
	###################################################

	private
		def file_invalid?
			if ( file = self.upfile )
				name = file.original_filename
				perms = ['.jpg', '.jpeg', '.gif', '.png', '.xlsx', '.pdf', '.pptx', '.docx']
				if !perms.include?(File.extname(name).downcase)
					errors.add(:base, 'アップロード可能な種類のファイルではありません')
				elsif file.size > 5.megabyte
					errors.add(:base, 'ファイルサイズは5MBサイズまでです')
				end
			end
		end
end