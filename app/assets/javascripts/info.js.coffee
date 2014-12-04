# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#routes").on "change", ->
    index = $(this).val()
    $(".routes-display").css "display", "none"
    $(".routes-display").eq(index).css "display", "block"
    $(".achievements-list").css "display", "none"
    $(".achievements-list").eq(index).css "display", "block"
    $(".objectives").css "display", "none"
    $(".objectives").eq(index).css "display", "block"
    return

  $(".objectives").on "change", ->
    $("#achievements-int img").removeClass "opaque"
    newImage = $(this).val()
    $("#achievements-int img").eq(newImage).addClass "opaque"
    $("#int-controls li").removeClass "selected"
    $("#int-controls li").eq(newImage).addClass "selected"
    return

  $(".objectives").on "change", ->
    newImage = $(this).val()
    if newImage < 7
        $("#achievements-std img").removeClass "opaque"
        $("#achievements-std img").eq(newImage).addClass "opaque"
        $("#std-controls li").removeClass "selected"
        $("#std-controls li").eq(newImage).addClass "selected"
    return

  $(".objectives").on "change", ->
    newImage = $(this).val()
    if newImage < 6 
        $("#achievements-exp img").removeClass "opaque"
        $("#achievements-exp img").eq(newImage).addClass "opaque"
        $("#exp-controls li").removeClass "selected"
        $("#exp-controls li").eq(newImage).addClass "selected"
    return

  return