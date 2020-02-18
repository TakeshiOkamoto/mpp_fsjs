class FsjsAccount < ApplicationRecord

  validates :name, length: { maximum: 20 }, presence: true, uniqueness: true
  validates :types,        presence: true
  validates :sort_list,    presence: true, length: { maximum: 5 }
  validates :sort_expense, presence: true, length: { maximum: 5 }
  
  validates :types,  numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 3 } , unless: Proc.new { |a| a.types.blank? } 
  
end
