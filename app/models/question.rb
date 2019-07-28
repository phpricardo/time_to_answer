class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  # pagination with kaminari
  paginates_per 5

  def self.search(term, page)
    Question.includes(:answers)
            .where("lower(description) LIKE ?", "%#{term.downcase}%")
            .page(page)
  end

  def self.last_questions(page)
    Question.includes(:answers).order('created_at desc').page(params[:page])
  end
end
