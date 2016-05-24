define("sjs/matrix/ad/special",["sjs/plugin/mediator","sjs/matrix/ad/stat","sjs/data/guid","sjs/matrix/ad/form/common","sjs/matrix/ad/data","sjs/matrix/ad/config"],function(a,b,c,d,e,f){var g=jQuery,h=f._db,i={init:function(){this.ad_list={},this.as_list={},this.order_groups=[],this.ad_groups=[],this.ins_list={},this.ad_forms={},this.mediator=new a,this.report()},ones:function(a){if(a&&a.length){var b=this.gather(a);this.load(b)}},gather:function(a){var c,d,e,f,b=this.ad_groups.length;for(this.ad_groups[b]=[],c=0,d=a.length;d>c;c++)e=new j(a[c]),e&&-1!==e.status&&(e.data_id=c,e.group_id=b,f=e.order||0,this.ad_groups[b][f]||(this.ad_groups[b][f]=[],this.ad_groups[b][f].status=0),this.ad_groups[b][f].push(e),this.ad_list[e.id]=e);return b},order:function(a){this.ad_groups[a].sort(function(a,b){return"order"in a&&"order"in b?a.order>b.order?1:a.order==b.order?0:-1:1})},load:function(a){var d,e,f,c=this.ad_groups[a];if(c&&c.length)for(d=0;d<c.length;d++)if(c[d]&&c[d].length&&1!==c[d].status){for(e=0;e<c[d].length;e++)f=c[d][e],0===f.status&&(f.status=1,f.load());c[d].status=1;break}},cache_param:function(a){var c,d,e,f,h,b=Object.prototype.toString.call(a);if("[object Object]"===b){a.itemspaceid&&(c={},c[a.itemspaceid]=a,a=c);for(pro in a)d=a[pro].group_id||0,e=this.order_groups[d]||[],e.request||(e.request={}),g.extend(e.request,a),this.order_groups[d]=e}else if("[object Array]"===b)for(f=0,h=a.length;h>f;f++)d=a[f].group_id||0,e=this.order_groups[d]||[],e.push(a[f]),this.order_groups[d]=e},load_cache:function(){var d,g,b=this.order_groups,c=this,f=this.order_groups.length;for(d=0;f>d;d++)g=b[d]||[],g.request?e.get(g.request,function(a){g=g.concat(a),c.ones(g)}):this.ones(g)},create:function(a){return d.create(a)},bind:function(){return this.mediator.subscribe.apply(this.mediator,arguments)},fire:function(){return this.mediator.publish.apply(this.mediator,arguments)},unbind:function(){return this.mediator.remove.apply(this.mediator,arguments)},once:function(){return this.mediator.once.apply(this.mediator,arguments)},report:function(){var a={cont_id:"beans_13146",adtype:6};h.TAG&&(a.ext="|c-tag:"+h.TAG+"|"),b.get("pv",a)}},j=function(a){g.extend(this,{pgid:h.PAGEVIEWID,instance:{},name:""},a);var b=this;b.itemspaceid&&b.form||(b.status=-1),b.resource||(g.extend(b,b.defbean),b.resource||(b.status=-1)),this.id=this.adid+"_"+this.itemspaceid,this.cont_id=h.POSITION_ID_PREFIX+this.itemspaceid,!this.latency&&this.start_time&&this.end_time&&(this.latency=this.end_time-this.start_time),this.special&&this.special.dict&&(this.spec=g.extend({},this.special.dict,this.spec)),this.name||(this.name=this.id),this.init_event()};return j.prototype={once:function(a,b){return i.once(a+":"+this.name,b)},bind:function(a,b){return i.bind(a+":"+this.name,b)},unbind:function(a){return i.unbind(a+":"+this.name)},trigger:function(a){return i.fire(a+":"+this.name,arguments)},init_event:function(){var a=this;this.once("allownext",function(){var e,f,g,b=a.order||0,c=i.ad_groups[a.group_id][b];for(a.allowed_load_next=!0,e=0,f=c.length;f>e&&(g=c[e],g.allowed_load_next);e++)e===c.length-1&&i.load(a.group_id)}),"function"==typeof this.beforeload&&this.bind("beforeload",this.beforeload),"function"==typeof this.afterload&&this.bind("afterload",this.afterload),this.bind("afterload",function(){var d,e,f,g,c=!1;if("fullcgdbcrossadmediapop".indexOf(a.form)>=0&&(c=void 0==arguments[0][1]?!0:arguments[0][1]),a.status=2,d=a.container,d&&d.length&&(a.x=parseInt(d.offset().left),a.y=parseInt(d.offset().top)),!this.no_vc&&!c&&(b.get("pv",a),e=a.imp||a.resource.imp))for(f=e.split("|"),g=0;g<f.length;g++)b.get(f[g])}),this.last_time&&this.bind("afterinit",function(){window.setTimeout(function(){if(a["instance"]&&"detach"in a.instance)try{a.instance.hide()}catch(b){}},a.last_time)})},load:function(){var c,d,e,a=this,b=this.form;b&&(c=null,d=null,e=new Date,this.online_time&&(c=new Date(this.online_time)),this.offline_time&&(d=new Date(this.offline_time)),(!c||e>=c)&&(!d||d>e)&&(a.status=1,a.trigger("beforeload"),-1===b.indexOf("-")?require(["sjs/matrix/ad/form/"+b],function(b){a.instance=new b(a),i.ins_list[a.itemspaceid]=a.instance,a.instance.init(),a.trigger("afterinit")}):a.load_forms()))},load_forms:function(){var h,i,j,k,l,m,a=this,c=(this.form,this.form.split("-")),d=[],e=this.spec,f=[];for(h=0,i=c.length;i>h;h++){d.push("sjs/matrix/ad/form/"+c[h]),j={};for(k in e)0==k.indexOf(c[h]+"-")&&(l=k.replace(c[h]+"-",""),m=e[k],j[l]=m);f.push(j)}require(d,function(){var b,d,e,h,i,j;for(b=0,d=arguments.length;d>b;b++)e=arguments[b],h=f[b],i=g.extend({},a,{cont_id:a.cont_id+"_"+b,spec:h}),j=new e(i),a.instance[c[b]]=j,j.init();a.trigger("afterinit")})}},i.init(),{ones:function(a){var b=Object.prototype.toString.call(a);"[object Array]"===b?i.ones(a):"[object Object]"===b&&e.get(a,function(a){i.ones(a)})},get_ad:function(a){return i.ad_list[a]},wait:function(a){return i.cache_param(a)},start:function(){return i.load_cache()},create:function(a){return i.create(a)},bind:function(a,b){return i.bind(a,b)},unbind:function(a){return i.unbind(a)},trigger:function(a){return i.fire(a)}}});