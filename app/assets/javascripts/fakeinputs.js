function initFileUploads() {
  var W3CDOM = (document.createElement && document.getElementsByTagName);
	if (!W3CDOM) return;

  // File container
	var fakeFileUpload = document.createElement('div');
	fakeFileUpload.className = 'fakefile';

  // Text input for files
  var textInput = document.createElement('input');
  textInput.className = 'form-control';

  // Button for files
  var button = document.createElement('a');
  button.className = 'btn btn-primary bg--dark-grey';
  button.innerHTML = 'Explorar';

  // Append the elements
  fakeFileUpload.appendChild(textInput);
  fakeFileUpload.appendChild(button);

	var inputs = document.getElementsByTagName('input');

	for (var i=0; i < inputs.length ; i++) {
		if (inputs[i].type != 'file') continue;
		if (inputs[i].parentNode.className != 'file_input') continue;

		inputs[i].className = 'file hidden';

    // Clone the element
		var clone = fakeFileUpload.cloneNode(true);
		inputs[i].parentNode.appendChild(clone);
		inputs[i].relatedElement = clone.getElementsByTagName('input')[0];

    // add a listener to the button
    clone.children[1].onclick = clickHandler();

		inputs[i].onchange = inputs[i].onmouseout = changeHandler(inputs, i);
	}
}

function clickHandler(){
  return function() {
    realField = this.parentNode.parentNode.getElementsByTagName('input')[0];
    realField.click();
  };
}

function changeHandler(inputs, i) {
  return function() {
    inputs[i].relatedElement.value = this.value;
  };
}
