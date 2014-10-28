# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  if $('#info').length
    evtSource = new EventSource('/displayshow')
    evtSource.addEventListener 'new', (e) ->
      obj = $.parseJSON(e.data)
      $("#title").text( obj.title )
      $("#summary").text( obj.summary )
      $("#published").text( obj.published )