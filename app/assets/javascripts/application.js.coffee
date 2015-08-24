//= require jquery
//= require jquery_ujs
//= require jquery.ui.sortable
//= require jquery.ui.datepicker
//= require jquery.ui.datepicker-es
//= require jquery.expander
//= require jquery.pjax
//= require spin
//= require jquery.spin
//= require bootstrap
//= require toastr
//= require_self
//= require_directory .

$(document).ready ->
  toastr.options =
    'closeButton': false
    'debug': false
    'positionClass': 'toast-bottom-right'
    'onclick': null
    'showDuration': '300'
    'hideDuration': '1000'
    'timeOut': '5000'
    'extendedTimeOut': '1000'
    'showEasing': 'swing'
    'hideEasing': 'linear'
    'showMethod': 'fadeIn'
    'hideMethod': 'fadeOut'
  return
