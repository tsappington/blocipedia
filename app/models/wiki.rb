class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators
  has_many :collab_users, through: :collaborators, source: :user
  # scope :visible_to, -> (user) { user.premium? || user.admin? ? all : where(private: false) }
end
