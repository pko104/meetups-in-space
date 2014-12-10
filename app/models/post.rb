class Post < ActiveRecord::Base
  belongs_to :rsvp
  has_many :users, through: :rsvp
  has_many :meetups, through: :rsvp
end
