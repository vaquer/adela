var termsConfirmed = function() {
  if( $('#agreement-publish').is(':checked') && $('#agreement-validated').is(':checked') ){
    $('#publish').removeClass('disabled');
    $('#adela-message').toggleClass('hidden');
  } else {
    $('#publish').addClass('disabled');
    $('#adela-message').addClass('hidden');
  }
};
