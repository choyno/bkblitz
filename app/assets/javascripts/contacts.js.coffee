# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#new_contact").validate
    rules:
      "contact[email]":
        required: true
        email: true

      "contact[body]":
        required: true
