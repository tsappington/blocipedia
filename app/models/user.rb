class User < ActiveRecord::Base

  after_initialize :init

  has_many :wikis
  has_many :collaborators
  has_many :collab_wikis, through: :collaborators, source: :wiki

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :authentication_keys => [:login]

   def login=(login)
     @login = login
   end

   def login
     @login || self.username || self.email
   end

   def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def init
    self.role ||= 0
  end


  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  enum role: [:standard, :premium, :admin]

end
