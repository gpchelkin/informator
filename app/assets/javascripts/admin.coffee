# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

labels = (sizes) ->
  $("#shownLabel").text(sizes.shown)
  $("#uncheckedLabel").text(sizes.unchecked)
  $("#noticeLabel").text(sizes.notice)

btn = 'button[data-disable-with]'           # To prevent buttons from resizing with Wait-text
frm = 'form[data-remote]:has(' + btn + ')'  # http://stackoverflow.com/questions/20813607/

ready = ->

  $(frm).on 'ajax:before', ->
    $(@).find(btn).each ->
      input = $(@)
      input.css('width', input.css('width'))

  $(frm).on 'ajax:complete', ->
    $(@).find(btn).each ->
      $(@).css('width', '')

  $("#setting").on "ajax:success", (e, data, status, xhr) ->
    switch data.mode
      when true  then $("#selectLink").addClass("hidden")
      when false then $("#selectLink").removeClass("hidden")
      else
    labels(data.sizes)

  $("#mainTask").on "ajax:success", (e, data, status, xhr) ->
    labels(data.sizes)

  $("#feedTable").on "ajax:success", ".toggleFeed", (e, data, status, xhr) ->
    switch data.use
      when true  then $(this).find(".toggleBtn").val("false").toggleClass('success warning')
      when false then $(this).find(".toggleBtn").val("true").toggleClass('success warning')
      else
    $(this).find(".toggleText").toggleClass("hide")
    labels(data.sizes)

  $("#entryTask").on "ajax:success", (e, data, status, xhr) ->
    $("#entryTable").html(data.table)
    labels(data.sizes)

  $("#entryTable").on "ajax:success", ".checkEntry", (e, data, status, xhr) ->
    switch data.done
      when true  then $(this).toggle().parents("td").find(".showEntry").toggleClass("hide")
      when false then $(this).toggle().parents("td").find(".deleteEntry").toggleClass("hide")
      else
    labels(data.sizes)

  $("#noticeReload").on "ajax:success", (e, data, status, xhr) ->
    $("#noticeTable").html(data.table)
    labels(data.sizes)

  $("#noticeTable").on "ajax:success", ".toggleNotice", (e, data, status, xhr) ->
    switch data.checked
      when true  then $(this).find(".toggleBtn").val("false").toggleClass('success warning')
      when false then $(this).find(".toggleBtn").val("true").toggleClass('success warning')
      else
    $(this).find(".toggleText").toggleClass("hide")
    labels(data.sizes)

$(document).ready ready
$(document).on "page:load", ready # Turbolinks