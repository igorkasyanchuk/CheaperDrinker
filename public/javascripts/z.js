var CENTER_OF_THE_WORLD_LAT = 39.96;
var CENTER_OF_THE_WORLD_LNG = -95.3;
var HEADER_HEIGHT = 100;
var FOOTER_HEIGHT = 24;
var SIDERBAR_FILTER = 123;
var AVAILABLE_HEIGHT = HEADER_HEIGHT + FOOTER_HEIGHT + 10;
var DEFAULT_ZOOM = 5;
var DEFAULT_DETAILED_ZOOM = 13;

var USER_LOCATION = {"lat": CENTER_OF_THE_WORLD_LAT, "lng": CENTER_OF_THE_WORLD_LNG, "zoom": DEFAULT_ZOOM};

var bar_icon = null;
var map = null;
var infos = new Array();
var markerClusterer = null;
var $info_window_opened = false;
var $icon_container = null;
var $current_stage = 0;

$(document).ajaxSend(function(event, request, settings) {
    if ( settings.type == "post" ) {
        settings.data = (settings.data ? settings.data + "&" : "")
                + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
});

$(function() {
  $(".date_picker").datepicker({
    showOn: "both",
    buttonImage: "/images/calendar_3.png",
    buttonImageOnly: true,
    dateFormat: "yy-mm-dd"
  });
  init_find_bar();
  $(".flash").delay(2500).slideUp("fast").live("click", function() {$(this).slideUp("fast")});
});

function init_add_form() {
  $(".subnav a").live("click", function() {
    var _this = $(this);
    var to = $(_this.attr("to"));
    to.slideDown("fast").find("a").click(function() {
      to.slideUp("fast");
      _this.parent().show();
      return false;
    });
    _this.parent().hide();
    return false;
  });
};

function init_resize_map() {
  document_height = $(window).height();
  if ($.browser.msie || $.browser.mozilla || $.browser.opera) {
    //AVAILABLE_HEIGHT += 20;
    // TODO FIX IE ISSUE with vertical scroller
  }
  $("#global_map").css({"height":(document_height-AVAILABLE_HEIGHT)+"px"});
  $("#sidebar").css({"height":(document_height-AVAILABLE_HEIGHT - SIDERBAR_FILTER)+"px"});
  $(window).resize(function(){
    document_height = $(window).height();
    $("#global_map").css({"height":(document_height-AVAILABLE_HEIGHT)+"px"});
    $("#sidebar").css({"height":(document_height-AVAILABLE_HEIGHT - SIDERBAR_FILTER)+"px"});
    map.checkResize();
  });
};

function init_map_elements() {
  $icon_container = new IconsContainer;
  $icon_container.init();
}

function show_bars_on_map(bars) {
  $("#global_map").height($(document).height() - 180).show();
  map = new GMap2(document.getElementById("global_map"));
  init_map_elements();
  map.setMapType(G_SATELLITE_MAP);
  map.enableScrollWheelZoom();
  map.addControl(new GLargeMapControl());
  map.setCenter(new GLatLng(USER_LOCATION.lat, USER_LOCATION.lng), USER_LOCATION.zoom, G_NORMAL_MAP);
  init_resize_map();
  GEvent.addListener(map, "moveend", function() { update_hash_value(); if ($current_stage != 1) { updateMap("moveend"); } });
  var clusterOpt = {
			maxZoom: 13,
			gridSize: 40
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
    var _gay = (info.gay ? "<img src='/images/bar/gay_small.png' title='gay bar'/>" : "");
    var _info = "<div class='info_window'>" +
      "<h1>" + 
      info.name + 
      "</h1>" + 
      "<address>" + info.address + "</address>" +
      "<p>" + info.description + "</p>" +
      "<div class='link_to_place'><a href='/places/" + info.id + "'>More Details</a></div>" +
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
  show_ajax();
  hide_results();
  $.get(
    "/markers.js", 
    {  
      sw: southWest.toUrlValue(), 
      ne: northEast.toUrlValue(),
      day: get_selected_day(),
      from: from,
      gay: $("#gay_bar_check_box:checked").length,
      start: $("#current_min").val(),
      end: $("#current_max").val(),
      zoom: map.getZoom()
    },
    function(data) {
    }
  );
}

function get_selected_day() {
  return $("#select_date").val();
};

function init_day_filter() {
  $("#select_date").live("change", function() {
    update_hash_value();
    total_map_clean();
    updateMap("filter");
  });
};

function total_map_clean() {
  markerClusterer.clearMarkers();
};

function show_place_map(location) {
  map = new GMap2(document.getElementById("map"));
  map.setMapType(G_SATELLITE_MAP);
  map.setCenter(new GLatLng(location.lat, location.lng), 15, G_NORMAL_MAP);
  position = new GLatLng( location.lat, location.lng );
  bar_marker = new GMarker( position, {} );
  map.addOverlay(bar_marker);
};

function re_init_reviews() {
  $.colorbox.close(); 
  $("#reviews form").show(); 
  $("#reviews h3.thanks").remove();
  $("#review_review").val("");
};

function process_map_zoom() {
  GEvent.addListener(map, "zoomend", function(l,n) { 
    zoom_processor();
  });
};

function zoom_processor() {
  if (map.getZoom() <= 6) {
    // show welcome
    $("#sidebar, #siderbar_filter").hide();
    $(".welcome_message").show();
  } else {
    // hide welcome
    $("#sidebar, #siderbar_filter").show();
    $(".welcome_message").hide();
  }
};

function init_find_bar() {
  $("#find_bar").colorbox({width: "350px", inline: true, href: "#find_bar_container", onClosed: function() { $(".q_result").hide(); } });
  $("#find_bar_form").submit(function() {
    $(".ajax_loader").show();
  });
};

function init_filter_locations() {
  $(".filter_locations").click(function(){
    _this = $(this);
    $(_this.val()).parents(".location").toggle();
  });
};

function init_advanced_search() {
  $("#advanced_search").attr("href", "").click(function() {
    $(this).toggleClass("expanded");
    _this = $(this);
    if (_this.hasClass("expanded")) {
      _this.text("-");
    } else {
      _this.text("+");
    }
    $(".advanced_search_form").slideToggle();
    return false;
  });
  $("#gay_bar_check_box").click(function() {
    updateMap("gay_checkbox");
  });
};

function init_add_location_special() {
  $("#add_location_special_link").click(function() {
    $(".add_location_special_form").slideDown("fast");
    $(this).hide();
    return false;
  });
  $(".cancel_add_location_special_link").click(function() {
    $(".add_location_special_form").slideUp("fast");
    $("#add_location_special_link").show();
    return false;
  });
  $(".edit_row").live("click", function() {
    $(this).parents("tr").find("span").hide();
    $(this).parents("tr").find(".field").show();
  });
  $(".cancel_row").live("click", function() {
    $(this).parents("tr").find(".field").hide();
    $(this).parents("tr").find("span").show();
  });
  $(".update_row").live("click", function() {
    _this = $(this);
    url = _this.attr("data-url");
    id= _this.attr("data-id");
    data = {
      special_day: {
        description: $("#description_" + id).val(),
        start_time: $("#start_time_" + id).val(),
        end_time: $("#end_time_" + id).val()
      }
    };
    $.ajax({
      type: "put",
      url: url,
      data: data
    });
  });
};

function time(t) {
  if (t == 1440)
    return "Close"
  else
    return TIMES_ARRAY[t];
};

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
        $("#current_min").attr("value", ui.values[0]);
        $("#current_max").attr("value", ui.values[1]);
        $("#amount").val(time(ui.values[0]) + " — " + time(ui.values[1]));
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
  map_center = map.getCenter();
  zoom = map.getZoom();
  return "#" + 
    $("#current_min").val() + "/" + 
    $("#current_max").val() + "/" + 
    $("#select_date").val() + "/" + 
    map_center.lat() + "/" + 
    map_center.lng() + "/" + 
    zoom;
};

function update_hash_value() {
  window.location.hash = get_hash_value();
};

function set_url_options() {
  hash = window.location.hash;
  info = hash.replace("#", "").split("/");
  if (info.length >= 6) {
    SLIDER_CURRENT_MIN = info[0];
    SLIDER_CURRENT_MAX = info[1];
    $("#current_min").val(info[0]);
    $("#current_max").val(info[1]);
    $("#select_date option[vlaue='"+ info[2] +"']").attr("selected", "selected");
    USER_LOCATION.lat = parseFloat(info[3]);
    USER_LOCATION.lng = parseFloat(info[4]);
    USER_LOCATION.zoom = parseInt(info[5]);
  };
};

function init_bar_rating() {
  $("#service_rating").raty({path: "/images", onClick: function(score) { $("#service_rating_value").val(score); } });
  $("#atmosphere_rating").raty({path: "/images", onClick: function(score) { $("#atmosphere_rating_value").val(score); } });
  $("#value_rating").raty({path: "/images", onClick: function(score) { $("#value_rating_value").val(score); } });
};

function show_ajax() {
  $("#ajax").show();
};

function hide_ajax() {
  $("#ajax").hide();
};

function hide_results() {
  $("#sidebar ul").hide();
  $("#sidebar p").hide();
};

function show_results() {
  $("#sidebar ul").show();
};

function init_header_autocomplete() {
  $('#q').autocomplete({
    minLength: 2,
    source: $('#q').attr('data-autocomplete'),
    select: function(event, ui) {
      window.location = ui.item.href;
      return false;
    }
  }).data( "autocomplete" )._renderItem = function( ul, item ) {
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a><strong>" + item.name + "</strong><span>" + item.address + "</span></a>")
      .appendTo( ul );
	};
};

function init_favorites() {
  $("a.add_to_favorites_button").live("click", function() {
    $.get($(this).attr("data-url"), {}, function(data){});
  });
  $("a.remove_from_favorites_button").live("click", function() {
    $.get($(this).attr("data-url"), {}, function(data){});
  });
};