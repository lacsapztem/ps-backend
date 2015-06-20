class EpisodesController < ApplicationController
	def index
		@episodes = Episode.all.order(number: :desc)
	end
	def show
		@episode = Episode.find(params[:id])
		@images = @episode.images
		@images_queued = @episode.images_queued
		@image_new = Image.new()
		@image_new.episode_id = params[:id]
		@image_new.queued = true
		respond_to do |format|
			format.json { render json: @episode}
			format.html
		end
	end
	def images
		@episode = Episode.find(params[:id])
		@images = @episode.images
		respond_to do |format|
			format.json { render json: @images}
		end
	end
	def diaporama
		@episode = Episode.find(params[:id])
		@images = @episode.images
	end
	def new
		@episode = Episode.new()
	end
	def create
		Episode.update_all default: false
		@episode = Episode.find_by number: params['number']
		@episode ||= Episode.new(params.permit(:number,:titlex))
		@episode.title = params['title']
		@episode.hashtag = params['hashtag']
		@episode.default = true
		@episode.save()
		respond_to do |format|
			format.json { render json: @episode}
			format.html {redirect_to @episode}
		end	
	end
	def defaultep
		#@episode = Episode.find_by number: "pszzz"
		@episode = Episode.find_by default: true
		if !(@episode.nil?)
			@episode.hashtag ||= @episode.number 
		end
		respond_to do |format|
			format.json { render json: @episode}
			format.html {redirect_to @episode}
		end	
	end
	def maj_chatroom
		@episode = Episode.find(params[:id])
		@episode.chatroom = params[:chatroom]
		@episode.save
	end
	def set_queue_order
		order=0
		tab_order=params[:order]
		tab_order.each do |im_id|
			im_sign=im_id.split('_')[1]
			@image = Image.find_by sign: im_sign, episode_id: params[:id]
			@image[:queueposition]=order
			order=order+1
			@image.save
		end		
		@episode = Episode.find(params[:id])
		@images = @episode.images_queued
		uri=URI("#{ENV['PSLIVE_URL']}update_queue")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('queue'=> @images.to_json)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		render json: {}
	end
	def get_queue_order
		@episode = Episode.find(params[:id])
		@images = @episode.images_queued
		render json: @images
	end
	def post_queue
		@image = Image.find_by sign:  params[:sign], episode_id: params[:id]
		@image[:queueposition]=0
		@image[:queued]=false
		@image.save
		respond_to do |format|
			format.html { 
				@episode = Episode.find(params[:id])
				redirect_to @episode
			}
			format.json {render json: @image}
		end	
		callback_uri=URI("#{ENV['PSLIVE_URL']}post_image")
		req = Net::HTTP::Post.new(callback_uri)
		req.set_form_data('image'=> @image.to_json)
		res = Net::HTTP.start(callback_uri.hostname, callback_uri.port) do |http|
		  http.request(req)
		end

	end
end
