class Support < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :amount, :payment_method, :payment_token, :translaction_id
  validates :user, :project, :amount, :payment_token, presence: true
  attr_protected :confirmed
  before_validation :create_payment_token, only: [:create]

  def confirm!
    self.update_column :confirmed, true
  end

  protected
  def create_payment_token
    self.payment_token = Digest::MD5.hexdigest "#{SecureRandom.hex(5)}-#{DateTime.now.to_s}"
  end
end
