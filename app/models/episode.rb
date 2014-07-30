class Episode < ActiveRecord::Base
	validate :title, presence: true
	validate :number, presence: true
	has_many :images, dependent: :destroy
end
