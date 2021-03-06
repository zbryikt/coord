// Generated by LiveScript 1.2.0
var mapOption, coordCtrl;
mapOption = {
  center: new google.maps.LatLng(23.745126, 120.926514),
  zoom: 8,
  minZoom: 8,
  maxZoom: 18,
  mapTypeId: google.maps.MapTypeId.ROADMAP
};
coordCtrl = function($scope, $timeout){
  import$($scope, {
    twd97: {},
    gws84: {},
    map: new google.maps.Map(document.getElementById('map-view'), mapOption),
    byWatch: false
  });
  $scope.$watch('twd97.x + twd97.y', function(){
    var laglng, ref$;
    if ($scope.byWatch) {
      return $scope.byWatch = false;
    } else {
      $scope.byWatch = true;
    }
    ref$ = laglng = coord.newToGws84($scope.twd97.x, $scope.twd97.y), $scope.gws84.x = ref$.lng, $scope.gws84.y = ref$.lat;
    if ($scope.gws84.x && $scope.gws84.y) {
      return $scope.map.setCenter(new google.maps.LatLng($scope.gws84.y, $scope.gws84.x));
    }
  });
  $scope.$watch('gws84.x + gws84.y', function(){
    var ref$;
    if ($scope.byWatch) {
      return $scope.byWatch = false;
    } else {
      $scope.byWatch = true;
    }
    ref$ = coord.newToTwd97({
      lat: $scope.gws84.y,
      lng: $scope.gws84.x
    }), $scope.twd97.x = ref$[0], $scope.twd97.y = ref$[1];
    if ($scope.gws84.x && $scope.gws84.y) {
      return $scope.map.setCenter(new google.maps.LatLng($scope.gws84.y, $scope.gws84.x));
    }
  });
  if ($scope.autoTest) {
    return $timeout(function(){
      var x$;
      x$ = $scope.twd97;
      x$.x = 305382.45248192194;
      x$.y = 2770084.3852933967;
      return x$;
    }, 1000);
  }
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}