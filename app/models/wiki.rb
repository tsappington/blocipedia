class Wiki < ActiveRecord::Base
  belongs_to :user
  scope :visible_to, -> (user) { user.premium? || user.admin? ? all : where(private: false) }
end
