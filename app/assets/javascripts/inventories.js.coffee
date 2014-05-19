$ ->

validate_requirements = () ->
  checked_requirements = $("input.requirement:checked")
  if checked_requirements.length == $("input.requirement").length
    $("input#publish[type=submit]").removeClass("disabled")
  else
    $("input#publish[type=submit]").addClass("disabled")