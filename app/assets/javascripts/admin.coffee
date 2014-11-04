# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

labels = (sizes) ->
  $("#shownLabel").text(sizes.shown)
  $("#uncheckedLabel").text(sizes.unchecked)
  $("#noticeLabel").text(sizes.notice)

ready = ->
  $("#setting").on "ajax:success", (e, data, status, xhr) ->
    switch data.mode
      when true  then $("#selectLink").addClass("hidden")
      when false then $("#selectLink").removeClass("hidden")
      else
    labels(data.sizes)

  $("#mainTask").on "ajax:success", (e, data, status, xhr) ->
#    if data.table then $( "#feedTable" ).html( data.table )
    labels(data.sizes)

  $("#feedTable").on "ajax:success", ".toggleFeed", (e, data, status, xhr) ->
    switch data.use
      when true  then $(this).find(".toggleText").toggleClass("hidden").parents("tr").addClass("success").find(".toggleBtn").val("false")
      when false then $(this).find(".toggleText").toggleClass("hidden").parents("tr").removeClass("success").find(".toggleBtn").val("true")
      else
    labels(data.sizes)

  $("#entryTask").on "ajax:success", (e, data, status, xhr) ->
    $("#entryTable").html(data.table)
    labels(data.sizes)

  $("#entryTable").on "ajax:success", ".checkEntry", (e, data, status, xhr) ->
    switch data.done
      when true  then $(this).toggle().parents("tr").addClass("success").find(".showEntry").toggle()
      when false then $(this).toggle().parents("tr").addClass("danger").find(".deleteEntry").toggle()
      else
    labels(data.sizes)

  $("#noticeReload").on "ajax:success", (e, data, status, xhr) ->
    $("#noticeTable").html(data.table)
    labels(data.sizes)

  $("#noticeTable").on "ajax:success", ".toggleNotice", (e, data, status, xhr) ->
    switch data.checked
      when true  then $(this).find(".toggleText").toggleClass("hidden").parents("tr").addClass("success").find(".toggleBtn").val("false")
      when false then $(this).find(".toggleText").toggleClass("hidden").parents("tr").removeClass("success").find(".toggleBtn").val("true")
      else
    labels(data.sizes)

$(document).ready ready
$(document).on "page:load", ready # Turbolinks