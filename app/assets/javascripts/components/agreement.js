var termsConfirmed = function() {
  if( $('#agreement-publish').is(':checked') && $('#agreement-validated').is(':checked') ){
    $('#publish').removeClass('disabled');
    $('#publish').prop('disabled', false);
  } else {
    $('#publish').addClass('disabled');
    $('#publish').prop('disabled', true);
  }
};
