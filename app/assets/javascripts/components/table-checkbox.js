var loadCheckboxes = function() {
  $('#cell-checkbox-master').click(function() {
    $('.cell-checkbox').prop('checked', this.checked);
  });
};
