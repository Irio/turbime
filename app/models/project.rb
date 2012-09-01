class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :about, :code_funded, :description, :expires_at, :headline, :goal, :name, :repository, :video, :visible

  # Validates
  validates :name, :headline, :description, :goal, :video, :presence => true
  validates :repository, :video, format: {with: URI::regexp(%w[http https]), allow_nil: true, allow_blank: true}
  validates_each :expires_at do |record, attr, value|
    record.errors.add(attr,
      I18n.t(".activerecord.errors.models.project.attributes.expires_at")
    ) if value && value < 1.week.from_now
  end

  # Scopes
  scope :visible, where(visible: true)
  scope :expired, where("expires_at < current_timestamp")

  auto_html_for :description do
    html_escape
    image
    youtube :width => 400, :height => 250
    vimeo :width => 400, :height => 250
    redcarpet
    link :target => "_blank"
    simple_format
  end

  def can_edit?(attr)
    attr == :code_funded || !persisted?
  end
end
