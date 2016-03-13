$(function () {
    var setRequiredFields = function () {
        var setPrivateMandatoryFields, setPublicMandatoryFields, publicDataset;

        setPrivateMandatoryFields = function () {
            $('#dataset_publish_date').removeAttr('required');
            $("label[for='dataset_publish_date']").parent().removeClass('required');
        };

        setPublicMandatoryFields = function () {
            $('#dataset_publish_date').attr('required', 'required');
            $("label[for='dataset_publish_date']").parent().addClass('required');
        };

        publicDataset = ($('#dataset_public_access').val() === "true");

        if (publicDataset) {
            setPublicMandatoryFields();
        } else {
            setPrivateMandatoryFields();
        }
    };

    setRequiredFields();
    $('#dataset_public_access').change(setRequiredFields);
});

$(document).on('nested:fieldAdded', function(event){
    var updateMediaType;
    (updateMediaType = function() {
      var mediaType = event.field.find('.form-group .media_type_select');
      var inputText = event.field.find('.form-group input.media_type');

      inputText.val(mediaType.val());
      if (mediaType.val() == 'otro') {
        inputText.val('');
        inputText.show();
      } else {
        inputText.hide();
      }
    })();

    $('.media_type_select').on('change', updateMediaType);
})
