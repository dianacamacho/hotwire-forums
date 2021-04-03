class Category < ApplicationRecord
  # when category is destroyed, remove category_id from existing discussions so they dont get deleted
  has_many :discussions, dependent: :nullify

  scope :sorted, -> { order(:name) }

  after_create_commit -> { broadcast_prepend_to "categories" }
  after_update_commit -> { broadcast_replace_to "categories" }
  after_destroy_commit -> { broadcast_remove_to "categories" }
end
