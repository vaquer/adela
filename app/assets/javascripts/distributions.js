$(function () {
  var initMediaType;
  (initMediaType = function() {
    var mediaType = $('#distribution_media_type').val();

    var containsMediaType = function() {
      return $("#media_type_select option[value='" + mediaType + "']").length > 0;
    }

    if (!mediaType) {
      $('#distribution_media_type').val($('#media_type_select').val());
      $('#distribution_media_type').hide();
    } else if (containsMediaType()) {
      $('#distribution_media_type').hide();
      $('#media_type_select').val(mediaType);
    } else {
      $('#media_type_select').val('otro');
      $('#distribution_media_type').val(mediaType);
    }
  })();

  var updateMediaType = function() {
    var mediaType = $('#media_type_select').val();
    $('#distribution_media_type').val(mediaType);
    if (mediaType == 'otro') {
      $('#distribution_media_type').val('');
      $('#distribution_media_type').show();
    } else {
      $('#distribution_media_type').hide();
    }
  };

  (function () {
    $('#media_type_select').change(updateMediaType);
  })();
});
