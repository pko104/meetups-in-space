class Meetup < ActiveRecord::Base
  has_many :rsvps
  has_many :users, through: :rsvps
  has_many :posts, through: :rsvps

  validates :title,
    presence: true

  validates :location,
    presence: true

  validates :topic,
    presence: true

end
