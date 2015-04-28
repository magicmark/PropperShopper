'use strict';

// Finder Manager

var Googleplaces = require('googleplaces');

var GOOGKEY = '';

function FinderManager(item, location, voiceController) {
  this.item = item;
  this.voiceController = voiceController;
  //var googleQuery = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%s&radius=%s&types=%s&key=' + GOOGKEY;

  //var location = '-33.8670522%2C151.1957362';
  //var radius = '500';
  //var type = 'food';

  //var query = util.format(googleQuery, location, radius, 'food');
  this.places = new Googleplaces(GOOGKEY, 'json');

  this.avoidList = [
    'tesco',
    'asda',
    'sainsburys',
    'lidl',
    'aldi',
    'morrisons'
  ];

  this.mockCallList = [
    ''
  ];

  this.params = {
    location: location,
    radius:500,
    types: item.name.toLowerCase() == 'bananas'? 'grocery_or_supermarket':
            item.name.toLowerCase() == 'batteries'? 'electronics_store':
            'grocery_or_supermarket'
  };


}

FinderManager.prototype.findShops = function() {

  var mockNumberIndex = 0;
  var finder = this;
  finder.places.placeSearch(this.params, function(err, res) {
    if(err) {console.error("Google error: ", err); return;}
    //console.log(JSON.stringify(res,null,2));

    res.results.map(function(obj) {
      console.log(finder.mockCallList.length);

      if(mockNumberIndex >= finder.mockCallList.length) {
        console.log('no more mock numbers!');
        return;
      }

      if(finder.avoidList.indexOf(obj.name.toLowerCase()) > -1) {console.log('avoided a tesco!'); return;}

      (function(index) {
        finder.places.placeDetailsRequest({reference:obj.reference}, function(err, res) {
          if(err) {console.error("Google error: ", err); return;}
          console.log('Found a neat shop: ', obj.name, ' number: ', res.result.formatted_phone_number);
          console.log(obj);

          //call on new shop and stuff
          console.log('Calling store ', mockNumberIndex);
          var shopinfo = {
            googref :obj.reference,
            location : obj.geometry.location,
            name : obj.name,
            openhours : obj.opening_hours,
            address : res.adr_formatted,
            rating: obj.rating,
            imgref: obj.photos?obj.photos[0].photo_reference:undefined
          };

          finder.voiceController.callShop(finder.item, 
                                          shopinfo,
                                          finder.mockCallList[index]).then(function(call) {
            console.log('call success');
          }, function(err) {
            console.error('call failure', err);
          });
        });
      }(mockNumberIndex++));
    });

  });
};

FinderManager.prototype.shopData = function(data) {
  callcallback(data);
};

var callcallback;

FinderManager.prototype.onNewShop = function (callback) {
  callcallback = callback;
};

module.exports = FinderManager;
