class Image < ActiveRecord::Base
	validates :name, presence: true
	validates :author, presence: true
	validates :url, presence: true
	validates_uniqueness_of :name, scope: :episode_id
	validates_uniqueness_of :sign, scope: :episode_id
	belongs_to :episodes
end
