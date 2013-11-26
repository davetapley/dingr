$ ->
  $('.part').click (e) ->
    regex = /.*note-(\d+).*/
    match = regex.exec(this.className)
    note = match[1]

    other_notes = $('.note').filter ->
      !$(this).hasClass('note-' + note)
    other_notes.css('background-color', 'white')

    other_parts = $('.part').filter ->
      !$(this).hasClass('note-' + note)
    other_parts.css('display', 'none')
