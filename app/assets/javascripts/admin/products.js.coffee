# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#product_form").validate
    rules:
      "product[name]":
        required: true

      "product[retail_price]":
        required: true

      "product[wholesale_price]":
        required: true

      "product[description]":
        required: true

      "product[supplier_id]":
        required: true
