'use strict';

var events = require('events');

var busboy = require('connect-busboy')();
var fs = require('fs');

var FinderManager = require('./finderman.js');
var voiceController = require('./voiceController')();

var Wit = require('node-wit');

var exec = require('child_process').exec;
var util = require('util');
var request = require('request');

var sendgrid = require('sendgrid')('','');

var braintree = require('braintree');
var gateway = braintree.connect({
  environment: braintree.Environment.Sandbox,
  merchantId: '',
  publicKey: '',
  privateKey: ''
});

module.exports = function(app) {
  app.all('/*', function(req,res,next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 
                'X-Requested-With, Content-Type, Authorisation-Token');
    next();
  });

  app.get('/client_token', function(req, res) {
    gateway.clientToken.generate({
      //customerId:aCustomerId
    }, function(err, resu) {
      if(err) console.error(err);
      res.send(resu.clientToken);
    });
  });

  app.get('/purchases', function(req, res) {
    var nonce = req.body.payment_method_nonce;
    gateway.transaction.sale({
      amount:'10.0',
      paymentMethodNonce: nonce,
    }, function(err, res) {
      if(err) console.error(err);
      var email = new sendgrid.Email();

      email.addTo('');
      email.setFrom('');
      email.setSubject('ProperShopper payment processed!');
      email.setHtml('<b>Thank you</b> for using ProperShopper!');
      sendgrid.send(email);
    });
  });

  app.get('/voice/', voiceController.buildVoiceXml);

  app.post('/voiceEnd', voiceController.processVoiceRequest);
  app.post('/voiceEndMoney', voiceController.getDosh);

  app.get('/callTest', function(req, res, next) {
    var callPromise = voiceController.callShop({name:'batteries',qualifier:'AA',quantity:'5'}, '');

    callPromise.then(function(call) {
      console.log('Call success.');
      res.send({error:null, msg:null});
    }, function(err) {
      console.error('Call error: ', err);
      res.send({error:err, msg: null});
    });
  });

  app.get('/hello', function(req, res, next) {
    res.end('hi');
  });

  app.get('/test', function(req, res, next) {
    res.json({'test':true});
  });

  app.post('/hello', function(req, res, next) {
    res.end('hiya');
  });

  app.all('/testgoog', function(req, res){
    var g='';
    var gurl = '';
    var url = util.format(gurl, 'banana');
    request(url, function(err, res, body) {
      console.log(body);
      console.log(JSON.parse(body).items[0].pagemap.cse_image[0].src);
    });
  });

  app.post('/sendVoice', function(req, res) {
    console.log('incoming');
    var fstream;
    req.pipe(req.busboy);
    req.busboy.on('file', function (fieldname, file, filename) {
      console.log("Uploading: " + filename); 
      fstream = fs.createWriteStream(__dirname + '/files/' + filename);
      file.pipe(fstream);
      fstream.on('close', function () {
        console.log('finished uploading');
        var filepath = __dirname + '/files/';
        var newFilename = filename.split('.')[0] + '.wav';
        console.log('converting ' + filename + ' to ' + newFilename);
        exec('ffmpeg -i ' + filepath + filename + ' ' + filepath + newFilename, function(err, stdout, stderr) {
          console.log('converted audio file: ', stdout);
          parseAudioRequest(newFilename, function(result) {
            if(!result || !result.name || !result.quantity) result = {
              name : 'Eggs',
              quantity : '5',
              qualifier: 'Scotch'
            };

            if(!result) {
              res.json({'success':'false', obj:null});
              console.log('error parsing audio request');
            } else {

              var g='';
              var gurl = '';
              var url = util.format(gurl, result.qualifier + " " + result.name);

              request(url, function(err, imgres, body) {
                var bodyj = JSON.parse(body);
                if(!bodyj || !bodyj.items || !bodyj.items[0].pagemap || !bodyj.items[0].pagemap.cse_image || !bodyj.items[0].pagemap.cse_image[0].src) {
                  result.imgurl = 'http://images.halloweencostumes.com/products/8184/1-1/banana-flasher-costume.jpg';
                } else {
                  result.imgurl = JSON.parse(body).items[0].pagemap.cse_image[0].src;
                }

                var numbers = {
                  one:'1',
                  won:'1',
                  a:'1',
                  two:'2',
                  to:'2',
                  too:'2',
                  three:'3',
                  four:'4',
                  'for':'4',
                  five:'5',
                  six:'6',
                  seven:'7',
                  eight:'8',
                  nine:'9',
                  ten:'10'
                };
                if(numbers[result.quantity]) result.quantity = numbers[result.quantity];
                if(result.quantity === 0 || result.quantity === '0') result.quantity = '5';

                res.json({'success':'true', obj:result});
                console.log(result);
              });
            }
          });
        });
      });
    });
});

  function parseAudioRequest(filename, callback) {
    var stream = fs.createReadStream(__dirname + '/files/' + filename);
    Wit.captureSpeechIntent('', stream, 'audio/wav', function(err, intent) {
      console.log('processing user speech..');
      if(err) console.error('error while capturing intent: ', err);
      console.log('captured intent: ', JSON.stringify(intent,null,2));
      console.log(JSON.stringify(intent,null,0));
      if(!intent._text) {
        callback(null);
      } else {
        processRequestText(intent._text, function(res) {
          callback(res);
        });
      }
    });
  }

  //app.get('/parseTextRequest', function(req, res, next) {
  //  var text = req.query.text;

  //  Wit.captureTextIntent('G224LPOXNAMKGGGM4QKQOQOCH6EQYDEU', text, function(err, intent) {
  //    console.log('processing user text..');
  //    if(err) console.error('error while capturing intent: ', err);
  //    console.log('captured intent: ', JSON.stringify(intent,null,2));
  //    console.log(intent);
  //    res.send(processRequestText(intent.outcomes[0].entities.search_query[0].value));
  //  });

  //});

  function processRequestText(text, callback) {
    //var regex = /(^[^\ ]+)\ (.+)+\ ([^\ ]+$)/;
    //var regex = /([]+)\ (?:(.+)+\ )?([^\ ]+$)/;
    console.log("REGEXING");
    var regex = /(\d+|one|won|a|two|to|too|three|four|for|five|six|seven|eight|nine|ten)\ (?:(.+)+\ )?([^\ ]+$)/;
    var res = text.match(regex);
    if(!res) { callback(null); return;}
    console.log(res.length);
    var obj;
    if(res.length >= 4) {
      obj = {
        quantity: res[1],
        qualifier: res[2],
        name: res[3]
      };
    } else if(res.length == 3) {
      obj = {
        quantity: res[1],
        name: res[2]
      };
    } else {
      callback(null); return;
    }
    console.log('resulting object: ', JSON.stringify(obj,null,2));
    callback(obj);
  }

  app.post('/findMeStuff', function(req, res, next) {

    // TOOD: Validation....lol
    var itemObj = {
      name: req.body.name,
      quantity: req.body.quantity,
      qualifier: req.body.qualifier
    };

    var location = req.body.coords;

    console.log('Looking for: ', JSON.stringify(itemObj,null,0), ' at ', location);

    var finder = new FinderManager(itemObj, location, voiceController);

    finder.findShops();
      //found all shops yo

    finder.onNewShop(function (shopData) {
      console.log('Got some infos: ', JSON.stringify(shopData, null, 2));
    }); 

    res.send('ok');

  });




};
