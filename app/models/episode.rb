class Episode < ActiveRecord::Base
	validates :title, presence: true
	validates :number, presence: true
	has_many :images, ->   { where(queued: false) }, dependent: :destroy
	has_many :images_queued, ->   { where(queued: true).order(queueposition: :asc)  }, dependent: :destroy, class_name: "Image"
end