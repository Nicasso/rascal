(function(e,t){"use strict";function s(){var e=location.href.split("#")[1]||"";/^\{%22/.test(e)&&(e=decodeURIComponent(e));try{return $.parseJSON(e)}catch(t){return{}}}e.ados_results=e.ados_results||null;var n=e.ADS_GLOBALS.network,r=e.ADS_GLOBALS.site,i={main:5,sponsorship:8},o=s();if(e.SKIP_AD_PROBABILITY&&Math.random()<=e.SKIP_AD_PROBABILITY){var u=o.keywords?o.keywords:[],a=!1;if(e.SKIP_AD_KEYWORDS&&u)for(var f=0;f<u.length;f++)if($.inArray(u[f],e.SKIP_AD_KEYWORDS)!==-1){a=!0;break}if(a){var l=document.getElementById("main"),c=document.createElement("img"),h=Math.floor(Math.random()*e.SKIP_AD_IMAGES.length);c.height=250,c.width=300,c.src=e.SKIP_AD_IMAGES[h],l.appendChild(c);return}}ados.run.push(function(){ados.isAsync=!0;var t=null;if(o.placements){var s=o.placements.split(",");for(var u=0;u<s.length;u++){var a=s[u].split(":"),f=a[0],l=a[1];t=ados_add_placement(n,r,f,i[f]),t.setFlightCreativeId(l),t.setProperties(o.properties)}}else for(var f in i)t=ados_add_placement(n,r,f,i[f]),t.setProperties(o.properties);ados_setWriteResults(!0),o.keywords&&ados_setKeywords(o.keywords),ados_load();var c=0,h=setInterval(function(){c++,e.ados_results&&(clearInterval(h),e.ados_results.sponsorship&&(e.postMessage?e.parent.postMessage("ados.createAdFrame:sponsorship",o.origin):(iframe=document.createElement("iframe"),iframe.src="/static/createadframe.html",iframe.style.display="none",document.documentElement.appendChild(iframe))))},50)})})(this);