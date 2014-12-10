class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  has_many :posts
  validates_uniqueness_of :meetup_id
end
