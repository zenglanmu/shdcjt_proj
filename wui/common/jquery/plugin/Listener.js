/**
 * Listener.js
 * 此类用于解决非ie下，通过js改变input的值时，
 * 无法触发其事件的问题（如：onpropertychange, oninput, onchange）
 * Sample: 见底部
 * clyt v0.1 2012/10/22
 */
function Listener() {
	//定时器
	var interval_l = null;  
	//key:name,value:value.  用于判断元素value是否变更
	var objValMap = new Map(); 
	//定时扫描的元素集
	var targetObjects = null; 
	//检查当前浏览器是否是ie
	var isIe = function () {
		return jQuery.browser.msie;
	};
	
	//检查当前监听器中是否有绑定监听对象
	var isEmpty = function () {
		if (targetObjects == null || targetObjects.length == 0) {
			return true;
		} 
		return false;
	};
	
	//定时执行的内容
	var execute = function (exeattr) {
		if (isIe() && !isEmpty()) {
			return;
		}
		if(isEmpty()){return;}
		//迭代元素集合
		jQuery.each(targetObjects, function (i, n) {
			var oldVal = objValMap.get(n.name);
			var _element = jQuery("input[name=" + n.name + "]")[0];
			var newVal = _element.value;
			if (oldVal != newVal) {
				objValMap.put(n.name, n.value);
				var _callbak = jQuery(_element).attr(exeattr);
				try {
					eval(_callbak);
				} catch(e) {}
			}
		});
	};
	//开始执行
	var start = function (seed, exeattr) {
		if (isIe() && !isEmpty()) {
			return;
		}
		if (seed == undefined || seed == 0) {
			seed = 500;
		}
		if (exeattr == undefined) {
			exeattr = "_listener";
		}
		interval_l = window.setInterval(function () {execute(exeattr);}, seed);
	}
	//停止监听器
	var stop = function () {
		if (interval_l) {
			window.clearInterval(interval_l);
		}
	};
	//绑定监听对象
	var load = function (selector) {
		if (isIe()) {
			return;
		}
		if (selector == undefined) {
			selector = "input[type=hidden][_listener!='']";
		}
		targetObjects = jQuery(selector);
		jQuery.each(targetObjects, function (i, n) {
			objValMap.put(n.name, n.value);
		});
	};
	this.execute = execute;
	this.start = start;
	this.stop = stop;
	this.load = load;
}

/**
 * 键值对，同Java Map
 */
function Map () {
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
};
/*
//Sample
var l = null;
jQuery(document).ready(function(){
	l = new Listener();
	l.load("input[onpropertychange!='']"); //不传参数时，默认参数为："input[type=hidden][_listener!='']";
	l.start(500, "onpropertychange");      //不传参数时，默认参数为：500, "_listener"
});
//停止监听时调用:
l.stop();
*/