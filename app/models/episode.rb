class Episode < ActiveRecord::Base
	validate :title, presence: true
	validate :number, presence: true
	has_many :images, ->   { where(queued: false) }, dependent: :destroy
	has_many :images_queued, ->   { where(queued: true).order(queueposition: :asc)  }, dependent: :destroy, class_name: "Image"
end