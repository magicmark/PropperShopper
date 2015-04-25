var http = require('http');

function getPlacesAtCoords(coords, type) {

  var req = http.request({
    host: 'www.google.com',
    path: '/',
    port: '80',
    method: 'GET'
  }, function (response) {
    var data;
    response.on('data', function (chunk) { data += chunk; });
    response.on('end', function () {
      var shops = JSON.parse(data);
      var shopIds;
      shops.results.forEach(function (item) {
        console.log(item.id);
      });
    })
  });


}


module.exports = {
  findShops: function(coords, type) {
    return [];
  }
}