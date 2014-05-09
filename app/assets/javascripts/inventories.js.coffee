$ ->
  $("#js_inventory_form").hide()
  $("#js_inventory").on("click", show_inventory_form)

  $("form#requirements").on("change", "input.requirement", validate_requirements)

show_inventory_form = () ->
  $("#js_inventory_form").slideToggle(200)
  false

validate_requirements = () ->
  checked_requirements = $("input.requirement:checked")
  if checked_requirements.length == $("input.requirement").length
    $("input#publish[type=submit]").removeClass("disabled")
  else
    $("input#publish[type=submit]").addClass("disabled")