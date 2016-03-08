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
