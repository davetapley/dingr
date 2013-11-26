# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->
  MIDI.loadPlugin
    soundfontUrl: "../assets/soundfont/"
    instrument: ["acoustic_grand_piano"]

  $('.play-tune').click (e) ->
    e.preventDefault()
    notes = $(this).data('notes')

    $.each notes, (i, n) ->
      if n != 'r'
        MIDI.noteOn 0, n, 127, i
