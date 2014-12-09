class Rsvp < ActiveRecord::Base
  has_many :users
  belongs_to :meetup
end
