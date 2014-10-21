# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $(".toggleFeed").on "ajax:success", ( e, data, status, xhr ) ->
    switch data.done
      when "enable"  then $( this ).find( ".toggleBtn" ).val("disable")
      when "disable" then $( this ).find( ".toggleBtn" ).val("enable")
      else
    $( this ).parents( "tr" ).toggleClass("success")
    $( this ).parents( "tr" ).toggleClass("warning")
    $( this ).find(".toggleText").toggle()

  $("#jobToolbar").on "ajax:success", ( e, data, status, xhr ) ->
    $( "#entryTable" ).html( data )

  $("#entryTable").on "ajax:success", ".checkEntry", ( e, data, status, xhr ) ->
    switch data.done
      when "show"   then  $( this ).parents( "tr" ).addClass("success")
      when "delete" then  $( this ).parents( "tr" ).addClass("danger")
      else
    $( this ).parents( "td" ).find( "."+data.done+"Entry" ).toggle()
    $( this ).toggle()

$(document).ready ready
$(document).on 'page:load', ready