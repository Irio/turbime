class Support < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :amount, :payment_method, :payment_token, :translaction_id, :terms
  validates :user, :project, :amount, :payment_token, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 5.00 }
  validates :terms, acceptance: {:accept => "1"}, allow_nil: false
  attr_protected :confirmed
  before_validation :create_payment_token, only: [:create]

  # Scopes
  scope :confirmed, where(confirmed: true)

  def confirm!
    self.update_column :confirmed, true
  end

  protected
  def create_payment_token
    self.payment_token = Digest::MD5.hexdigest "#{SecureRandom.hex(5)}-#{DateTime.now.to_s}"
  end
end
