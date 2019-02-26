module ReportsHelper

	# 渡された報告書が公開されている場合true, されていない場合flaseを返す
	def released?(report)
		report.status == "released"
	end

	# 渡された報告書が非公開の場合true, されていない場合flaseを返す
	def draft?(report)
		report.status == "draft"
	end
end
