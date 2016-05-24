/**
 *
 * @author LavaWong<wjh_9527@163.com>
 * @date 15/5/27.
 */
(function (win) {
	var doc = document, version = '1.1.1', callbackData = {}, length = 0, cbkLen = 0;
	if (win.jsLoader) {
		if (win.jsLoader.version >= version) {
			return
		}

		callbackData = win.jsLoader.getData();
		length = callbackData.length
	}

	function emptyFn(){};
	/**
	 * 复制对象
	 * @param opts
	 * @param deep
	 * @returns {{}}
	 */
	function copy(opts, deep){
		var newObj = {}, hasOwn, tmp;
		for (var p in opts) {
			hasOwn = opts.hasOwnProperty(p);
			tmp = opts[p];
			if (hasOwn) {
				if (!deep || 'object' !== typeof(tmp)) {
					newObj[p] = tmp;
				} else {
					newObj[p] = copy(tmp);
				}
			}
		}
		return newObj;
	}

	/**
	 * 获取script标签
	 * @param url
	 * @param callback
	 * @param charset
	 */
	function getScript(url, callback, charset) {
		var script = doc.createElement("script");
		script.type = "text/javascript";
		if (charset) {
			script.charset = charset
		}

		script.onreadystatechange = script.onload = function () {
			if (!this.readyState || this.readyState == "loaded" || this.readyState == "complete") {
				if (callback) {
					callback()
				}

				script.onreadystatechange = script.onload = null;
				script.parentNode.removeChild(script)
			}
		};
		script.src = url;
		var h = doc.getElementsByTagName("head")[0];
		h.insertBefore(script, h.firstChild)
	}

	var JsObj = function (name, url) {
		this.name = name;
		this.url = url;
		this.callback = []
	};
	JsObj.prototype = {
		status: 'init',
		onload: function () {
			this.status = 'ok';
			var errors = [];
			if (this.url.indexOf('common.js')) {
//				debugger;
			}
			for (var i = 0; i < this.callback.length; i++) {
				if (typeof this.callback[i] == 'function') {
					try {
						this.callback[i]()
					} catch (e) {
						errors.push(e.toString())
					}
				}
			}

			this.callback = [];
			if (errors.length != 0) {
				throw new Error(errors);
			}
		}
	};

	var jsLoader = function (opts, fn) {
		var cfg = {};
		var args = arguments;
		if (args.length == 3) {
			cfg.name     = args[0];
			cfg.url      = args[1];
			cfg.callback = args[2]
		} else if (typeof opts === 'string') {
			cfg.url = opts;
			if (typeof fn === 'function') {
				cfg.callback = fn
			}
		} else {
			cfg = copy(opts, !0);
			if (!cfg.callback && 'function' === typeof(fn)) {
				cfg.callback = fn;
			}
		}

		var url = cfg.url || "",
				name = cfg.name || "",
				callback = cfg.callback || emptyFn,
				charset = cfg.charset || "";

		var chain = {
			name: name,
			jsLoader: function (opts, fn) {
				var args = arguments;
				var cfg = {};
				if (args.length == 3) {
					cfg.name = args[0];
					cfg.url = args[1];
					cfg.callback = args[2]
				} else if (typeof opts === 'string') {
					cfg.url = opts;
					if (typeof fn === 'function') {
						cfg.callback = fn
					}
				} else {
					cfg = copy(opts, !0);
					if (!cfg.callback && 'function' === typeof(fn)) {
						cfg.callback = fn;
					}
				}

				if (!cfg.name) {
					cfg.name = 'noname' + length;
					length++
				}

				var c = jsLoader({name: this.name, callback: function () {
					jsLoader(cfg)
				}});
				c.name = cfg.name;
				return c
			}
		}

		if (name) {
			if (!callbackData[name]) {
				if (!url) {
					callbackData[name] = new JsObj(name);
					callbackData[name].status = 'waiting'
				} else {
					callbackData[name] = new JsObj(name, url)
				}

				length++
			} else if (callbackData[name].status == 'waiting' && url) {
				callbackData[name].status = 'init     '
			}

			if (cfg.status) {
				callbackData[name].status = cfg.status
			}

			if (callbackData[name].status == 'loading' || callbackData[name].status == 'waiting') {
				if (typeof callback == 'function') {
					callbackData[name].callback.push(callback)
				}

				return chain
			} else if (callbackData[name].status == 'ok') {
				if (typeof callback == 'function') {
					callback()
				}

				return chain
			}
		} else {
			if (!url) {
				return chain
			}

			for (var item in callbackData) {
				if (callbackData[item].url == url) {
					name = item;
					break
				}
			}

			if (!name) {
				name = 'noname' + length;
				callbackData[name] = new JsObj(name, url);
				length++
			}

			chain.name = name;
			if (callbackData[name].status == 'loading') {
				if (typeof callback == 'function') {
					callbackData[name].callback.push(callback)
				}

				return chain
			} else if (callbackData[name].status == 'ok') {
				if (typeof callback == 'function') {
					callback()
				}

				return chain
			}
		}

		if (typeof callback == 'function') {
			callbackData[name].callback.push(callback)
		}

		getScript(url, function () {
			callbackData[name].onload()
		}, charset);
		callbackData[name].status = 'loading';
		return chain
	};
	win.jsLoader = jsLoader;
	win.jsLoader.version = version;
	win.jsLoader.getData = function () {
		return callbackData
	}
})(window);