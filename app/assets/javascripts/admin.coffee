# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

labels = (sizes) ->
  $("#shownLabel").html( sizes.shown )
  $("#uncheckedLabel").html( sizes.unchecked )

ready = ->
  $("#setting").on "ajax:success", ( e, data, status, xhr ) ->
    switch data.mode
      when true  then $( "#selectLink" ).addClass("hidden")
      when false then $( "#selectLink" ).removeClass("hidden")
      else
    labels(data.sizes)

  $("#mainTask").on "ajax:success", ( e, data, status, xhr ) ->
    labels(data.sizes)

  $(".toggleFeed").on "ajax:success", ( e, data, status, xhr ) ->
    switch data.use
      when true  then $( this ).find(".toggleText").toggleClass("hidden").parents( "tr" ).addClass("success").find( ".toggleBtn" ).val("false")
      when false then $( this ).find(".toggleText").toggleClass("hidden").parents( "tr" ).removeClass("success").find( ".toggleBtn" ).val("true")
      else
    labels(data.sizes)

  $("#entryTask").on "ajax:success", ( e, data, status, xhr ) ->
    $( "#entryTable" ).html( data.table )
    labels(data.sizes)

  $("#entryTable").on "ajax:success", ".checkEntry", ( e, data, status, xhr ) ->
    switch data.done
      when true  then $( this ).toggle().parents( "tr" ).addClass("success").find( ".showEntry" ).toggle()
      when false then $( this ).toggle().parents( "tr" ).addClass("danger").find( ".deleteEntry" ).toggle()
      else
    labels(data.sizes)

$(document).ready ready
$(document).on "page:load", ready # Turbolinks