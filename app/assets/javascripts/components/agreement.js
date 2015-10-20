var termsConfirmed = function() {
  if( $('#agreement-publish').is(':checked') && $('#agreement-validated').is(':checked') ){
    $('#publish').removeClass('disabled');
  } else {
    $('#publish').addClass('disabled');
  }
};
