# frozen_string_literal: true

class SearchReportsForm
  include ActiveModel::Model

  attr_accessor :status, :teacher_ids

  validates :status, presence: true, inclusion: { in: %w[all released draft] }
end
