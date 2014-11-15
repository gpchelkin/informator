# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  slider = $(".bxslider").bxSlider mode: 'vertical', speed: 2500, pager: false, controls: false, minSlides: 2, maxSlides: 2, moveSlides: 1
  if $('.bxslider').length
    evtSource = new EventSource('/display/show')
    evtSource.addEventListener 'entry', (e) ->
      obj = $.parseJSON(e.data)

      currentSlide = slider.getCurrentSlide()
      newSlide = (currentSlide + 2) % 3
      $("li.n" + newSlide + " .title").html( obj.title )
      $("li.n" + newSlide + " .published").text( obj.published )
      $("li.n" + newSlide + " .feed").text( obj.feed )
      $("li.n" + newSlide + " .summary").html( obj.summary )
#      if (obj.image) then $("#n1 > .image").attr( "src", obj.image ).show() else $("#n1 > .image").hide()
      $("li.n" + newSlide + " .qrcode").empty().qrcode render:"image", text: obj.url, size: 200

      slider.reloadSlider mode: 'vertical', speed: 2500, pager: false, controls: false, minSlides: 2, maxSlides: 2, moveSlides: 1, startSlide: currentSlide
      slider.goToNextSlide()

    evtSource.addEventListener 'background', (e) ->
      obj = $.parseJSON(e.data)
      $( "body" ).css("background-image", "url("+obj.url+")")


