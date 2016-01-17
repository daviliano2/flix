class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :critics, through: :reviews, source: :user
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  before_validation :generate_slug

  validates :title, presence: true, uniqueness: true

  validates :slug, uniqueness: true
  
  validates :released_on, :duration, presence: true
  
  validates :description, length: { minimum: 25 }
  
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  
  validates :image_file_name, allow_blank: true, format: {
    with:    /\w+.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }
  
  RATINGS = %w(G PG PG-13 R NC-17)

  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where("released_on <= ?", Time.now).order(released_on: :desc) }
  # WITH LAMBDA WE ARE CREATING A CALLABLE OBJECT (A PROC OBJECT) THAT WILL WORK AS
  # THE self.released CLASS METHOD.
  
  scope :hits, lambda { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  # WE CAN CHAIN A SCOPE INSIDE OF A LAMBDA WITH ANOTHER QUERY

  scope :flops, -> { released.where('total_gross < 50000000').order(total_gross: :asc) }
  # LAMBDA CAN BE ALSO WRITTEN WITH THE "->" SYMBOL

  scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }
  scope :rated, ->(rating) { released.where(rating: rating) }
  # LAMBDA CALLS CAN ACCEPT PARAMETERS AS WELL

  scope :recent, ->(max=5) { released.limit(max) }

  # def self.released
  #   where("released_on <= ?", Time.now).order(released_on: :desc)
  # end
  
  # def self.hits
  #   where('total_gross >= 300000000').order(total_gross: :desc)
  # end
  
  # def self.flops
  #   where('total_gross < 50000000').order(total_gross: :asc)
  # end
  
  def flop?
    total_gross.blank? || total_gross < 50000000
  end
  
  def average_stars
    reviews.average(:stars)
  end

  def to_param
    # OVERRIDE THE to_param METHOD (INHERIT FROM ACTIVERECORD::BASE) AND RETURN THE NEW SLUG PARAMETER
    slug
  end

  def generate_slug
    self.slug ||= title.parameterize if title
  end

end
