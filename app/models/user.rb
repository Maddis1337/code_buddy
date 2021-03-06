class User < ActiveRecord::Base
  # Include default deviseOLD modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username,
            :uniqueness => {
                :case_sensitive => false
            },
            :length => {:minimum => 3, :maximum => 16},
            :allow_blank => false,
            :format => { with: /\A[a-zA-Z0-9]+\Z/ } # no whitespaces, no special characters

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  # override authentication conditions to accept username or email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
