# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

backgroundColorFromHue= (o) ->
  o.closest("td").css('backgroundColor', "hsl(" + o.text() + ",100%,50%)")

$( document ).ready ->
  $('span[data-object="player"][data-attribute="hue"]').each ->
    backgroundColorFromHue $(this)

  $(".best_in_place").bind "ajax:success", ->
    backgroundColorFromHue $(this)
