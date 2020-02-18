class FsjsCapital < ApplicationRecord
  validates :yyyy,  presence: true, uniqueness: true
  validates :yyyy, numericality: { greater_than_or_equal_to: 1989, less_than_or_equal_to: 2099 } , unless: Proc.new { |a| a.yyyy.blank? }
  validates :m1,    presence: true, length: { maximum: 10 }
  validates :m1,    numericality: { greater_than_or_equal_to: 0 } , unless: Proc.new { |a| a.m1.blank? }     
  validates :m2,    presence: true, length: { maximum: 10 }
  validates :m2,    numericality: { greater_than_or_equal_to: 0 } , unless: Proc.new { |a| a.m2.blank? }   
  validates :m3,    presence: true, length: { maximum: 10 }
  validates :m3,    numericality: { greater_than_or_equal_to: 0 } , unless: Proc.new { |a| a.m3.blank? }   
  validates :m4,    presence: true, length: { maximum: 10 }
  validates :m4,    numericality: { greater_than_or_equal_to: 0 } , unless: Proc.new { |a| a.m4.blank? }   
end
