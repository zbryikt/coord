map-option = do
  center: new google.maps.LatLng 23.745126,120.926514
  zoom: 8
  minZoom: 8
  maxZoom: 18
  mapTypeId: google.maps.MapTypeId.ROADMAP

coordCtrl = ($scope) ->
  $scope <<< do
    twd97: {}
    gws84: {}
    map: new google.maps.Map document.getElementById(\map-view), map-option
    by-watch: false

  $scope.$watch 'twd97.x + twd97.y' ->
    if $scope.by-watch => return $scope.by-watch = false else $scope.by-watch = true
    {lng: $scope.gws84.x, lat: $scope.gws84.y} = laglng = coord.to-gws84 $scope.twd97.x, $scope.twd97.y
    if $scope.gws84.x and $scope.gws84.y =>
      $scope.map.setCenter new google.maps.LatLng $scope.gws84.y, $scope.gws84.x

  $scope.$watch 'gws84.x + gws84.y' ->
    if $scope.by-watch => return $scope.by-watch = false else $scope.by-watch = true
    [$scope.twd97.x, $scope.twd97.y] = coord.to-twd97 {lat: $scope.gws84.y, lng: $scope.gws84.x}
    if $scope.gws84.x and $scope.gws84.y =>
      $scope.map.setCenter new google.maps.LatLng $scope.gws84.y, $scope.gws84.x

