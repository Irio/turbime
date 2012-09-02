class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :name, :email, :password, :image_url,
    :password_confirmation, :remember_me, :github, :twitter, :facebook, :site
  has_many :authorizations, dependent: :destroy
  has_many :projects
  has_many :supports

  validates :name, presence: true
  validates :github, :twitter, :facebook, :site, format: { with: URI::regexp(%w(http https)) }, allow_nil: true, allow_blank: true

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session[:omniauth] && session[:omniauth]["info"]
        user.email = data["email"] if data["email"].present?
        user.name = data["name"]
        user.image = data["image"]
        user.authorizations.build(provider: session[:omniauth]['provider'], uid: session[:omniauth]['uid'])
      end
    end
  end

  def avatar_url
    return image if image
    "http://gravatar.com/avatar/#{Digest::MD5.new.update(email)}.jpg?s=50"
  end
end
