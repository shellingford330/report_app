# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ajax:success', '#new_student', (xhr, data, status) ->
	location.reload()

$(document).on 'ajax:error', '#new_student', (xhr, data, status) ->
	form = $('#new_student .modal-body')
	frame = $('<div id="error_explanation"></div>')
	ul = $('<ul></ul>')
	count = 0
	data.responseJSON.messages.forEach (message, i) ->
		count += 1
		li = $('<li class="text-danger"></li>').text(message)
		ul.append(li)

	if $('#error_explanation')[0]
		$('#error_explanation').html(ul)
	else
		frame.append(ul)
		form.prepend(frame)
	