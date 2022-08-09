class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable  

  enum status: [:pending, :active]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.role ||= :pending
  end
end
