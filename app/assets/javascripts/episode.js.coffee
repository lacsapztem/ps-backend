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
)
