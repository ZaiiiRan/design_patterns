class Lab < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :topics, length: { maximum: 1000 }, allow_blank: true
  validates :tasks, length: { maximum: 10_000 }, allow_blank: true
  validates :date_of_issue, presence: true
end
