# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#para que la barra de navegacion quede fija en la parte superior de la pantala
$(document).ready ->
  $window = $(window)
  offset = $("#pnav-bar").offset() 
  topPadding = 30
  $window.scroll ->
    if $window.scrollTop() > offset.top + 25
      $("#pnav-bar").stop().animate
        marginTop: $window.scrollTop() - offset.top - topPadding
      , 0
    else
      $("#pnav-bar").stop().animate
        marginTop: 0
      , 0
    return

  return


#para cambiar las imagenes
$(document).ready ->
  $("#slide_controls").on "mouseenter", "li", ->
    $("#slider-frame img").removeClass "opaque"
    newImage = $(this).index()
    $("#slider-frame img").eq(newImage).addClass "opaque"
    $("#slider_controls li").removeClass "selected"
    $(this).addClass "selected"
    return

  return