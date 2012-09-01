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
  has_vimeo_video :video, :message => I18n.t('activerecord.errors.models.project.attributes.vimeo_regex_validation')

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


  def cannot_edit?(attr)
    (attr.to_sym != :code_funded) && persisted?
  end
  protected
  def store_image_url
    self.image = vimeo.thumbnail unless self.image
  end
end
