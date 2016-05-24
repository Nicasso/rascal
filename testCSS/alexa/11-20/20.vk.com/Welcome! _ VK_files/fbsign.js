var Fbsign = {

init: function(cb) {
  window.fbAsyncInit = function() {
    FB.init({
      appId      : 'YOUR_APP_ID', // App ID from the App Dashboard
      channelUrl : '//vk.com//api/fb_channel.html', // Channel File for x-domain communication
      status     : true, // check the login status upon init?
      cookie     : true, // set sessions cookies to allow your server to access the session?
      xfbml      : true  // parse XFBML tags on this page?
    });
    cb && cb();
  };

  (function(d, debug){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
     ref.parentNode.insertBefore(js, ref);
   }(document, false));
},

eol:1};try{stManager.done('fbsign.js');}catch(e){}
