$(function() {
  $("select, input, textarea, input:checkbox, input:radio, input:file").uniform(); 
  $('.date_picker').datepicker({
    showOn: 'both',
    buttonImage: '/images/calendar_3.png',
    buttonImageOnly: true,
    dateFormat: "yy-mm-dd"
  });
  $('.flash').delay(2500).slideUp('fast').live('click', function() {$(this).slideUp('fast')});
});

function init_add_form() {
  $('.subnav a').live('click', function() {
    var _this = $(this);
    var to = $(_this.attr('to'));
    var targetOffset = (to.offset().top + _this.offset().top) - 200 + 'px';
    to.slideDown('fast').find('a').click(function() {
      to.slideUp('fast');
      _this.parent().show();
      return false;
    });
    _this.parent().hide();
    $('html,body').animate({scrollTop: targetOffset}, 1000);
    return false;
  });
};

function init_company_form() {
  $('#company_country').change(function() {
    val = $(this).val();
    if (val == 'United States') {
      $('#company_state').parents('li').slideDown();
    } else {
      $('#company_state').parents('li').slideUp();
    }
  });
  $('#company_country').trigger('change');
};

function init_location_form() {
  $('#location_country').change(function() {
    val = $(this).val();
    if (val == 'United States') {
      $('#location_state').parents('li').slideDown();
    } else {
      $('#location_state').parents('li').slideUp();
    }
  });
  $('#location_country').trigger('change');
};

var CENTER_OF_THE_WORLD_LAT = 44.94;
var CENTER_OF_THE_WORLD_LNG = -93.3;
var HEADER_HEIGHT = 130;
var FOOTER_HEIGHT = 50;
var DEFAULT_ZOOM = 12;

var info_window;
var bar_icon;
var map;
var markers = new Array();

function init_resize_map() {
  document_height = $(window).height();
  $('#global_map').css({'height':(document_height-HEADER_HEIGHT-FOOTER_HEIGHT)+'px'});
  $(window).resize(function(){
    document_height = $(window).height();
    $('#global_map').css({'height':(document_height-HEADER_HEIGHT-FOOTER_HEIGHT)+'px'});
  });
};

function show_bars_on_map(bars) {
  $('#global_map').height($(document).height() - 180).show();
  map = new GMap2(document.getElementById('global_map'));
  map.setMapType(G_SATELLITE_MAP);
  map.enableScrollWheelZoom();
  map.setCenter(new GLatLng(CENTER_OF_THE_WORLD_LAT, CENTER_OF_THE_WORLD_LNG), DEFAULT_ZOOM, G_NORMAL_MAP);
  init_resize_map();
  
  GEvent.addListener(map, "moveend", function() { updateMap(); });
};

function add_bar_icon(info) {
  var _html = "<div class='info_window'><h1>" + info.name + "</h1>" + 
      "<strong>" + info.description + "</strong>" + 
      "</div>";
  marker_options = {};
  //marker_options = { icon: bar_icon};
  var position = new GLatLng( info.lat, info.lng );
  var bar_marker = new GMarker( position, marker_options );
  map.addOverlay(bar_marker);
  GEvent.addListener(bar_marker, "click", function() {
    this.tooltip.hide();
    var _info = _html;
    bar_marker.openInfoWindowHtml(_info);
  });
  var tooltip = new Tooltip(bar_marker, info.name, 4); 
  bar_marker.tooltip = tooltip; 
  map.addOverlay(tooltip);   
  GEvent.addListener(bar_marker, 'mouseover', function() { this.tooltip.show(); } ); 
  GEvent.addListener(bar_marker, 'mouseout', function() { this.tooltip.hide(); } );
  markers[info.id] = bar_marker;
}

function init_map_base() {
  bar_icon = new GIcon(G_DEFAULT_ICON);
  bar_icon.image = '/images/map/drink_32.png';
  bar_icon.iconSize = new GSize(32, 32);
  bar_icon.shadowSize = new GSize(32, 32);
};

function updateMap() {
  var bounds = map.getBounds();
  var southWest = bounds.getSouthWest();
  var northEast = bounds.getNorthEast();
  $.get(
    '/markers.js', 
    {sw: southWest.toUrlValue(), ne: northEast.toUrlValue()},
    function(data) {
    }
  );
}

function remove_markers_outside_of_map_bounds() {
  for(i in markers) {
    if(i > 0 && markers[i] && !map.getBounds().containsLatLng(markers[i].getLatLng())) {
      map.removeOverlay(markers[i]);
      markers[i] = null;
    }
  }
};