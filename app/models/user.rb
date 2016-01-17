class User < ActiveRecord::Base
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  before_save :format_username_and_email
  before_validation :generate_slug

  validates :name, presence: true

  validates :email, presence: true,
  										format: /\A\S+@\S+\z/,
  										uniqueness: { case_sensitive: false }

	validates :username, presence: true,
												format: /\A[A-Z0-9]+\z/i,
                     		uniqueness: { case_sensitive: false }						

	validates :password, length: { minimum: 6, allow_blank: true }
				
	def gravatar_id
		Digest::MD5::hexdigest(email.downcase)
	end

	def self.authenticate(email_or_username, password)
		user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
		user && user.authenticate(password)
	end

	def format_username_and_email
		self.username = username.downcase
		self.email = email.downcase
	end

	def to_param
		slug
	end

	def generate_slug
		self.slug ||= username.parameterize if username
	end

end
