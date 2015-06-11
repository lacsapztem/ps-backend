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
	def post_queue
		@image = Image.find params[:id]
		@image[:queueposition]=0
		@image[:queued]=false
		@image.save
		render json: @image
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
			retour = wp.uploadFile data: parameters
			logger.info retour
			@image = Image.new	name: params[:name],
							msg: params[:msg],
							url: retour["url"],
							author: params[:author],
							user: params[:user],
							avatar: params[:avatar],
							sign: signature,
							content_type: params[:content_type],
							episode_id: params[:id_episode],
							media_type: 'img',
							queued: false
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
							media_type: 'video',
							queued: false
		end
		@video.save()
		respond_to do |format|
			format.json { render json: @video}
		end
	end
	def upload_queued
		require 'digest/md5'
		Rails.logger = Logger.new(STDOUT)
		auth= {
			host: ENV["WP_HOST"],
			username: ENV["WP_USER"], 
			password: ENV["WP_PW"]
		}
		content_type=params[:image][:image].content_type
		@episode = Episode.find params[:id]
		if content_type!='image/jpeg' && content_type!='image/gif' && content_type!='image/png'
			logger.info "type de fichier invalide"+content_type
			flash[:danger] = "Mauvais format d'image"
		else
			logger.info 'type de fichier ok'+content_type
			#logger.info params[:image].image.original_filename
			wp = Rubypress::Client.new	auth

			parameters = {
				name: @episode[:number] + '_' + params[:image][:image].original_filename,
				type: params[:image][:image].content_type,
				bits:XMLRPC::Base64.new(params[:image][:image].tempfile.read )
			}	
			signature = Digest::MD5.hexdigest(parameters[:bits].decoded)
			@image = Image.find_by sign: signature, episode_id: params[:id]
			# @image ||= Image.find_by name: params[:name]
			if !@image
				retour = wp.uploadFile data: parameters
				logger.info "Retour de WP"
				logger.info retour
				@image = Image.new	name: parameters[:name],
								msg: params[:image][:msg],
								url: retour["url"],
								author: 'Podcast Science',
								user: 'Podcast Science',
								avatar: 'https://gravatar.com/avatar/07423298245b638efa9f24edfd0e9f6a?s=40',
								sign: signature,
								content_type:  params[:image][:image].content_type,
								episode_id: params[:id],
								media_type: 'img',
								queueposition: @episode.images_queued.maximum('queueposition'),
								queued: true
			else
				logger.info "Image deja existante"

			end

			@image.save()
		end
		
		@images = @episode.images_queued
		uri=URI("#{ENV['PSLIVE_URL']}update_queue")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('queue'=> @images.to_json)
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		redirect_to @episode
		
	end
end