class ImagesController < ApplicationController
	def show
	end
	def new
		@image = Image.new()
	end
	def destroy
		@image = Image.find params[:id]
		@episode = Episode.find @image['episode_id']
		@image.destroy
		redirect_to @episode
	end
	def create
	end
	def upload_api
		require 'digest/md5'
		Rails.logger = Logger.new(STDOUT)
		auth= {
			host: ENV["WP_HOST"],
			username: ENV["WP_USER"], 
			password: ENV["WP_PW"]
		}

		wp = Rubypress::Client.new	auth

		@episode = Episode.find params[:id_episode]
		parameters = {
			name: @episode[:number] + '_' + params[:name],
			type: params[:content_type],
			bits: XMLRPC::Base64.new(Base64.decode64(params[:image]))
		}
		signature = Digest::MD5.hexdigest(params[:image])
		@image = Image.find_by sign: signature, episode_id: params[:id_episode]
		# @image ||= Image.find_by name: params[:name]
		if !@image
			logger.info "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
			begin
				retour = wp.uploadFile data: parameters
			end
			logger.info "********************************************************************"
			logger.info retour
			logger.info "---------------------------------------------------------------------"
			@image = Image.new	name: params[:name],
							msg: params[:msg],
							url: retour["url"],
							author: params[:author],
							user: params[:user],
							avatar: params[:avatar],
							sign: signature,
							content_type: params[:content_type],
							episode_id: params[:id_episode],
							media_type: 'img'
		end
		@image.save()

		respond_to do |format|
			format.json { render json: @image}
		end
	end
	def add_video
		@episode = Episode.find params[:id_episode]
		@video = Image.find_by url: params['url'], episode_id: params[:id_episode]
		if !@video
			@video = Image.new	name: params[:name],
							msg: params[:msg],
							url: params[:url],
							author: params[:author],
							user: params[:user],
							avatar: params[:avatar],
							sign: params[:url],
							content_type: '',
							episode_id: params[:id_episode],
							media_type: 'video'
		end
		@video.save()
		respond_to do |format|
			format.json { render json: @video}
		end
	end
end