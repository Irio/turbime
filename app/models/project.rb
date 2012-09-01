class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :about, :code_funded, :description, :expires_at, :goal, :name, :repository, :video, :visible

  # Validates
  validates :name, :headline, :description, :goal, :video, :presence => true
  validates :repository, :video, format: {with: URI::regexp(%w[http https]), allow_nil: true, allow_blank: true}

  # Scopes
  scope :visible, where(visible: true)
  scope :expired, where("expires_at < current_timestamp")
end
