	
var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function(){
	var that = this;
	if(/^(rgb|RGB)/.test(that)){
		var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
		var strHex = "#";
		for(var i=0; i<aColor.length; i++){
			var hex = Number(aColor[i]).toString(16);
			if(hex === "0"){
				hex += hex;	
			}
			strHex += hex;
		}
		if(strHex.length !== 7){
			strHex = that;	
		}
		return strHex;
	}else if(reg.test(that)){
		var aNum = that.replace(/#/,"").split("");
		if(aNum.length === 6){
			return that;	
		}else if(aNum.length === 3){
			var numHex = "#";
			for(var i=0; i<aNum.length; i+=1){
				numHex += (aNum[i]+aNum[i]);
			}
			return numHex;
		}
	}else{
		return that;	
	}
};

	//点击颜色弹出框
	function doColorClick(obj,e){	
		var preSib=$(obj).prev();
		$("#txtColorTemp").val(preSib.text());
		$("#txtColorTemp").css("background-color",$.trim(preSib.text()));
		$("#txtColorTemp").attr("from",preSib.attr("id")); 
		$("#coloPanel").dialog('open');	
		var offset = $(obj).offset();
		

		var coloPanelWidth=$("#coloPanel").parent()[0].offsetWidth;
		var coloPanelHeight=$("#coloPanel").parent()[0].offsetHeight;


		var rightedge=document.body.clientWidth-e.clientX;
		var bottomedge=document.body.clientHeight-e.clientY;
		
		if (rightedge<coloPanelWidth)
			$("#coloPanel").parent()[0].style.left=document.body.scrollLeft+e.clientX-$("#coloPanel").parent()[0].offsetWidth-10;
		else
			$("#coloPanel").parent()[0].style.left=document.body.scrollLeft+e.clientX+10;
			
		
		//if (bottomedge<coloPanelHeight)
		//	$("#coloPanel").parent()[0].style.top=document.body.scrollTop+e.clientY-$("#coloPanel")[0].parentNode.offsetHeight;
		//else
		//	$("#coloPanel").parent()[0].style.top=document.body.scrollTop+e.clientY;
		
	}
	
	//保存样式方法
	function generateCss(){
		var str=$("#cssBak").val();
		str=str.replace(/(\r|\n)+/g,"");
		var re = /(.*?){(.*?)}/g;
		var arr;
		var index=0;
		while ((arr = re.exec(str)) != null){
			var selector= $.trim(arr[1]); //选择器
			write(selector+"{");
			
			var value=arr[2]; //值	
			jQuery.each(value.split(";"),function(i,field){
				field=$.trim(field);
				if(field!=""){
					var pos=field.indexOf(":");
					field=$.trim(field.substring(0,pos));					
					writeAttr(selector,field,index);
				}
			});
			write("}");		
			index++;
		}
	}
	function writeAttr(classid,attr,index){
		try		{
			var value="";

			if(attr=="font-weight"){ //特殊处理
				
				var posBegin=classid.lastIndexOf(".");
				var tempClassid=classid.substring(posBegin+1);
				//alert("tempClassid:"+tempClassid)
				
				if($(".font-weight[r_id="+tempClassid+"]")[0].checked){
					value="bold";
				} else {
					value="normal";
				}	
				
			}  else if(classid==".header" && attr=="width"|| classid==".content" &&  attr=="width"){
				value="100%";
			}else {
				var pos=classid.indexOf(":hover");
				if(pos!=-1){	
					//alert(index)
					var ruleId=index;
					var attrScript=getScriptStyleString(attr);
					var styleMenu=document.getElementById("styleMenu");
					var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
					var rules=oStyleSheet.rules||oStyleSheet.cssRules;
					
					
					value=eval("rules["+ruleId+"].style."+attrScript);
					if(attr=='color'||attr=='font-family'){
						value =  value+"!important";
					}
					var posTemp=value.indexOf("url(");
					if(posTemp!=-1){
						var posTemp2=value.indexOf(")",posTemp);
						if(posTemp2!=-1){
							value=value.substring(posTemp+4,posTemp2);
						}
						value="url("+value+")";
					}
				} else {		
					value=$(classid).css(attr);	
					if(attr=='color'||attr=='font-family'){
						value =  value+"!important";
					}
					
				}
			}

			//以下消除image相关的http部分
			var pos=value.indexOf("http://");
			if(pos!=-1){
				var pos2=value.indexOf("/",pos+7);
				if(pos!=-1) value=value.substring(0,pos)+value.substring(pos2);
			}
			if("0"==(value+"").indexOf("rgb")){
				value=value.colorHex();
			}
			write("	"+attr+":"+value+";");
		}
		catch (e){			
			//alert("|"+classid+"|:|"+attr+"|"+"|"+e)
		}
		
	}
	function write(str){
		//alert($("#css").val()+"\n"+str);
		$("#css").val($("#css").val()+"\n"+str);
	}

	String.prototype.endWith=function(str){   
		if(str==null||str==""||this.length==0||str.length>this.length)   
		  return false;   
		if(this.substring(this.length-str.length)==str)   
		  return true;   
		else   
		  return false;   
		return true;   
	};
	
	$(document).ready(function(){
			//以下处理所有tabs插件
			$("#tabs").tabs({ selected:0});	

			//以下处理所有spin插件
			$('input.spin').bind("keypress",ItemCount_KeyPress);
			$('input.spin').spin({min:1, max:100,imageBasePath:'/js/jquery/plugins/spin/'});	

			//以下处理所有filetree插件
			$(".filetree").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var value="";
				if(r_id!=null){
					if(r_attr=="src"){
						value=$("."+r_id).attr("src");

						if(value==undefined) value="none";
						var pos=value.indexOf("http://");							
						if(pos!=-1) {
							var pos2=value.indexOf("/",pos+7);							
							value=value.substring(pos2);
						}
					} else {
						value=getScriptStyleValue(r_id,r_attr);
						
						if(value==undefined) value="none";
						var pos=value.indexOf("//");							
						if(pos!=-1) {
							var pos2=value.indexOf("/",pos+2);
							var pos3=value.indexOf("\")",pos2);
							value=value.substring(pos2,pos3);
						}
					}

				}
				value=value.replace(/"/g, "");
				if(value.endWith("none")){
					value = "";
				}
				this.value=value;
				$(this).filetree({
					file:value,
					call:function(src){
							if(r_attr=="src"){
								$("."+r_id).attr("src",src);
							}else {								
								setScriptStyleValue(r_id,r_attr,"url('"+src+"')");
								//$("."+r_id).css(r_attr,"url('"+src+"')");
							}
					}
				});
			});
			
			
			//以下处理所有color插件
			$('#colorPicker').farbtastic('#txtColorTemp');		
			$("#coloPanel").dialog({
				autoOpen: false,
				draggable:false,
				resizable:false,
				width:240,
				buttons: {
					"确定": function() {
				
						var value=$("#txtColorTemp").val();
						var color=$("#txtColorTemp").css("color");
						var objFormId=$("#txtColorTemp").attr("from");					
						$("#"+objFormId).text(value);
						$("#"+objFormId).css("background-color",value);
						$("#"+objFormId).css("color",color==""?"#fff":color);
						
						//alert($("#"+objFormId).html())

						var r_id=$("#"+objFormId).attr("r_id");
						var r_attr=$("#"+objFormId).attr("r_attr");

						//alert(objFormId+":"+r_id)
						setScriptStyleValue(r_id,r_attr,value);
						$(this).dialog("close"); 
					} 
				} 
			});		
			$(".colorblock").each(function(){				
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var color="#ffffff";
				if(r_id!=null){
					color=getScriptStyleValue(r_id,r_attr);
				}
				color=$.trim(color);
				$(this).text(color);							
				$(this).css("background-color",color);
				$(this).after("<img src='/js/jquery/plugins/farbtastic/color.png' style='cursor:hand;margin-left:5px'  onclick='doColorClick(this,event)' border=0/>"); 

				if(color=="transparent") {
					//this.parentNode.style.visibility='hidden';
					$(this).text("#ffffff");
				}
			});	
			
			////以下处理所有背景透明的checkbox框
			$(".transparent").each(function(){
				var t_id=$(this).attr("t_id");
				var tObj=$("#"+t_id)[0];
			
				//if(tObj==undefined) break;
				var r_id=$(tObj).attr("r_id");
				var r_attr=$(tObj).attr("r_attr");

				var color="#ffffff";
				if(r_id!=null){
					color=$("."+r_id).css(r_attr);
				}
				
				//alert(color)
				if(color=="transparent") this.checked=true;

				$(this).bind("click", function(){
				  //得到所关联的对像
				  var t_id=$(this).attr("t_id");
				  var tObj=$("#"+t_id)[0];
				  var r_id=$(tObj).attr("r_id");
				  var r_attr=$(tObj).attr("r_attr");

				  if(this.checked==true){ //透明					
					$("."+r_id).css(r_attr,"transparent");//设置背景
					tObj.parentNode.style.visibility='hidden';
				  } else {//非透明
					$("."+r_id).css(r_attr,$(tObj).text());//设置背景
					$(tObj).parent()[0].style.visibility='visible';
				  }
				}); 
			});


			//字体加粗
			$(".font-weight").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
						
				//alert(cValue)
				if(cValue=="700") this.checked=true;

				$(this).bind("click",function(){
					//alert(this.checked)
					if(this.checked)
						setScriptStyleValue(r_id,r_attr,"700");						
					else 
						setScriptStyleValue(r_id,r_attr,"400");
				});	
			});
			
			//字体样式
			$(".font-style").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
				cValue=$.trim(cValue);

				if(cValue=="italic") this.checked=true;
				$(this).bind("click",function(){
					if(this.checked)
						setScriptStyleValue(r_id,r_attr,"italic");							
					else 
						setScriptStyleValue(r_id,r_attr,"normal");
				});
			});	



			$(".line-style").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=$("."+r_id).css(r_attr);
				cValue=$.trim(cValue);
				for(var i=0;i<this.children.length;i++){
					var child=this.children[i];
					
					$(child).bind("click",function(){
						$("."+r_id).css(r_attr,this.value);
					});

					if(child.value==cValue){
						child.checked=true;
						//$(child).trigger("click");
					}
					
				}
			});

			$(".height").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
				cValue=$.trim(cValue);
				
				if(cValue=="medium"){
					cValue=3; 
				} else {
					var tempPos=cValue.indexOf("px");
					if(tempPos!=-1) cValue=cValue.substring(0,tempPos);		
				}
				
				this.value=cValue;
				$(this).bind("change",function(){
					setScriptStyleValue(r_id,r_attr,this.value);
				});
				
			});
	});	

	

	function getScriptStyleString(str){
		var returnStr=str;
		if(str=="font-size") returnStr="fontSize";
		else if(str=="font-family") returnStr="fontFamily";
		else if(str=="font-weight") returnStr="fontWeight";
		else if(str=="font-style") returnStr="fontStyle";
		else if(str=="background-color") returnStr="backgroundColor";
		else if(str=="background-image") returnStr="backgroundImage";		
		return returnStr;
	}
	function getScriptStyleValue(r_id,r_attr){
		var returnStr="";

		var pos=r_id.indexOf("rule");
		if(pos!=-1){
			r_attr=getScriptStyleString(r_attr);			
			var ruleId=r_id.substring(pos+4);
			var styleMenu=document.getElementById("styleMenu");
			var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
			var rules=oStyleSheet.rules||oStyleSheet.cssRules;
			returnStr=eval("rules["+ruleId+"].style."+r_attr);
			
			var posTemp=returnStr.indexOf("url(");
			if(posTemp!=-1){
				var posTemp2=returnStr.indexOf(")",posTemp);
				if(posTemp2!=-1){
					returnStr=returnStr.substring(posTemp+4,posTemp2);
				}
			}			
			//alert("oStyleSheet.rules["+ruleId+"].style."+r_attr+":"+returnStr)
		} else {	
			if(r_attr=='color'||r_attr=='font-family'){
				returnStr =  returnStr+"!important";
			}
			returnStr=$("."+r_id).css(r_attr);
		}
			if("0"==(returnStr+"").indexOf("rgb")){
				returnStr=returnStr.colorHex();
			}
			return returnStr;
	}
	function setScriptStyleValue(r_id,r_attr,value){
		//alert(r_id)
		var pos=r_id.indexOf("rule");
		if(pos!=-1){
			var ruleId=r_id.substring(pos+4);
			var styleMenu=document.getElementById("styleMenu");
			var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
			var rules=oStyleSheet.rules||oStyleSheet.cssRules;
		
			$(rules[ruleId]).css('cssText',$(rules[ruleId]).css('cssText')+";"+r_attr+':'+value+'!important');
			
			//eval("rules["+ruleId+"].style."+r_attr+"=\""+value+"\"");
			

		} else {
			//alert(r_attr+"$"+value)
			//$("."+r_id).css(r_attr,value);
			
			
			//alert(r_attr+"$"+value)
			//$("."+r_id).attr('style', r_attr+': '+value+' !important');
			//alert($("."+r_id).css('cssText'))
			$("."+r_id).css('cssText',$("."+r_id).css('cssText')+";"+r_attr+':'+value+'!important');
		}
	}
	

