/*Hunk Zeng 2009-4-23*/
;(function($) { 
	$.fn.filetree = function(option) {
		var param = jQuery.extend({			
			file:'none',
			call:null
		}, option);		


		$(this).each(function() {
			var $this = this;
			var fileObj = $(this);
			fileObj.attr("class","inputstyle");
			//this.scrollLeft+=this.offsetWidth;
			
			
			fileObj.css({width:'90%'});
			fileObj.keypress(function(e){window.event.keyCode=0;});
			var file=fileObj.val();


			var btn = $(document.createElement('img'));
			btn.attr('src', "/images/BacoBrowser.gif");
			btn.attr('disabled', fileObj.attr('disabled'));
			
			btn.css({cursor: 'pointer', padding:'0', margin: '0 0 0 5'});
			fileObj.after(btn);

			//fileObj.hide();
			
			btn.click(function(e){
				var tempFile=param.file;
				var pos=tempFile.indexOf("/page/resource/userfile/");
				if(pos!=-1) tempFile=tempFile.substring(pos+24);
			
				var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
				var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
				//alert("/docs/DocBrowserMain.jsp?url=/page/maint/common/UserResourceBrowse.jsp?file="+tempFile)
				var src = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/page/maint/common/UserResourceBrowse.jsp?file="+tempFile,"","addressbar=no;status=0;dialogHeight=550px;dialogWidth=550px;dialogLeft="+iLeft+";dialogTop="+iTop+";resizable=0;center=1;");
				//src="/images/homepage/imgmode1.gif";
				

				if (src!=null&&src!="false"){
					param.file=src;
					fileObj.val(src);
					//$($this).next().children("font").html(src);		
					if(param.call!=null){						
						var call=eval(param.call);
						call(src);
					}
				}
			});					
		});
	};
})(jQuery);