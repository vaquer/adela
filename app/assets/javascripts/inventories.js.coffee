$ ->
  $("#js_inventory_form").hide()
  $("#js_inventory").on("click", show_inventory_form)

show_inventory_form = () ->
  $("#js_inventory_form").slideToggle(200)
  false