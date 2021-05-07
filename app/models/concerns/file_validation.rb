# frozen_string_literal: true

module FileValidation
  ###################################################
  ########### Include：お知らせ・お問い合わせ ###########
  ###################################################

  private

  def file_invalid?
    errors.add(:base, 'ファイルサイズは5MBサイズまでです') if upfile.size > 5.megabyte
  end
end
