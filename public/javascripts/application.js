$(document).ajaxSend(function(event, request, settings) {
    if ( settings.type == 'post' ) {
        settings.data = (settings.data ? settings.data + "&" : "")
                + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
});

$(function() {
  $("select[class!=simple], input, textarea, input:checkbox, input:radio, input:file").uniform(); 
  $('.date_picker').datepicker({
    showOn: 'both',
    buttonImage: '/images/calendar_3.png',
    buttonImageOnly: true,
    dateFormat: "yy-mm-dd"
  });
  init_find_bar();
  $('.flash').delay(2500).slideUp('fast').live('click', function() {$(this).slideUp('fast')});
});

function init_add_form() {
  $('.subnav a').live('click', function() {
    var _this = $(this);
    var to = $(_this.attr('to'));
    to.slideDown('fast').find('a').click(function() {
      to.slideUp('fast');
      _this.parent().show();
      return false;
    });
    _this.parent().hide();
    return false;
  });
};

var CENTER_OF_THE_WORLD_LAT = 44.96;
var CENTER_OF_THE_WORLD_LNG = -93.3;
var HEADER_HEIGHT = 60;
var FOOTER_HEIGHT = 50;
var DEFAULT_ZOOM = 5;

var USER_LOCATION = {"lat": CENTER_OF_THE_WORLD_LAT, "lng": CENTER_OF_THE_WORLD_LNG, "zoom": DEFAULT_ZOOM};

var info_window;
var bar_icon;
var map;
var infos = new Array();
var markerClusterer = null;

function init_resize_map() {
  document_height = $(window).height();
  $('#global_map').css({'height':(document_height-HEADER_HEIGHT)+'px'});
  $('#sidebar').css({'height':(document_height-HEADER_HEIGHT)+'px'});
  $(window).resize(function(){
    document_height = $(window).height();
    $('#global_map').css({'height':(document_height-HEADER_HEIGHT)+'px'});
    $('#sidebar').css({'height':(document_height-HEADER_HEIGHT)+'px'});
    map.checkResize();
  });
};

function show_bars_on_map(bars) {
  $('#global_map').height($(document).height() - 180).show();
  map = new GMap2(document.getElementById('global_map'));
  map.setMapType(G_SATELLITE_MAP);
  map.enableScrollWheelZoom();
  map.addControl(new GLargeMapControl());
  map.setCenter(new GLatLng(USER_LOCATION.lat, USER_LOCATION.lng), USER_LOCATION.zoom, G_NORMAL_MAP);
  init_resize_map();
  GEvent.addListener(map, "moveend", function() { updateMap('moveend'); });
  var clusterOpt = {
			maxZoom: 14,
			gridSize: 50
		};
  markerClusterer = new MarkerClusterer(map, null, clusterOpt);
  map.checkResize();
  process_map_zoom();
};

function get_bar_marker(info) {
  bar_marker = new GMarker(new GLatLng(info.lat, info.lng), {title: info.name});
  GEvent.addListener(bar_marker, "click", function() {
    var _marker = this;
    var _info = "<div class='info_window'><h1>" + info.name + "</h1>" + 
      "<address>" + info.address + "</address>" +
      "<p>" + info.description + "</p>" +
      "<div class='link_to_place'><a href='/places/" + info.id + "'>More Details</a></div>"
      "</div>";
    _marker.openInfoWindowHtml(_info);
  });
  return bar_marker;
}

function updateMap(from) {
  var bounds = map.getBounds();
  var southWest = bounds.getSouthWest();
  var northEast = bounds.getNorthEast();
  $.get(
    '/markers.js', 
    {  
      sw: southWest.toUrlValue(), 
      ne: northEast.toUrlValue(),
      day: get_selected_day(),
      from: from
    },
    function(data) {
    }
  );
}

function get_selected_day() {
  return $('#select_date').val();
};

function init_day_filter() {
  $('#select_date').live('change', function() {
    total_map_clean();
    updateMap('filter');
  });
};

function total_map_clean() {
  markerClusterer.clearMarkers();
};

function show_place_map(location) {
  map = new GMap2(document.getElementById('map'));
  map.setMapType(G_SATELLITE_MAP);
  map.setCenter(new GLatLng(location.lat, location.lng), 15, G_NORMAL_MAP);
  position = new GLatLng( location.lat, location.lng );
  bar_marker = new GMarker( position, {} );
  map.addOverlay(bar_marker);
  $(window).scroll(function() {
    $('#map').css('top', $(window).scrollTop() + 'px');
  });
};

function re_init_comments() {
  $.colorbox.close(); 
  $('#comments form').show(); 
  $('#comments h3.thanks').remove();
  $('#comment_comment').val('');
};

function process_map_zoom() {
  GEvent.addListener(map, "zoomend", function(l,n) { 
    zoom_processor();
  });
};

function zoom_processor() {
  if (map.getZoom() <= 5) {
    // show welcome
    $('#sidebar').hide();
    $('.welcome_message').show();
  } else {
    // hide welcome
    $('#sidebar').show();
    $('.welcome_message').hide();
  }
};

function init_find_bar() {
  $('#find_bar').colorbox({width: "350px", inline: true, href: "#find_bar_container", onClosed: function() { $('.q_result').hide(); } });
  $('#find_bar_form').submit(function() {
    $('.ajax_loader').show();
  });
};