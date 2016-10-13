$(function() {
    var datepicker = $(".datepicker");
    $("form").validate();

    if (datepicker.length) {
      datepicker.rules("add", {
        dateISO: true
      });
    }
});
