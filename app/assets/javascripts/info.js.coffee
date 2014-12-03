# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#routes").on "change", ->
    index = $(this).val()
    $(".routes-display").css "display", "none"
    $(".routes-display").eq(index).css "display", "block"
    $(".objectives").css "display", "none"
    $(".objectives").eq(index).css "display", "block"
    return

  $("#objectives_int").on "change", ->
    $("#achievements-int img").removeClass "opaque"
    newImage = $(this).val()
    $("#achievements-int img").eq(newImage).addClass "opaque"
    $("#int-controls li").removeClass "selected"
    $("#int-controls li").eq(newImage).addClass "selected"
    return

  $("#objectives_std").on "change", ->
    $("#achievements-std img").removeClass "opaque"
    newImage = $(this).val()
    $("#achievements-std img").eq(newImage).addClass "opaque"
    $("#std-controls li").removeClass "selected"
    $("#std-controls li").eq(newImage).addClass "selected"
    return

  $("#objectives_exp").on "change", ->
    $("#achievements-exp img").removeClass "opaque"
    newImage = $(this).val()
    $("#achievements-exp img").eq(newImage).addClass "opaque"
    $("#exp-controls li").removeClass "selected"
    $("#exp-controls li").eq(newImage).addClass "selected"
    return

  $("#int-controls").on "click", "li", ->
    $("#achievements-int img").removeClass "opaque"
    newImage = $(this).index()
    $("#achievements-int img").eq(newImage).addClass "opaque"
    $("#int-controls li").removeClass "selected"
    $(this).addClass "selected"
    return

  $("#std-controls").on "click", "li", ->
    $("#achievements-std img").removeClass "opaque"
    newImage = $(this).index()
    $("#achievements-std img").eq(newImage).addClass "opaque"
    $("#std-controls li").removeClass "selected"
    $(this).addClass "selected"
    return

  $("#exp-controls").on "click", "li", ->
    $("#achievements-exp img").removeClass "opaque"
    newImage = $(this).index()
    $("#achievements-exp img").eq(newImage).addClass "opaque"
    $("#exp-controls li").removeClass "selected"
    $(this).addClass "selected"
    return

  return