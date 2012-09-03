class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # TODO :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :name, :email, :password, :image_url,
    :password_confirmation, :remember_me, :github, :twitter, :facebook, :site, :bio
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
        data["image"] = data["image"].sub('_normal', '') if session[:omniauth]['provider'] == 'twitter'
        data["image"] = data["image"].sub('square', '') if session[:omniauth]['provider'] == 'facebook'
        user.image =  data["image"]
        user.authorizations.build(provider: session[:omniauth]['provider'], uid: session[:omniauth]['uid'])
      end
    end
  end

  def avatar_url
    return image if image
    "http://gravatar.com/avatar/#{Digest::MD5.new.update(email)}.jpg?s=200"
  end
end
