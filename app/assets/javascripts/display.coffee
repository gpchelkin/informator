# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  if $('.info').length
    evtSource = new EventSource('/display/show')
    evtSource.addEventListener 'entry', (e) ->
      obj = $.parseJSON(e.data)
      $("#n2").html( $("#n1").html() )
      $("#n1 > .title").html( obj.title )
      $("#n1 > .summary").html( obj.summary )
      $("#n1 > .published").text( obj.published )
      if (obj.image) then $("#n1 > .image").attr( "src", obj.image ).show() else $("#n1 > .image").hide()
      $("#n1 > .feed").text( obj.feed )
      $("#n1 > .qrcode").empty().qrcode({"render":"image", "text": obj.url, "size": 200})