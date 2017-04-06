function setFckText(ename, espan, textvalue, fieldid){
	try{
		if(document.getElementById("FCKiframe"+fieldid)){
			document.getElementById("field"+fieldid+"span").style.display = "";
		}else{
			FCKEditorExt.setHtml(textvalue, ename);
			document.getElementById("field"+fieldid+"span").innerHTML = "";
		}
	}catch(e){
		window.setTimeout(function(){setFckText(ename, espan, textvalue, fieldid);},100);
	}
}
function getShowName(sname){
	var divt=document.createElement("div");
	divt.innerHTML=sname;
	return jQuery.trim(jQuery(divt).text());
}
var rowindexAll = -1;
//thisfieldid的目的，对主字段无用；对明细字段，可以获得字段的rowindex
function setFieldValueAjax(xmlstr,thisfieldid,fieldidAll,needInitCheckData){
	if(needInitCheckData == undefined){
		needInitCheckData = false;
	}
	var name = "";
	var key = "";
	var htmltype = "";
	var isdetail = "";
	var type = "";
	try{
		name = xmlstr.getElementsByTagName("name")[0].childNodes[0].nodeValue;
	}catch(e){}
	try{
		key = xmlstr.getElementsByTagName("key")[0].childNodes[0].nodeValue;
	}catch(e){}
	try{
		htmltype = xmlstr.getElementsByTagName("htmltype")[0].childNodes[0].nodeValue;
	}catch(e){}
	try{
		isdetail = xmlstr.getElementsByTagName("isdetail")[0].childNodes[0].nodeValue;
	}catch(e){}
	try{
		type = xmlstr.getElementsByTagName("type")[0].childNodes[0].nodeValue;
	}catch(e){}
	var rowindex = -9;
	var rowStr = "";
	try{
		if(thisfieldid.indexOf("_") > -1){
			rowindex = parseInt(thisfieldid.substr(thisfieldid.indexOf("_")+1, thisfieldid.length));
		}
	}catch(e){
		rowindex = -9;
	}
	if(rowindex>-9){
		rowStr = "_"+rowindex;
	}
	rowindexAll = rowindex;
	var fieldid = "";
	try{
		if(fieldidAll.indexOf("_") > -1){
			fieldid = fieldidAll.substr(0, fieldidAll.indexOf("_"));
		}else{
			fieldid = fieldidAll;
		}
	}catch(e){
		fieldid = fieldidAll;
	}
	var viewtype = "0";
	try{
		viewtype = document.getElementById("field"+fieldid+rowStr).getAttribute('viewtype');
	}catch(e){
		viewtype = "0";
	}
	try{
		if(fieldid == "-1"){
			try{
				document.getElementById("requestname").value = name;
			}catch(e){}
				try{
					if(document.getElementById("requestname").type!="hidden"){
						document.getElementById("requestname").value = name;
						if(name != ""){
							document.getElementById("requestnamespan").innerHTML = "";
						}
					}else{
						document.getElementById("requestnamespan").innerHTML = name;
					}
				}catch(e){
					try{
						document.getElementById("requestname").innerHTML = name;
					}catch(e){}
				}
		}else if(fieldid == "-2"){
			var fieldObjs = document.getElementsByName("requestlevel");
			for(var i=0; i<fieldObjs.length; i++){
				if(fieldObjs[i].value == name){
					fieldObjs[i].checked = true;
				}else{
					fieldObjs[i].checked = false;
				}
			}
		}else if(fieldid == "-3"){
			var fieldObjs = document.getElementsByName("messageType");
			for(var i=0; i<fieldObjs.length; i++){
				if(fieldObjs[i].value == name){
					fieldObjs[i].checked = true;
				}else{
					fieldObjs[i].checked = false;
				}
			}
		}else{
			if(htmltype=="1"){//input
				try{
					if(document.getElementById("field"+fieldid+rowStr).type!="hidden"){
						document.getElementById("field"+fieldid+rowStr).value = getShowName(name);
						if(name != ""){
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
						}
					}else{
						document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
						document.getElementById("field"+fieldid+rowStr).value = name;
					}
				}catch(e){
					try{
						document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
					}catch(e){}
				}
				if(type == "4"){//金额转换
					try{
						document.getElementById("field_lable"+fieldid+rowStr).value = name;
						numberToChinese(""+fieldid+rowStr);
						try{
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
						}catch(e){}
					}catch(e){}
				}
				if(type=="2" || type=="3"){//鏁村瀷鍜屾诞鐐瑰瀷
					try{
						var oTableObjs = jQuery("table[id^='oTable']");
						var tableLength = oTableObjs.size();
						for(var cx=0; cx<tableLength; cx++){
							var id_tmp = oTableObjs.get(cx).id;
							var groupid_tmp = parseInt(id_tmp.substr(6));
							calSum(groupid_tmp);
						}
					}catch(e){}
				}
			}else if(htmltype=="2"){
				try{
					if(document.getElementById("field"+fieldid+rowStr).style.display!="none" && document.getElementById("field"+fieldid+rowStr).tagName=="TEXTAREA"){
						document.getElementById("field"+fieldid+rowStr).value = getShowName(name);
						if(name != ""){
							document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "";
						}
					}else{
						document.getElementById("field"+fieldid+rowStr).value = name;
						document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
					}
				}catch(e){
					try{
						document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
					}catch(e){}
				}
				try{
					var fieldtemptype = "1";
					try{
						fieldtemptype = document.getElementById("field"+fieldid+rowStr).temptype;
					}catch(e){
						fieldtemptype = "1";
					}
					if(fieldtemptype == "2"){
						window.setTimeout(function(){setFckText("field"+fieldid, "field"+fieldid+"span", name, fieldid);},100);
					}
				}catch(e){
					//alert(e);
				}
				try{
					if(document.getElementById("FCKiframe"+fieldid)){
						document.getElementById("field"+fieldid+"span").style.display = "";
						document.getElementById("field"+fieldid+"span").innerHTML = name;
						document.getElementById("FCKiframe"+fieldid).width = "0px";
						document.getElementById("FCKiframe"+fieldid).height = "0px";
					}else{
						if(document.getElementById("field"+fieldid+rowStr).style.display!="none" && document.getElementById("field"+fieldid+rowStr).tagName=="TEXTAREA"){
							document.getElementById("field"+fieldid+"span").innerHTML = "";
						}
					}
				}catch(e){
					//alert(e);
				}
			}else if(htmltype == "3"){//button
				try{
					document.getElementById("field"+fieldid+rowStr).value = key;
				}catch(e){}
				document.getElementById("field"+fieldid+rowStr+"span").innerHTML = name;
			}else if(htmltype == "5"){//select
				try{
					var selectField = document.getElementById("field"+fieldid+rowStr);
					for(var i=0; i<selectField.options.length; i++){
						var optionTmp = selectField.options[i];
						if(optionTmp.value == key){
							optionTmp.selected = true;
						}else{
							optionTmp.selected = false;
						}
					}
				}catch(e){}
			}else if(htmltype == "7"){//especial
				try{
					document.getElementById("field"+fieldid+"span").innerHTML = name;
				}catch(e){}
			}
		}
		try{
			if(jQuery("#field"+fieldid+rowStr).val()=="" && viewtype=="1"){
				document.getElementById("field"+fieldid+rowStr+"span").innerHTML = "<img src='/images/BacoError.gif' align='absmiddle'>";
			}
		}catch(e){
			
		}
	}catch(e){
		//alert(e);
	}
	if(needInitCheckData == true){//如果是初始化页面的时候调用了Ajax去修改页面元素的值，则需要在这里初始化一下页面用于存放初始值的div的innerHTML
		try{
			createTags();
		}catch(e){}
	}
}

function onNewDoc(fieldid) {
	frmmain.action = "RequestOperation.jsp";
	frmmain.method.value = "docnew_"+fieldid;
	frmmain.isMultiDoc.value = fieldid;
	document.frmmain.src.value = "save";
	//附件上传
	StartUploadAll();
	checkuploadcomplet();
}
function parse_Float(i){
	try{
		i = parseFloat(i);
		if((i+"")==("NaN")){
			return 0;
		}else{
			return i;
		}
	}catch(e){
		return 0;
	}
}
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}
//TD4262 增加提示信息  开始

//提示窗口
function showPrompt(content){

	var showTableDiv  = document.getElementById('_xTable');
	var message_table_Div = document.createElement("div")
	message_table_Div.id="message_table_Div";
	message_table_Div.className="xTable_message";
	showTableDiv.appendChild(message_table_Div);
	var message_table_Div  = document.getElementById("message_table_Div");
	message_table_Div.style.display="inline";
	message_table_Div.innerHTML=content;
	var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	var pLeft= document.body.offsetWidth/2-50;
	message_table_Div.style.position="absolute"
	message_table_Div.style.top=pTop;
	message_table_Div.style.left=pLeft;

	message_table_Div.style.zIndex=1002;
	var oIframe = document.createElement('iframe');
	oIframe.id = 'HelpFrame';
	showTableDiv.appendChild(oIframe);
	oIframe.frameborder = 0;
	oIframe.style.position = 'absolute';
	oIframe.style.top = pTop;
	oIframe.style.left = pLeft;
	oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
	oIframe.style.width = parseInt(message_table_Div.offsetWidth);
	oIframe.style.height = parseInt(message_table_Div.offsetHeight);
	oIframe.style.display = 'block';
}
//TD4262 增加提示信息  结束
function createAndRemoveObj(obj){
	objName = obj.name;
	tempObjonchange=obj.onchange;
	outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";
	document.getElementById(objName).outerHTML=outerHTML;
	document.getElementById(objName).onchange=tempObjonchange;
}
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo){
	YearFrom  = parseInt(YearFrom,10);
	MonthFrom = parseInt(MonthFrom,10);
	DayFrom = parseInt(DayFrom,10);
	YearTo	= parseInt(YearTo,10);
	MonthTo   = parseInt(MonthTo,10);
	DayTo = parseInt(DayTo,10);
	if(YearTo<YearFrom){
		return false;
	}else{
		if(YearTo==YearFrom){
			if(MonthTo<MonthFrom){
				return false;
			}else{
				if(MonthTo==MonthFrom){
					if(DayTo<DayFrom)
					return false;
					else
					return true;
				}
				else
				return true;
			}
		}else{
			return true;
		}
	}
}
function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		document.getElementById("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}
function numberToFormat(index){
	if(document.getElementById("field_lable"+index).value != ""){
		var floatNum = floatFormat(document.getElementById("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert(msgWarningJinEConvert);
            document.getElementById("field"+index).value = "";
            document.getElementById("field_lable"+index).value = "";
            document.getElementById("field_chinglish"+index).value = "";
       	} else {
	        document.getElementById("field"+index).value = floatNum;
	        document.getElementById("field_lable"+index).value = milfloatFormat(floatNum);
       		document.getElementById("field_chinglish"+index).value = val;
       	}
	}else{
		document.getElementById("field"+index).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
}
function numberToFormatForReadOnly(index){
	if($GetEle("field"+index).value!=""){
		$GetEle("field"+index+"span").innerHTML=milfloatFormat($GetEle("field"+index).value);
		$GetEle("field"+index+"ncspan").innerHTML=numberChangeToChinese($GetEle("field"+index).value);
	}else{
		$GetEle("field"+index+"span").innerHTML="";
		$GetEle("field"+index+"ncspan").innerHTML="";
	}
}
function FormatToNumber(index){
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = document.getElementById("field"+index).value;
	}else{
		document.getElementById("field"+index).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
}
function numberToChinese(index){
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field"+index).value = document.getElementById("field_lable"+index).value;
		document.getElementById("field_lable"+index).value = numberChangeToChinese(document.getElementById("field_lable"+index).value);
	}else{
		document.getElementById("field"+index).value = "";
	}
}
function ChineseToNumber(index){
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = chineseChangeToNumber(document.getElementById("field_lable"+index).value);
		document.getElementById("field"+index).value = document.getElementById("field_lable"+index).value;
	}else{
		document.getElementById("field"+index).value = "";
	}
}
function uescape(url){
	return escape(url);
}
function formatTable(t){
	//整体使用try，是防止明细字段设置有问题的时候添加、删除行出现不规则时发生整理table高度出错的问题

	try{
		if(t.innerHTML.indexOf('detailFieldTable') < 0){
			return;
		}
		var datarow ;
		for(i = 0; i < t.rows.length; i++){
			tablerow = t.rows[i];
			if(tablerow.cells[0] && tablerow.cells[0].firstChild && tablerow.cells[0].firstChild.id && tablerow.cells[0].firstChild.id.indexOf('detailFieldTable') == 0){
				datarow = t.rows[i];
			}
		}
		if(datarow == null){
			return;
		}
		var rowheight = new Array();
		tablecount = datarow.cells.length;
		rowcount = datarow.cells[0].firstChild.rows.length;
		equalrowcount=0;
		if(rowcount > 10){
			caldelay = 10000;
		}
		for(i=0; i<rowcount; i++){
			equalcount = 0;
			for(j=0; j<tablecount; j++){
				otable = datarow.cells[j].firstChild;
				orows = otable.rows;
				if(j>0 && orows[i].clientHeight==datarow.cells[j-1].firstChild.rows[i].clientHeight){
					equalcount++;
				}
				if(!rowheight[i]){
					rowheight[i] = orows[i].clientHeight;
				}else if(rowheight[i] < orows[i].clientHeight){
					rowheight[i] = orows[i].clientHeight;
				}
			}
			if (equalcount == tablecount-1){
				equalrowcount++;
			}
		}
		if(equalrowcount==rowcount){
			return;
		}
		for (i = 0; i < datarow.cells.length; i++) {
			otable = datarow.cells[i].firstChild;
			orows = otable.rows;
			for (j = 0; j < orows.length; j++) {
				//alert(orows[j].cells[0].tagName);
				orows[j].cells[0].style.height = rowheight[j];
			}
		}
	}catch(e){}
}

function changeFormSplitPage(tabCount){
	//div的隐藏和显示
	jQuery("div[name^=formsplitdiv]").hide();
	jQuery("#formsplitdiv"+tabCount).show();
	//按钮的class改变
	jQuery("td[name^=formsplitspan]").attr("class","formSplitSpanOut");
	jQuery("#formsplitspan"+tabCount).attr("class","formSplitSpanIn");

}
function changeTo1000(svalue){
	var rvalue = "";
	var re;
	if(svalue.indexOf(".")<0){
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    }else{
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
	}
    rvalue = svalue.replace(re,"$1,");
	return rvalue;
}

//保留n位有效数字，系统默认保留4位，如果没有小数点或小数点后全为0，则不保留小数点
//result:带格式化的浮点数
//n:需保留的小数位数
//round:是否需要四舍五入
//zero:如果为0，是否保留小数位，默认为否
function doFormatNumber(result,n,round,zero)
{
	var intNum,floatNum;
	try{
		if(n==null||n==undefined){
			n = 4;
		}
		if(round==null||round==undefined){
			round=true;
		}
		if(zero==null||zero==undefined){
			zero = false;
		}
		if(result.toString().indexOf(".")==-1){
			return result;
		}
		intNum = result.toString().split(".")[0];
		floatNum = result.toString().split(".")[1];
		if(n==0){
			if(round && Number(floatNum.charAt(0))>=5){
				return Number(intNum)+1;
			}else{
				return intNum;
			}
		}
		if(floatNum.length<=n){
			if(zero)return result;
			var str = floatNum.replace(new RegExp("0","gm"),"");
			if(str==""){
				return intNum;
			}
			for(var i=floatNum.length-1;i>0;i--){
			if(floatNum.charAt(i)!=0){
				break;
			}else{
				floatNum = floatNum.substring(0,i);
			}
		}
			return intNum+"."+floatNum;
		}
		
		if(round && Number(floatNum.charAt(n))>=5){
			if(floatNum.substring(0,n).match(/^9+$/)!=null){
				intNum = (Number(intNum)+1).toString();
				floatNum = "";
			}else{
				floatNum = (Number(floatNum.substring(0,n))+1).toString();
				for(var i=floatNum.length;i<n;i++){
					floatNum = "0"+floatNum;
				}
			}				
		}else{
			floatNum = floatNum.substring(0,n);
		}
		if(!zero){
			str = floatNum.substring(0,n).replace(new RegExp("0","gm"),"");
			if(str==""){
				return intNum;
			}
			for(var i=n-1;i>0;i--){
				if(floatNum.charAt(i)!=0){
					break;
				}else{
					floatNum = floatNum.substring(0,i);
				}
			}
		}
		return intNum+"."+floatNum;
	}catch(e){
		return result.toString();
	}
}
