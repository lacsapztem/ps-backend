class Image < ActiveRecord::Base
	validate :name, presence: true
	validate :author, presence: true
	validate :image, presence: true
	belongs_to :episodes
end
