class User < ApplicationRecord
  enum role: [:trader, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :trader
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
        #  :recoverable, :rememberable, 

  has_many :transactions
end