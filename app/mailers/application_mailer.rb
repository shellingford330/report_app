# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: '"自由塾" <jiyujyuku@okurun.jp>'
  layout 'mailer'
end
