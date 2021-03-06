# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  if $('#slider').length
    $(".entry.hide").css( "height", screen.availHeight/2)
    $(".ph").css("height", screen.availHeight/2)
    slider = $("#slider").slick vertical: true, speed: 1500, accessibility: false, arrows: false, draggable: false, pauseOnHover: false, slidesToShow: 2, slidesToScroll: 1
    eventSource = new EventSource('/display/show')
    eventSource.addEventListener 'entry', (e) ->
      obj = $.parseJSON(e.data)
      $entry = $(".entry.hide").clone().removeClass("hide entry")
      $entry.find(".title").html(obj.title)
      $entry.find(".published").text(obj.published)
      $entry.find(".feed").html(obj.feed)
      $entry.find(".summary").html(obj.summary)
      $entry.find(".qrcode").qrcode render:"image", text: obj.url, size: 150, background: "#FFFFFF"
      if obj.image
        $entry.find(".image").append("<img src=" + obj.image + "></img>")
      slider.slick 'slickRemove', true
      slider.slick 'slickAdd', $entry
      slider.slick 'slickNext'

    eventSource.addEventListener 'background', (e) ->
      obj = $.parseJSON(e.data)
      $( "body" ).css("background", obj.background)

    eventSource.addEventListener 'empty', (e) ->
      obj = $.parseJSON(e.data)
      obj.empty # TODO Some Stuff
