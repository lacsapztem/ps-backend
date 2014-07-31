class Image < ActiveRecord::Base
	validate :name, presence: true
	validate :author, presence: true
	validate :image, presence: true
	validates_uniqueness_of :name, scope: :episode_id
	belongs_to :episodes
end
