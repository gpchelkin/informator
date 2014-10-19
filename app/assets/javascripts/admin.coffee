# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $(".toggleFeed")
  .on "click", ( e ) ->
    $( this ).data('clicked', $( e.target ).val() )

  .on "ajax:before", ( e ) ->
    $( this ).find( "." + $( this ).data('clicked')+"Btn" ).toggle()
    $( this ).data "clicked", if $( this ).data("clicked")=="disable" then "enable" else "disable"

  .on "ajax:success", ( e, data, status, xhr ) ->
    $( this ).find( "." + $( this ).data('clicked')+"Btn" ).toggle()


  $("#jobToolbar")
  .on "click", ( e ) ->
    $( this ).data('clicked', $( e.target ).val() )

  .on "ajax:before", ( e ) ->
    $( this ).find( "." + $( this ).data('clicked') ).toggle()

  .on "ajax:success", ( e, data, status, xhr ) ->
    $( "#entryTable" ).html( data )
    $( this ).find( "." + $( this ).data('clicked') ).toggle()


  $("#entryTable")
  .on "ajax:success", ".checkEntry", ( e, data, status, xhr ) ->
    $( this ).parents( "tr" ).addClass( if data.show then "success" else "danger" )
    $( this ).parents( "td" ).find( "."+data.commit+"Entry" ).toggle()
    $( this ).remove()

  $("#setting")
  .on "click", ( e ) ->
    $( this ).data('clicked', $( e.target ).val() )

  .on "ajax:before", ( e ) ->
    $( this ).find( "." + $( this ).data('clicked')+"Btn" ).toggle()
    $( this ).data "clicked", if $( this ).data("clicked")=="auto" then "manual" else "auto"

  .on "ajax:success", ( e, data, status, xhr ) ->
    $( this ).find( "." + $( this ).data('clicked')+"Btn" ).toggle()

$(document).ready ready
$(document).on 'page:load', ready