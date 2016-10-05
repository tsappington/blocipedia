class WikiPolicy < ApplicationPolicy

  def update?
    user.standard? || user.premium? || user.admin?
  end

end
