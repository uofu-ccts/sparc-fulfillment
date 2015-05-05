class Fulfillment < ActiveRecord::Base

  has_paper_trail
  acts_as_paranoid

  belongs_to :line_item

  has_one :component, as: :composable
  has_many :notes, as: :notable
  has_many :documents, as: :documentable

  delegate :quantity_type, to: :line_item

  validates :line_item_id, :fulfilled_at, :quantity, :performed_by, presence: true
  validates_numericality_of :quantity
end
