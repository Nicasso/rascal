(function(){function t(n){var t=$(n).closest(".sft-target"),i=t.data("sft-impression"),r=t.data("sft-msg-impression");return{ds:i+r}}var n="//2.rto.microsoft.com/IMW/PR2.ashx?CH=SM&OP=",u="PO",r="OA",i={presented:function(i,r){var f=t(r),e=n+u;$.post(e,JSON.stringify(f))},clicked:function(i){var u=t(i.target),f=n+r;$.post(f,JSON.stringify(u))},clickedHero:function(i){var u=t(i.target),e=$(i.target).closest("[id^=slide-]").attr("id").split("-")[1],f;u.sn=e;f=n+r;$.post(f,JSON.stringify(u))}};window.addEventListener("load",function(){var n,t,r;for($(".sft-target").each(i.presented),n=$(".sft-target [id^=slide-] * a"),$.merge(n,$(".sft-target * a")),$.unique(n),t=0;t<n.length;++t)if(r=$(n[t]),r.closest("[id^=slide-]").length>0)$(r).on("click",i.clickedHero);else $(r).on("click",i.clicked)})})()