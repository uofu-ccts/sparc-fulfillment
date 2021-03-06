class Arm < ActiveRecord::Base

  has_paper_trail
  acts_as_paranoid

  belongs_to :protocol

  has_many :line_items, dependent: :destroy
  has_many :visit_groups, dependent: :destroy
  has_many :appointments
  has_many :participants

  validates :name, presence: true
  validates_numericality_of :subject_count, greater_than_or_equal_to: 1
  validates_numericality_of :visit_count, greater_than_or_equal_to: 1
end
