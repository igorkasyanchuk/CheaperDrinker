$(document).ajaxSend(function(event, request, settings) {
    if ( settings.type == 'post' ) {
        settings.data = (settings.data ? settings.data + "&" : "")
                + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
});

$(function() {
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

var bar_icon = null;
var map = null;
var infos = new Array();
var markerClusterer = null;
var $info_window_opened = false;
var $icon_container = null;
var $current_stage = 0;

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

function init_map_elements() {
  $icon_container = IconsContainer.initialize();
}

function show_bars_on_map(bars) {
  $('#global_map').height($(document).height() - 180).show();
  map = new GMap2(document.getElementById('global_map'));
  init_map_elements();
  map.setMapType(G_SATELLITE_MAP);
  map.enableScrollWheelZoom();
  map.addControl(new GLargeMapControl());
  map.setCenter(new GLatLng(USER_LOCATION.lat, USER_LOCATION.lng), USER_LOCATION.zoom, G_NORMAL_MAP);
  init_resize_map();
  GEvent.addListener(map, "moveend", function() { if ($current_stage != 1) { updateMap('moveend'); } });
  var clusterOpt = {
			maxZoom: 13,
			gridSize: 50
		};
  markerClusterer = new MarkerClusterer(map, null, clusterOpt);
  map.checkResize();
  process_map_zoom();
};

function get_bar_marker(info) {
  bar_marker = new GMarker(new GLatLng(info.lat, info.lng), {icon: $icon_container.icon(info.plan), title: info.name});
  GEvent.addListener(bar_marker, "click", function() {
    $current_stage = 1;
    var _marker = this;
    var _info = "<div class='info_window'>" +
      "<h1>" + 
      info.name + 
      ( info.gay ? "<img src='/images/bar/gay_small.png' title='gay bar'/>" : '' ) +
      "</h1>" + 
      "<address>" + info.address + "</address>" +
      "<p>" + info.description + "</p>" +
      "<div class='link_to_place'><a href='/places/" + info.id + "'>More Details</a></div>"
      "</div>";
    _marker.openInfoWindowHtml(_info, { onOpenFn: function() { popup_opened($current_stage); }, onCloseFn: popup_closed });
  });
  return bar_marker;
}

function popup_opened(opened) {
  $current_stage = 1;
}

function popup_closed() {
  if ($current_stage == 1) {
    $current_stage = 0;
  }
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
      from: from,
      gay: $('#gay_bar_check_box:checked').length,
      start: $('#current_min').val(),
      end: $('#current_max').val()
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
    update_hash_value();
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

var IconsContainer = {
  _free: null,
  _premium: null,
  _premium_plus: null,
  free_icon: function() {
    if (!this._free) {
      var iconOptions = {};
      iconOptions.width = 32;
      iconOptions.height = 32;
      iconOptions.primaryColor = "#FF0000";
      iconOptions.cornerColor = "#FFFFFF";
      iconOptions.strokeColor = "#000000";
      iconOptions.clickable = true;
      this._free = MapIconMaker.createMarkerIcon(iconOptions);
    }
    return this._free;
  },
  premium_icon: function() {
    if (!this._premium) {
      var iconOptions = {};
      iconOptions.width = 32;
      iconOptions.height = 32;
      iconOptions.primaryColor = "#0000FF";
      iconOptions.cornerColor = "#FFFFFF";
      iconOptions.strokeColor = "#000000";
      iconOptions.clickable = true;
      this._premium = MapIconMaker.createMarkerIcon(iconOptions);
    }
    return this._premium;
  },
  premium_plus_icon: function() {
    if (!this._premium_plus) {
      var iconOptions = {};
      iconOptions.width = 32;
      iconOptions.height = 32;
      iconOptions.primaryColor = "#00FF00";
      iconOptions.cornerColor = "#FFFFFF";
      iconOptions.strokeColor = "#000000";
      iconOptions.clickable = true;
      this._premium_plus = MapIconMaker.createMarkerIcon(iconOptions);
    }
    return this._premium_plus;
  },
  initialize: function() {
    this.free_icon();
    this.premium_icon();
    this.premium_plus_icon();
    return this;
  },
  icon: function(plan) {
    if (plan == 2) {
      return this.premium_plus_icon();
    } else if (plan == 1) {
      return this.premium_icon();
    } else {
      return this.free_icon();
    }
  }
};

function init_filter_locations() {
  $('.filter_locations').click(function(){
    _this = $(this);
    $(_this.val()).parents('.location').toggle();
  });
};

function init_advanced_search() {
  $('#advanced_search').attr('href', '').click(function() {
    $(this).toggleClass('expanded');
    _this = $(this);
    if (_this.hasClass('expanded')) {
      _this.text('-');
    } else {
      _this.text('+');
    }
    $('.advanced_search_form').slideToggle();
    return false;
  });
  $('#gay_bar_check_box').click(function() {
    updateMap('gay_checkbox');
  });
};

function init_add_location_special() {
  $('#add_location_special_link').click(function() {
    $('.add_location_special_form').slideDown('fast');
    $(this).hide();
    return false;
  });
  $('.cancel_add_location_special_link').click(function() {
    $('.add_location_special_form').slideUp('fast');
    $('#add_location_special_link').show();
    return false;
  });
  $('.edit_row').live('click', function() {
    $(this).parents('tr').find("span").hide();
    $(this).parents('tr').find(".field").show();
  });
  $('.cancel_row').live('click', function() {
    $(this).parents('tr').find(".field").hide();
    $(this).parents('tr').find("span").show();
  });
  $('.update_row').live('click', function() {
    _this = $(this);
    url = _this.attr('data-url');
    id= _this.attr('data-id');
    data = {
      special_day: {
        description: $('#description_' + id).val(),
        start_time: $('#start_time_' + id).val(),
        end_time: $('#end_time_' + id).val()
      }
    };
    $.ajax({
      type: 'put',
      url: url,
      data: data
    });
  });
};

function time(t) {
  if (t == 1440)
    return 'Close'
  else
    return TIMES_ARRAY[t];
} 

var SLIDER_MIN = 0;
var SLIDER_MAX = 1440;
var SLIDER_CURRENT_MIN = SLIDER_MIN;
var SLIDER_CURRENT_MAX = SLIDER_MAX;

function init_slider() {
  $("#slider-range").slider({
    range: true,
    min: SLIDER_MIN,
    max: SLIDER_MAX,
    values: [SLIDER_CURRENT_MIN, SLIDER_CURRENT_MAX],
    step: 30,
    slide: function(event, ui) {
      if (Math.abs(ui.values[0] - ui.values[1]) < 60) {
        return false;
      }
      else {
        $('#current_min').attr('value', ui.values[0]);
        $('#current_max').attr('value', ui.values[1]);
        $("#amount").val(time(ui.values[0]) + ' — ' + time(ui.values[1]));
        return true;
      }
    },
    stop: function(event, ui) {
      update_hash_value();
      updateMap("slider");
    }
  }); 
};

function get_hash_value() {
  return '#' + $('#current_min').val() + '/' + $('#current_max').val() + '/' + $('#select_date').val();
};

function update_hash_value() {
  window.location.hash = get_hash_value();
};

function set_url_options() {
  hash = window.location.hash;
  info = hash.replace('#', '').split('/');
  if (info.length >= 3) {
    SLIDER_CURRENT_MIN = info[0];
    SLIDER_CURRENT_MAX = info[1];
    $('#current_min').val(info[0]);
    $('#current_max').val(info[1]);
    $("#select_date option[vlaue='"+ info[2] +"']").attr('selected', 'selected');
  }
};