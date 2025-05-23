class Spree::ProductQuestion < ActiveRecord::Base
  belongs_to :product
  belongs_to :user, optional: true

  has_one :product_answer, dependent: :destroy
  accepts_nested_attributes_for :product_answer, allow_destroy: true, reject_if: :all_blank

  default_scope -> { order('spree_product_questions.created_at DESC') }
  scope :visible, -> { where(is_visible: true) }
  scope :answered, -> { joins(:product_answer) }
  scope :not_answered, -> { left_outer_joins(:product_answer).where(spree_product_answers: { id: nil }) }
  scope :user_product_questions, ->(user_id) { where('spree_product_questions.user_id = ?', user_id) }

  validates :content, presence: true

  def answer_for_form
    self.product_answer.present? ? self.product_answer : self.build_product_answer
  end

  def self.for_user(user = nil)
    if user
      left_outer_joins(:product_answer).where('spree_product_questions.user_id = :user_id OR spree_product_answers.id IS NOT NULL AND spree_product_questions.is_visible = true', user_id: user.id)
    else
      answered.visible
    end
  end

  def self.filter_questions(questions, params)
    if params[:filter] == 'answered'
      questions.answered
    elsif params[:filter] == 'not_answered'
      questions.not_answered
    else
      questions
    end
  end

  def self.vendor_product_questions(id)
    joins(:product).where(spree_products: { vendor_id: id })
  end

  def can_be_deleted?
    true
  end
end
