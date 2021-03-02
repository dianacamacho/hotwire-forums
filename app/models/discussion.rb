class Discussion < ApplicationRecord
  # default lambda will use the Current module we created to auto set the
  # currently logged in user as the user on create rather than
  # having to pass in that value separately
  belongs_to :user, default: -> { Current.user }

  validates :name, presence: true
end