var iframesrc = "http://dsp.gome.com.cn/static/common/4sohu/fourSohu.html";

var div = document.getElementById("dsp_gome_4sohu");
div.style.width = 760;
div.style.height = 98;
div.style.boder = 0;
div.style.clear = 'both';

var framestr = "<iframe style='width:760px;height:98px;' frameBorder=0 scrolling='no' src ='" + iframesrc + "'></iframe>";
div.innerHTML = framestr;
