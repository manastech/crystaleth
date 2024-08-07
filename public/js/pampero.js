function renderJson(elemId, json) {
	const jsonToPrint = JSON.stringify(JSON.parse(json), null, 2);
	document.getElementById(elemId).innerHTML = jsonToPrint;
}
