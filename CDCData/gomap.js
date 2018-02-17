// When locator icon in datatable is clicked, go to that spot on the map
// When locator icon in datatable is clicked, go to that spot on the map
$(document).on("click", ".go-map", function(e) {
  e.preventDefault();
  $el = $(this);
  var lat = $el.data("lat");
  var long = $el.data("long");
  var state = $el.data("state");
  var year = $el.data("year");
  $($("#nav a")[0]).tab("show");
  Shiny.onInputChange("goto", {
    lat: lat,
    lng: long,
    state: state,
    year:year,
    nonce: Math.random()
  });
});
