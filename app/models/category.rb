class Category < ApplicationRecord
  # when category is destroyed, remove category_id from existing discussions so they dont get deleted
  has_many :discussions, dependent: :nullify

  scope :sorted, -> { order(:name) }
end
