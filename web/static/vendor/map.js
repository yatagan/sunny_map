function initMap() {
  if (typeof elmApp == 'undefined')
    return;

  elmApp.ports.initJsMap.subscribe(function (mapOptions) {
    var mapCanvas = document.getElementById("map");
    var map = new google.maps.Map(mapCanvas, mapOptions);

    var marker = new google.maps.Marker({position:mapOptions.center});
    marker.setMap(map);
    google.maps.event.addListener(marker,'click',function() {
      var infowindow = new google.maps.InfoWindow({
        content: "This is my position"
      });
      infowindow.open(map,marker);
    });

    var markers = {};

    google.maps.event.addListener(map, 'bounds_changed', function () {
      var bounds = map.getBounds();
      if (bounds)
        elmApp.ports.boundsChanged.send(bounds.toJSON());
    });

    elmApp.ports.drawShops.subscribe(function (shops) {
      function drawShop(shop) {
        if (shop.id in markers)
          return;

        var marker = new google.maps.Marker({position: shop.location, icon:new google.maps.MarkerImage("http://www.googlemapsmarkers.com/v1/009900/")});

        marker.setMap(map);

        google.maps.event.addListener(marker,'click',function() {
          var infowindow = new google.maps.InfoWindow({
            content: shop.infowindow
          });
          infowindow.open(map, marker);
        });

        markers[shop.id] = marker;
      }

      shops.forEach(drawShop);
    });
  });

  elmApp.ports.jsReady.send("TODO: delete argument");
}
