module FileValidation
	###################################################
	########### Include：お知らせ・お問い合わせ ###########
	###################################################

	private
		def file_invalid?
			if self.upfile.size > 5.megabyte
				errors.add(:base, 'ファイルサイズは5MBサイズまでです')
			end
		end
end