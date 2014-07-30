class EpisodesController < ApplicationController
	def index
		@episodes = Episode.all
	end
	def show
		@episode = Episode.find(params[:id])
		@images = @episode.images
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
	def new
		@episode = Episode.new()
	end
	def create
		Episode.update_all default: false
		@episode = Episode.find_by number: params['number']
		@episode ||= Episode.new(params.permit(:number,:titlex))
		@episode.title = params['title']
		@episode.default = true
		@episode.save()
		respond_to do |format|
			format.json { render json: @episode}
			format.html {render 'show'}
		end	
	end
	def defaultep
		#@episode = Episode.find_by number: "pszzz"
		@episode = Episode.find_by default: true
		respond_to do |format|
			format.json { render json: @episode}
		end	
	end
	def maj_chatroom
		@episode = Episode.find(params[:id])
		@episode.chatroom = params[:chatroom]
		@episode.save
	end
end
