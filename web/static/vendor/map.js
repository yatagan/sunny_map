function initMap() {
  if (typeof elmApp == 'undefined')
    return;

  elmApp.ports.initJsMap.subscribe(function (mapOptions) {
    var mapCanvas = document.getElementById("map");
    var map = new google.maps.Map(mapCanvas, mapOptions);

    function setMyLocation(location) {
      if (!this.marker) {
        this.marker = new google.maps.Marker({position: location});
        this.marker.setMap(map);
      }
      map.setCenter(location);
      this.marker.setPosition(location);
    }

    var markers = {};

    google.maps.event.addListener(map, 'bounds_changed', function () {
      var bounds = map.getBounds();
      if (bounds)
        elmApp.ports.boundsChanged.send(bounds.toJSON());
    });

    elmApp.ports.centerJsMap.subscribe(setMyLocation);

    elmApp.ports.drawShops.subscribe(function (shops) {
      function drawShop(shop) {
        if (shop.id in markers)
          return;

        var marker = new google.maps.Marker({position: shop.location, icon:new google.maps.MarkerImage("http://www.googlemapsmarkers.com/v1/009900/")});

        marker.setMap(map);

        google.maps.event.addListener(marker,'click',function() {
          if (!this.infowindow)
            this.infowindow = new google.maps.InfoWindow({
              content: shop.infowindow
            });
          this.infowindow.open(map, marker);
        });

        markers[shop.id] = marker;
      }

      shops.forEach(drawShop);
    });
  });

  elmApp.ports.jsReady.send("TODO: delete argument");
}
