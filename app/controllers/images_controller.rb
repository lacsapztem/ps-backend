class ImagesController < ApplicationController
	def show
  		require 'base64'
		@image_data = Image.find params[:id]
		@image = Base64.decode64(@image_data.image)
		send_data @image, 	type: @image_data.content_type,
							filename: @image_data.name, 
							disposition: 'inline'
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
  		require 'base64'
  		img64 = Base64.encode64(params['image']['image'].read())
		@image = Image.new	name: params['name'],
							msg: params['msg'],
							author: params['author'],
							image: img64,
							content_type: params['image']['image'].content_type
		@image.save()
	end
	def upload_api
		@image = Image.new	name: params[:name],
							msg: params[:msg],
							author: params[:author],
							user: params[:user],
							avatar: params[:avatar],
							image: params[:image],
							content_type: params[:content_type],
							episode_id: params[:id_episode]
		@image.save()
		respond_to do |format|
			format.json { render json: @image}
		end
	end
end