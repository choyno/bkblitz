class Contact < ActiveRecord::Base
  attr_accessible :body, :email, :name, :subject

  validates :email, :body, presence: true 
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }


end
