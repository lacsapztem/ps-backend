class ImagesController < ApplicationController
	def show
	end
	def new
		@image = Image.new()
	end
	def destroy
		@image = Image.find params[:id]
		@episode = Episode.find @image['episode_id']

		logger.info "suppression d'une image"
		uri=URI("#{ENV['PSLIVE_URL']}suppr_image")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('image'=> @image.to_json)
		begin
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  http.request(req)
			end
		rescue
			logger.info "La chatroom est offline"
		end
		
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
		logger.info "+++++++++++++++++++++++++++++%%%%%%%%%%%+++++++++++++++++++++++++++++++++++++++"
		Rails.logger = Logger.new(STDOUT)
		auth= {
			host: ENV["WP_HOST"],
			username: ENV["WP_USER"], 
			password: ENV["WP_PW"],
			use_ssl: true
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
			password: ENV["WP_PW"],
			use_ssl: true
		}
		content_type=params[:file].content_type
		@episode = Episode.find params[:id]
		if content_type!='image/jpeg' && content_type!='image/gif' && content_type!='image/png'
			logger.info "type de fichier invalide"+content_type
			render json: {error: "Mauvais format d'image"}, status: 415
		else
			logger.info 'type de fichier ok'+content_type
			#logger.info params[:image].image.original_filename
			wp = Rubypress::Client.new	auth

			parameters = {
				name: @episode[:number] + '_' + params[:file].original_filename,
				type: params[:file].content_type,
				bits:XMLRPC::Base64.new(params[:file].tempfile.read )
			}	
			signature = Digest::MD5.hexdigest(parameters[:bits].decoded)
			@image = Image.find_by sign: signature, episode_id: params[:id]
			# @image ||= Image.find_by name: params[:name]
			if !@image
				logger.info "Upload  vers WP"
				logger.info auth
				logger.info "Upload  vers WP mais en vrai"
				retour = wp.uploadFile data: parameters
				logger.info "Retour de WP"
				logger.info retour
				@image = Image.new	name: parameters[:name],
								msg: params[:msg] || '',
								url: retour["url"],
								author: 'Podcast Science',
								user: 'Podcast Science',
								avatar: 'https://gravatar.com/avatar/07423298245b638efa9f24edfd0e9f6a?s=40',
								sign: signature,
								content_type:  params[:file].content_type,
								episode_id: params[:id],
								media_type: 'img',
								queueposition: ( @episode.images_queued.maximum('queueposition') || 0 )+1,
								queued: true
				logger.info @image
				render json: {error: 'Upload ok'}
			else
				logger.info "Image deja existante"
				render json: {error: 'Image deja existante'}, status: 415

			end

			@image.save()
		end
		
		@images = @episode.images_queued
		uri=URI("#{ENV['PSLIVE_URL']}update_queue")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('queue'=> @images.to_json)
		begin
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  http.request(req)
			end
		rescue
			logger.info "La chatroom est offline"
		end
		
	end
end