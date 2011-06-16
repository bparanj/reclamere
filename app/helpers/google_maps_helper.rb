module GoogleMapsHelper

  def address_map(address, width = 500, height = 400, zoom = 11)
    map_id = "#{dom_id(address)}_map"
    ret = content_tag(:div, '', :id => map_id, :class => "google-map", :style => "width: #{width}px; height: #{height}px")
    if address.class.ancestors.include?(Address) && address.geocoded?
      #add_javascripts "http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{GOOGLE_AJAX_API_KEY}"
      add_to_html_head "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{GOOGLE_AJAX_API_KEY}\" type=\"text/javascript\"></script>"
      ret += "\n" + content_tag(:noscript) do
        "<b>JavaScript must be enabled in order for you to use Google Maps.</b> However, it seems JavaScript is either disabled or not supported by your browser. To view Google Maps, enable JavaScript by changing your browser options, and then try again."
      end
      ret += "\n" + javascript_tag do
        <<EOF
          if (GBrowserIsCompatible()) {

            // A function to create the marker and set up the event window
            // Dont try to unroll this function. It has to be here for the function closure
            // Each instance of the function preserves the contends of a different instance
            // of the "marker" and "html" variables which will be needed later when the event triggers.
            function createMarker(point,html) {
              var marker = new GMarker(point);
              GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(html);
              });
              return marker;
            }

            // Display the map, with some controls and set the initial location
            var #{map_id} = new GMap2(document.getElementById("#{map_id}"));
            #{map_id}.addControl(new GLargeMapControl());
            #{map_id}.addControl(new GMapTypeControl());
            #{map_id}.setCenter(new GLatLng(#{address.lat.to_s},#{address.lng.to_s}),#{zoom});

            // Set up marker

            var point = new GLatLng(#{address.lat.to_s},#{address.lng.to_s});
            var marker = createMarker(point,'<div style="width:180px">#{escape_javascript(simple_format(h(address.address_card)))}<\/div>')
            #{map_id}.addOverlay(marker);

          }

          // display a warning if the browser was not compatible
          else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
          }

          // This Javascript is based on code provided by the
          // Blackpool Community Church Javascript Team
          // http://www.commchurch.freeserve.co.uk/
          // http://econym.googlepages.com/index.htm
EOF
      end
    end
    ret
  end
  
end