class Support < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :amount, :payment_method, :payment_token, :translaction_id
  validates :user, :project, :payment_method, :payment_token, presence: true
  attr_protected :confirmed
end
