class Support < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :amount, :confirmed, :payment_method, :payment_token, :translaction_id
  validates :user, :project, :payment_method, :payment_token, presence: true
end
