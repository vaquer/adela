$(function() {
    $("form").validate();
    $(".datepicker").rules("add", {
        dateISO: true
    });
});
