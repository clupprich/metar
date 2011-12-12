Translation = {
  "station_code" : "Station",
  "station_name" : "Name",
  
}

onSubmit = function() {
  $("#result").activity();
  $.getJSON("/metar/" + $("#cccc").val(), function(data) {
    fillResult(data);
    $("#result").activity(false);
  }).error(function() {
    $("#result").activity(false);
  });
};

fillResult = function(data) {
  var elements = "<ul>";
  var root = $("#result");
  $(".container").animate({height: 348});
  $(".floater").animate({"margin-top": "-192"});
  
  root.empty();
  
  $.each(data, function(key, value) {
    elements += "<li><span class=\"key\">" + key + "</span>" + value + "</li>";
  });

  root.append(elements + "</ul>");
}

$(function() {
  options = {
    serviceUrl: '/cccc',
    fnFormatResult: function(value, data, currentValue) {
      return "<strong>" + value + " (" + data + ")</strong>";
    }
  };
  $("#cccc").autocomplete(options);
  
  $('#form').submit(function() {
    onSubmit();
    return false;
  });
});