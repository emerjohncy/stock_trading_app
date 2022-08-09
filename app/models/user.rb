class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable  

  enum status: [:pending, :active]
  after_initialize :set_default, :if => :new_record?

  def set_default
    self.status ||= :pending
    self.balance ||= 10000.00
  end

end
