var rt36th=rt36th||{},PREBID_TIMEOUT=1,pbjs=pbjs||{};pbjs.que=pbjs.que||[],function(){var a=document.createElement("script");a.type="text/javascript",a.async=!0,a.src="//acdn.adnxs.com/prebid/static/0.7.0/prebid.js";var b=document.getElementsByTagName("head")[0];b.insertBefore(a,b.firstChild)}();var googletag=googletag||{};googletag.cmd=googletag.cmd||[],function(){return"object"==typeof rt36th._config&&"object"==typeof rt36th._config.partners}()&&function(){function a(a,b){var c=new RegExp("\\b"+b+"\\b");a&&"string"==typeof a.className&&(c.test(a.className)||(a.className=a.className+" "+b))}function b(){if("function"==typeof Imgur&&"object"==typeof Imgur.Util&&"function"==typeof Imgur.Util.jafoLog)for(x=!0,clearInterval(o);z.length>0;)rt36th.log_impression.apply(this,z.shift())}function c(a,b){var c=null;return function(){var d=this,e=arguments;clearTimeout(c),c=setTimeout(function(){a.apply(d,e)},b)}}function d(a,b){var c=(""+b).replace(/^\./,"").split("."),e=c.length>0?c.shift():null;return e&&a&&"undefined"!=typeof a[e]?0===c.length?a[e]:d(a[e],c.join(".")):void 0}function e(a){return"object"==typeof a?Object.keys(a).map(function(b){return a[b]}):void 0}function f(){return{top:void 0!==window.pageYOffset?window.pageYOffset:(document.documentElement||document.body.parentNode||document.body).scrollTop,left:void 0!==window.pageXOffset?window.pageXOffset:(document.documentElement||document.body.parentNode||document.body).scrollLeft}}function g(a,b){if(s&&u&&"string"==typeof a&&"function"==typeof console[a]){var c=[].slice.call(b);c.unshift(t),console[a].apply(console,c)}}function h(){return g("log",arguments)}function j(){return g("info",arguments)}function k(){return g("warn",arguments)}function l(){var b,d,e=rt36th.create_slot_html("pop_sky");if(e&&(d=document.getElementById("wrapper-pop_sky"),b=document.getElementById("wrapper-pop_sky-close"),d)){b&&b.addEventListener("click",function(){rt36th.destroy_slot_html("pop_sky")},!1);var f=c(function(){rt36th.verify_slot_html("pop_sky")&&m()?(n(d,"nodisplay"),j("Showing Sky Pop")):(a(d,"nodisplay"),j("Hiding Sky Pop"))},D);window.removeEventListener("scroll",f),window.addEventListener("scroll",f)}}function m(){var a=821,b=599,c=1294,d=599,e=f().top,g=document.body.clientHeight,h=document.body.clientWidth,i=document.getElementById("right-content"),j=i?i.offsetHeight:0;return e>j&&(h>a&&g>b||h>c&&g>d)}function n(a,b){var c=new RegExp("\\b"+b+"\\b");a&&"string"==typeof a.className&&(a.className=a.className.replace(c,""))}var o,p=(new Date).getTime(),q=0,r={},s=/(\?|\&)pbjs_debug\=(true|1|on)/.test(document.location.search),t="[RT36TH]",u="object"==typeof console&&"function"==typeof console.log,v="undefined"==typeof window.ADBLOCKED||window.ADBLOCKED!==!1,w=!1,x=!1,y=150,z=[],A="data-partner",B=[],C=[],D=100,E=1e3,F=!1,G=[];return G.concat(e(rt36th._config.client_flags)),G.concat(e(rt36th._config.gallery_flags)),G.concat(e(rt36th._config.global_flags)),G.concat(e(rt36th._config.item_flags)),o=setInterval(b,y),rt36th.destroy_slots=function(){for(var a in r)r.hasOwnProperty(a)&&rt36th.destroy_slot_html(a)},rt36th.destroy_slot_html=function(b){var c,e=d(rt36th,"_place."+b);e&&"string"==typeof e.element&&(c=document.getElementById(e.element),c&&(c.parentNode.removeChild(c),h("Removed element "+e.element+" from the DOM.")),"pop_sky"===b&&a(document.getElementById("wrapper-pop_sky"),"nodisplay"))},rt36th.display=function(a){googletag.cmd.push(function(){googletag.display(a),q||(q=(new Date).getTime(),j("Displayed first impressions in "+rt36th.get_load_time()/1e3+" seconds"))})},rt36th.set_place=function(a){this._place=a},rt36th.gallery_nav=function(a){if("function"==typeof googletag.pubads&&"function"==typeof pbjs.addAdUnits){var b=d(a,"place");d(a,"place.bitwise.mask"),d(rt36th,"_place.bitwise.mask");if(!b||a.isAd)return rt36th.destroy_slots(),rt36th._place=!1,void h("nothing to show on navigation (PP?).");rt36th._place=b,rt36th.create_slots_html(b),rt36th.pbjs_request_bids(c(function(){rt36th.rotate()},E))}},rt36th.get_load_time=function(){var a=parseInt(q-p,10);return a>0?a:0},rt36th.handle_partner=function(a){var b;try{b=a.path[0].getAttribute(A)}catch(c){b="unknown"}B.push(b),h("Partner "+b+" loaded.")},rt36th.handle_slot_render=function(a){"object"==typeof a&&rt36th.log_impression(a.slot.getAdUnitPath(),a.size,a.slot.i_name)},rt36th.init=function(){if(!w){if(v)return void k("Adblocker detected. Aborting rt36th.init().");rt36th.init_html(),rt36th.load_all_partners(),rt36th.define_slots(),rt36th.display_slots(),w=!0}},rt36th.init_html=function(){return v?void k("Adblocker detected. Aborting rt36th.init_html()."):void rt36th.create_slots_html(rt36th._place)},rt36th.insert_after=function(a,b){var c=document.querySelector(b);c&&c.parentNode.insertBefore(a,c.nextSibling)},rt36th.insert_into=function(a,b){var c=document.querySelector(b);c&&(c.innerHTML="",c.appendChild(a))},rt36th.insert_parent=function(a,b){var c=document.querySelector(b);c&&c.appendChild(a)},rt36th.load_all_partners=function(){clearTimeout(pbjs.partner_load_timeout);for(var a in rt36th._config.partners)rt36th._config.partners.hasOwnProperty(a)&&rt36th.load_partner(a)},rt36th.load_partner=function(a){var b=d(rt36th,"_config.partners."+a+".src");if(b&&"string"==typeof b&&0!=b.length){C.push(a);var c=document.createElement("script"),e=document.getElementsByTagName("script")[0];rt36th._config.allow_async&&(c.async=!0),c.setAttribute(A,a),c.type="text/javascript",c.src=b,"gpt"===a?googletag.cmd.push(function(){rt36th.handle_partner({path:[c]})}):c.addEventListener("load",rt36th.handle_partner,!1),e.parentNode.insertBefore(c,e)}},rt36th.log_impression=function(a,b,c){return x?(Imgur.Util.jafoLog({event:"adImpression",meta:{ad_keywords:rt36th._place.keywords,ad_size:b,internal_name:c}}),void j("Logged delivered impression",arguments)):void z.push([a,b])},rt36th.get_slot_ids=function(){var a=[];for(var b in r)r[b]&&a.push(r[b].getSlotElementId());return a},rt36th.rotate=function(){j("Rotating units."),rt36th.set_bidder_targeting(),googletag.pubads().set("page_url",location.href),googletag.pubads().refresh(e(r))},rt36th.pbjs_add_units=function(){var a=[];for(i in rt36th._place)if(hasElement=d(rt36th._place,i+".element"),hasElement){var b=rt36th._place[i];a.push({code:b.element,sizes:b.sizes,bids:b.prebid})}pbjs.addAdUnits(a)},rt36th.pbjs_apply_all_bidderSettings=function(){for(vendor in rt36th._config.bidder_adjustments)rt36th._config.bidder_adjustments.hasOwnProperty(vendor)&&!isNaN(rt36th._config.bidder_adjustments[vendor])&&rt36th.pbjs_apply_bidderSettings_for(vendor,rt36th._config.bidder_adjustments[vendor])},rt36th.pbjs_apply_bidderSettings_for=function(a,b){"object"!=typeof pbjs.bidderSettings&&(pbjs.bidderSettings={}),"object"!=typeof pbjs.bidderSettings[a]&&(pbjs.bidderSettings[a]={}),pbjs.bidderSettings[a].bidCpmAdjustment=function(c){var d=c*b;return j("Adjusted "+a+" bid by "+b+" (from "+c+" to "+d+")"),d}},rt36th.pbjs_register_amazon=function(){var a=function(){function a(a){c=a.bids||[],pbjs.loadScript("//c.amazon-adsystem.com/aax2/amzn_ads.js",function(){b()})}function b(){if(amznads){var a=c.map(function(a){return a.params&&a.params.aid?a.params.aid:void 0});amznads.getAdsCallback(a,function(){var a,b=c[0].placementCode,d=amznads.getKeys();d.length?(a=pbjs.createBid(1),a.bidderCode="amazon",a.keys=d,pbjs.addBidResponse(b,a)):(a=pbjs.createBid(2),a.bidderCode="amazon",pbjs.addBidResponse(b,a))})}}var c,d={adserverTargeting:[{key:"amznslots",val:function(a){return a.keys}}]};return{callBids:a,defaultBidderSettings:d}};pbjs.registerBidAdapter(a,"amazon")},rt36th.pbjs_request_bids=function(a,b){pbjs.requestBids({timeout:b||PREBID_TIMEOUT,bidsBackHandler:function(b){a()}})},rt36th.define_slots=function(a){googletag.cmd.push(function(){var a,b,c;if("object"==typeof rt36th._place&&null!==rt36th._place){a=rt36th._place.keywords.indexOf("gallery")>-1?"gallery":"nongallery",b=rt36th._place.keywords.indexOf("logged_in")>-1?"yes":"no";for(i in rt36th._place)if(c=d(rt36th._place,i+".element")){var e=rt36th._place[i];r[i]=googletag.defineSlot(e.slot_id,e.sizes,e.element),r[i].setTargeting("page",a),r[i].setTargeting("login",b),r[i].setTargeting("flags",rt36th._place.keywords),r[i].setTargeting("url",location.href),r[i].addService(googletag.pubads()),r[i].i_name=i}}})},rt36th.set_bidder_targeting=function(){pbjs.setTargetingForGPTAsync();try{F?(amznads.getAdsCallback("3079",function(){amznads.setTargetingForGPTAsync("amznslots")}),googletag.pubads().clearTargeting("amznslots")):F=!0}catch(a){}},rt36th.display_slots=function(a){googletag.cmd.push(function(){rt36th.set_bidder_targeting(),googletag.pubads().enableSingleRequest(),googletag.pubads().set("page_url",window.location.href),googletag.pubads().addEventListener("slotRenderEnded",rt36th.handle_slot_render),googletag.enableServices();for(var a in r)r[a]&&rt36th.display(r[a].getSlotElementId())})},rt36th.create_slots_html=function(a){for(i in a)hasElement=d(rt36th._place,i+".element"),hasElement&&(rt36th.verify_slot_html("pop_sky")||("pop_sky"===i?l():rt36th.create_slot_html(i)))},rt36th.create_slot_html=function(b){var c,e=d(rt36th,"_place."+b);return e&&"string"==typeof e.element?(c=document.getElementById(e.element),c||(c=document.createElement("div"),c.setAttribute("id",e.element),"undefined"!=typeof e.insert_after&&rt36th.insert_after(c,e.insert_after),"undefined"!=typeof e.insert_into&&rt36th.insert_into(c,e.insert_into),"undefined"!=typeof e.insert_parent&&rt36th.insert_parent(c,e.insert_parent)),a(c,"div-gpt-ad-active-"+b),a(c,"advertisement"),h("Creating element "+e.element+" in the DOM for slot "+b+"."),c):void k("Invalid element - cannot create HTML in the DOM for slot "+b+".")},rt36th.verify_slot_html=function(a){var b=d(rt36th,"_place."+a);if(b&&"string"==typeof b.element)return null!==document.getElementById(b.element)},rt36th}()&&function(){"loading"===document.readyState?document.addEventListener("DOMContentLoaded",rt36th.init_html):rt36th.init_html(),pbjs.que.push(function(){rt36th.pbjs_apply_all_bidderSettings(),rt36th.pbjs_add_units(),rt36th.pbjs_register_amazon(),rt36th.pbjs_request_bids(function(){"loading"===document.readyState?document.addEventListener("DOMContentLoaded",rt36th.init):rt36th.init()},1e3)})}();
//# sourceMappingURL=rt36th.js.map