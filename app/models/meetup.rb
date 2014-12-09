class Meetup < ActiveRecord::Base
  has_many :rsvps

  validates :title,
    presence: true

  validates :location,
    presence: true

  validates :topic,
    presence: true

end
