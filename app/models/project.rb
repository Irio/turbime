class Project < ActiveRecord::Base
  belongs_to :user
  has_many :supports
  attr_accessible :headline, :code_funded, :description, :expires_at, :goal, :name, :repository, :video, :visible, :user_id

  # Validates
  validates :name, :headline, :description, :goal, :video, :user, :presence => true
  validates :repository, :video, format: {with: URI::regexp(%w[http https]), allow_nil: true, allow_blank: true}
  before_create :store_image_url

  validates_each :expires_at do |record, attr, value|
    record.errors.add(attr,
      I18n.t("activerecord.errors.models.project.attributes.expires_at")
    ) if value && value < 1.week.from_now
  end

  validates_length_of :headline, :maximum => 140

  has_vimeo_video :video, :message => I18n.t('activerecord.errors.models.project.attributes.vimeo_regex_validation')

  # Scopes
  scope :visible, where(visible: true).order("created_at DESC")
  scope :expired, where("expires_at < current_timestamp").order("expires_at DESC")
  scope :active, lambda { visible - expired }

  auto_html_for :description do
    html_escape
    image
    youtube :width => 460, :height => 262
    vimeo :width => 460, :height => 262
    redcarpet
    link :target => "_blank"
  end

  def cannot_edit?(attr)
    (attr.to_sym != :code_funded) && persisted?
  end

  def visible?
    visible
  end

  def amount_reached
    supports.confirmed.sum(&:amount)
  end

  def active?
    visible? and not expired?
  end

  def expired?
    expires_at < Time.now
  end

  def successful?
    amount_reached >= goal
  end

  def days_left
    days = (expires_at.to_date - Date.today).to_i
    days > 0 ? days : 0
  end

  def percent
    ((amount_reached / goal * 100).abs).round.to_i
  end

  def progress
    return 100 if percent > 100
    percent
  end

  protected
  def store_image_url
    self.image = vimeo.thumbnail unless self.image
  end
end
