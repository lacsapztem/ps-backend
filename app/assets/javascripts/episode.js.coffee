# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$( ()->
	$( "#sortable" ).sortable
		placeholder: "thumbnail col-sm-4 col-md-3 "
		stop: (event,ui)->
			sortedIDs = $( "#sortable" ).sortable("toArray")
			$.post $(location).attr('pathname')+'/queue', {order: sortedIDs},	success: (data)->
					alert data
	$( "#sortable" ).disableSelection()

	Dropzone.options.FileUploadZone = {
	  paramName: "image[image]",
	  maxFilesize: 2,
	  acceptedFiles: 'image/jpeg,image/gif,image/png',
	  dictDefaultMessage: 'Click or Drop files here to upload',
	  accept: (file, done) ->
	  	done()
	}




	$('#UploadModal').on 'hide.bs.modal',  (e) ->
		location.reload true
)