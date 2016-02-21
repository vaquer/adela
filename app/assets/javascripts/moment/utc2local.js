$(function() {
    $('.timezone').each(function() {
        var utc = $(this).text(),
            local = moment.utc(utc).local().format('LLL');
        $(this).text(local.toString());
    });
});
