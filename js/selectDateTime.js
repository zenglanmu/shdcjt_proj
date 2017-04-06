/*******定义全局变量*******/
var outObject;
var outValue;
var outType;
var outButton; 
var bShow = false;
var bohai = 0;//针对渤海请假单据专业
var CustomQuery=0;//客户查询
var outValue1;
var outValue2;

function $ele4p() {
	var elements = new Array();
	for (var i = 0; i < arguments.length; i++) {
		var element = arguments[i];
		if (typeof element == 'string') {
			element = document.getElementById(element);
			if (element == undefined || element == null) {
				element = document.getElementsByName(arguments[i])[0];
			}
		}
		if (arguments.length == 1) {
			return element;
		}
		elements.push(element);
	}
	return elements;
}

/*******屏蔽键盘的上下键******/
document.onkeyup = function (e){
	var evt = e ? e : event;
	var el = evt.srcElement ? evt.srcElement : evt.target;
	if (evt.keyCode==27){
		if(outObject)outObject.blur();
		closeLayer();
	} else if (el) {
		if(el.getAttribute("Author")==null && el != outObject && el != outButton){
			closeLayer();
		}
	}
}
/********鼠标点击别处时间控件消失*********/
document.onclick = function (){
  if (!bShow) closeLayer();
  bShow = false;
}
/*******时间控件消失函数*******/
function closeLayer(){
	$ele4p('meizzDateLayer2').style.display="none";
}
/********流程代理比较时间大小函数**********/
function agentTimeFunc(m,agentType){
  var beginDate; 
  var endDate;  
  var beginTime; 
  var endTime;  
  if(agentType == 2){
    beginDate = $G('beginDate').value; 
	endDate = $G('endDate').value;  
	beginTime = $G('beginTime').value; 
	endTime = $G('endTime').value;  
  }
  if(agentType == 3){
    beginDate = $G('fromdate').value; 
	endDate = $G('todate').value;  
	beginTime = $G('fromtime').value; 
	endTime = $G('totime').value;
  }
  if(beginDate != "" && endDate != "" && beginDate == endDate){
    if(beginTime != "" && outValue.name != "beginTime" && outValue.name != "fromtime"){
	  if(m < beginTime){
		alert('结束时间不能小于开始时间'); 
		outValue.value = '';
	    outObject.innerHTML = ''; 
	  }else{
		outValue.value = m;
	    outObject.innerHTML = m; 
	  }
    }else if(endTime != ""){
	  if(m > endTime){
		alert('结束时间不能小于开始时间'); 
		outValue.value = '';
	    outObject.innerHTML = ''; 
	  }else{
		outValue.value = m;
	    outObject.innerHTML = m; 
	  }
    }else{
	   outValue.value = m;
	   outObject.innerHTML = m; 
	}
   }else{	  
	  outValue.value = m;
	  outObject.innerHTML = m; 
   }
}
/*********人力资源－考勤管理－考勤维护*********/
function scheduleTimeFunc(){
   if(frmmain.startdate.value != "" && frmmain.enddate.value != "" && frmmain.starttime.value != "" && frmmain.endtime.value != ""){
       frmmain.operation.value="submit";
       frmmain.submit();
   }
}
/**********人力资源－培训安排*************/
function trainPlanTimeFunc(t){
  var starttime = document.all("starttime_"+outValue.id.substring(outValue.id.indexOf("_")+1)).value;
  var endtime = document.all("endtime_"+outValue.id.substring(outValue.id.indexOf("_")+1)).value;
  if(starttime != "" && starttime != null){
    if(t < starttime){
	    alert('结束时间不能小于开始时间'); 
		outValue.value = '';
	    outObject.innerHTML = '';
		return;
    }
  }
  if(endtime != "" && endtime != null){
    if(t > endtime){
	    alert('结束时间不能小于开始时间'); 
		outValue.value = '';
	    outObject.innerHTML = '';
		return; 
	}
  }
  outValue.value = t;
  outObject.innerHTML = t; 
}
/**********给页面span和hidden赋值函数**********/
function meizzDayClick(n){	
  if(outObject){
	if(n == 0){	 
		if(outType == 0){
		   outValue.value = '';  
		   outObject.innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
		}else{
		   outValue.value = '';  
		   outObject.innerHTML = '';
		   if(bohai==1) {getLeaveDays();}
           if(CustomQuery==1){
               if(outValue.value==""&&outValue1.value=="")
               frmmain.check_con(outValue2*1).checked = false;
           }
		}	
	 }else{
		if(outType == 2){                                               //判断流程代理的结束时间不能大于开始时间
		  agentTimeFunc(n,outType);
		}else if(outType == 3){
		  agentTimeFunc(n,outType);
		}else if(outType == 5){
          trainPlanTimeFunc(n);
		}else{
		  outValue.value = n;
	      outObject.innerHTML = n; 
		  if(outType == 4){scheduleTimeFunc()};
          if(bohai==1) {getLeaveDays();}
          if(CustomQuery==1){
               frmmain.check_con(outValue2*1).checked = true;
           }
		}  
	 }	
     closeLayer(); 
  } 
  else{
	 closeLayer(); 
  }
}
/*********时间控件生成开始**********/
var strFrame2 = "";
document.writeln('<iframe id=meizzDateLayer2 Author=wayx frameborder=0 style="position: absolute; width:185px; height:260px;height:260px;z-index:9999;display:none;background:#fff;overflow:hidden;"></iframe>');
strFrame2+='<div style="position:absolute;left:0;top:3;text-align:center; border:1px solid #bbb;padding:2px background-color:#FFFFFF; width:180px;font-size:9pt;" onselectstart="return false">';
strFrame2+='<h1 Author="wayx" style="background-color:#A0EBF1;font-size:12px;font-weight:normal;height:22px;line-height:20px;margin:0px;">';
strFrame2+='<div id=hourid><span style=\"display:inline-block;width:50%;text-align:left;\">&nbsp;&nbsp;Hour:</span><span style=\"display:inline-block;width:50%;text-align:right;\"><select id=hour name=hour>';
strFrame2+='<scr' + 'ipt>';
strFrame2+='document.body.overflow=\"hidden\";';
strFrame2+='var d = new Date();';
strFrame2+=' for (var i=0; i<24;  i++){';
strFrame2+='	i<10?j=0+i.toString():j=i;';
strFrame2+='		if (d.getHours().toString()==i)';
strFrame2+='		{';
strFrame2+='			document.writeln("<OPTION VALUE= " + j + " selected>" + j + "</option>");';
strFrame2+='		}else{';
strFrame2+='			document.writeln("<OPTION VALUE= " + j + ">" + j + "</option>");';
strFrame2+='		}';
strFrame2+='	 }';
strFrame2+='</scr' + 'ipt>';
strFrame2+='</select>&nbsp;&nbsp;</span></div></h1>';
strFrame2+='<span id="nowhour"></span>';
strFrame2+='</div>';
strFrame2+='<scr' + 'ipt>';
strFrame2+=' function getTime(id) {';
strFrame2+='    var sTime;';
strFrame2+='    var mTime = id.value;';
strFrame2+='    if(mTime<10){mTime = "0" + mTime;};';
strFrame2+='    sTime = document.all.hour.value + ":" +mTime;';
strFrame2+='	parent.meizzDayClick(sTime);';
strFrame2+=' }';
strFrame2+=' function clineTime() {';
strFrame2+='    var temptime;';
strFrame2+='    temptime = 0;';
strFrame2+='	parent.meizzDayClick(temptime);';
strFrame2+=' }';
strFrame2+='var timestr;';
strFrame2+='var m = new Date();';
strFrame2+='timestr = "<div style=\'border:#c5d9e8 1px solid;\' id=TimeLayer>";';
strFrame2+='	timestr+="<table><tr>";';
strFrame2+='	 for (var i=1; i<61; i++){';
strFrame2+='	 var j;';
strFrame2+='	   i<10?j=0+i.toString():j=i;';
strFrame2+='        var t =  i-1;';
strFrame2+='		if (i%6 == 0){';
strFrame2+='		  if(m.getMinutes().toString()==t){';
strFrame2+='		     timestr+="<td width=30 align=center bgcolor=\'#BEEBEE\' style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' onClick=getTime(minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td></tr><tr>";';
strFrame2+='		  }else{';
strFrame2+='		     timestr+="<td width=30 align=center  onmouseover=" + " style.backgroundColor=\'#BEEBEE\' " + " onmouseout=" + " style.backgroundColor=\'#fff\' " + " style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' onClick=getTime(minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td></tr><tr>";';
strFrame2+='		  }';
strFrame2+='		}else{';
strFrame2+='		  if(m.getMinutes().toString()==t){';
strFrame2+='		      timestr+="<td width=30 align=center bgcolor=\'#BEEBEE\' style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' onClick=getTime(minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td>";';
strFrame2+='		  }else{';
strFrame2+='		      timestr+="<td width=30 align=center onmouseover=" + " style.backgroundColor=\'#BEEBEE\' " + " onmouseout=" + " style.backgroundColor=\'#fff\' " + " style=\'font-size:9pt;FONT-FAMILY: Verdana;cursor:pointer;\' onClick=getTime(minute"+t+")>" + t + "<input type=hidden id=minute"+t+" value="+t+"></td>";';
strFrame2+='		  }';
strFrame2+='		}';
strFrame2+='	}';
strFrame2+='	timestr+="</tr><tr></table></div>";';
strFrame2+='	timestr+="<div style=\'text-align:right;margin-top:3px;\'><input type=\'button\' name=\'button\' value=\'Clear\' onClick=clineTime() style=\'height:20px;width:45px;border:#ccc 1px solid;padding:2px;FONT-FAMILY: Verdana;\'>&nbsp;&nbsp;&nbsp;";';
strFrame2+='	timestr+="<input type=\'button\' name=\'button\' value=\'Close\' onClick=parent.closeLayer() style=\'height:20px;width:45px;border:#ccc 1px solid;padding:2px;FONT-FAMILY: Verdana;\'></div><div style=\'text-align:right;margin-top:3px;\'></div>";';
strFrame2+='	document.getElementById("nowhour").innerHTML = timestr;';
strFrame2+='</scr' + 'ipt>';
//window.frames.meizzDateLayer2.document.writeln(strFrame2);
document.getElementById("meizzDateLayer2").contentWindow.document.writeln(strFrame2);
document.getElementById("meizzDateLayer2").contentWindow.document.close(); 
/*********时间控件生成结束**********/

/*********************************
 path: ../workflow/request/WorkflowAddRequestBody.jsp,AddBillMeeting.jsp,AddBillCaruseApprove.jsp,WorkflowAddRequestDetailBody.jsp,AddOvertime.jsp
*********************************/
function onShowFlowTime(spanname,inputname,isbodymand){
	var dads  = document.getElementById("meizzDateLayer2").style;
	//alert(dads);
	document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei - 50;
	dads.left = tleft - 5;
	outObject = th;
	outValue = inputname;
	if(isbodymand == 1){
	  outType = 0;
	}else if(isbodymand == 0){
	  outType = 1;
	}else{
	  outType = isbodymand;
	}
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workflow/request/AddRequest.jsp,WorkflowManageSingForBill.jsp
 *********************************/
function onWorkFlowShowTime(spanname,inputname,isbodymand){
	$ele4p('meizzDateLayer2').style.display="none";
	var dads  = $ele4p('meizzDateLayer2').style;
	setLastSelectTime($ele4p(inputname));
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei - 50;
	dads.left = tleft - 5;
	outObject = th;
	outValue = $ele4p(inputname);
	
	if(isbodymand == 1){
	  outType = 0;
	}else if(isbodymand == 0){
	  outType = 1;
	}else{
	  outType = isbodymand;
	}
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workflow/request/AddBillMeeting.jsp
*********************************/
function onShowMeetingTime(spanname,inputname,isbodymand){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei - 50;
	dads.left = tleft - 5;
	outObject = th;
	outValue = inputname;
	if(isbodymand == 0){
	  outType = 1;
	}else{
	  outType = isbodymand;
	}
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../docs/docs/DocAdd.jsp,DocEdit.jsp,DocAddExt.jsp,DocEditExt.jsp
*********************************/
function onShowDocsTime(spanname,inputname,isbodymand){
	var mdl2= document.getElementById('meizzDateLayer2');
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}

	mdl2.style.top  = (ttyp == "image") ? ttop + thei -300 : ttop + thei + 22 - 300;
	mdl2.style.left = tleft;

   // $('meizzDateLayer2').style.top =400;
	//alert($('meizzDateLayer2').style.top );
	//alert(	$('meizzDateLayer2').style.left);

	outObject = th;
	outValue = inputname;
	if(isbodymand){
	 outType = 0;
	}else{
	 outType = 1;
	}
	outButton = (arguments.length == 1) ? null : th;
	mdl2.style.display = 'block';
	bShow = true;
}

/*********************************
 path: ../voting/VotingAdd.jsp,VotingEdit.jsp
       ../CRM/data/AddContactLog.jsp,ContractEdit.jsp,ContractView.jsp,EditContactLog.jsp
	   ../CRM/sellchance/AddSellChance.jsp
	   ../hrm/report/schedulediff/HrmRpScheduleDiff.jsp,HrmRpScheduleDiffDepTime.jsp,HrmRpScheduleDiffDepDay.jsp,HrmRpScheduleDiffType.jsp
	                              HrmRpScheduleDiffTypeDay.jsp,HrmRpScheduleDiffDepDayReport.jsp,HrmRpScheduleDiffDepMonReport.jsp,HrmScheduleDiffDetailReport.jsp
								  HrmShcheduleDiffReport.jsp,HrmScheDuleDiffTypeMonReport.jsp
	   ../hrm/report/usedemand/HrmRpUseDemand.jsp
	   ../hrm/schedule/HrmArrangeShift.jsp,HrmArrangeShiftAdd.jsp,HrmDefaultScheduleAdd.jsp,HrmDefaultSchedule.jsp,HrmScheduleMaintance.jsp,HrmScheduleMaintanceAdd.jsp
       ../cowork/AddCoWork.jsp
	   ../meeting/data/EditMeeting.jsp
*********************************/
function setLastSelectTime(inputname)
{	
	if(inputname.value)
	{
		var inputtime = inputname.value;
		var inputhour = inputtime.substring(0,2);
		var inputminute = inputtime.substring(3,5);
		if(inputminute!=-1)
		{
			inputminute = inputminute.valueOf()<10?inputminute.substring(1,2):inputminute;
			var inputminutetd = jQuery("#meizzDateLayer2")[0].contentWindow.document.getElementById('minute' + inputminute).parentNode;
			
			var inputhourselect = jQuery("#meizzDateLayer2")[0].contentWindow.document.getElementById('hour');
			for(var i=1;i<61;i++)
			{
				var t =  i-1;
				var otherminute = jQuery("#meizzDateLayer2")[0].contentWindow.document.getElementById('minute'+t).parentNode;
				otherminute.bgColor ="";
				otherminute.style.backgroundColor='#fff';
				//otherminute.fireEvent('onmouseout');
			}
			var hours = inputhourselect.options;
			
			for(key in hours)
			{
				if(hours[key]&&hours[key].value)
				{
					if(hours[key].value==inputhour)
					{
						hours[key].selected = true;
					}
				}
				
			}
			inputminutetd.bgColor='#BEEBEE';
			inputminutetd.style.backgroundColor='#BEEBEE';
		}
	}
}
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}



function onWPShowTime(spanname,inputname){
   var dads  = document.getElementById("meizzDateLayer2").style;
   setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}



/*********************************
 path: ../workplan/data/CreateCalendarSegment.jsp
*********************************/
function onWorkPlanShowTime(spanname,inputname){
spanname = $("#"+spanname+"")[0];
inputname = $("input[name="+inputname+"]")[0];
	var dads  = document.getElementById("meizzDateLayer2").style;
	var th = spanname;
	var ttop  = $(spanname).offset().top; 
	var thei  = spanname.clientHeight;
	var tleft = $(spanname).offset().left; 
	var ttyp  = spanname.type;       
	while (spanname = $(spanname).offset.parent){
		ttop += $(spanname).offset().top; 
		tleft += $(spanname).offset().left;
	}
	var ttoplast=ttop + thei + 22;
	if(ttyp == "image"){
		ttoplast=ttop + thei + 22;
	}

	try{
	    var bodyclientHeight=document.body.clientHeight;
	    if(parseInt(bodyclientHeight)-parseInt(ttoplast)<250){
			ttoplast-=250;
		}
	}catch(e){
	}


	$("#meizzDateLayer2").css("top", ttoplast);
	$("#meizzDateLayer2").css("left",tleft);
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workflow/request/wfAgentAdd.jsp,wfAgentEdit.jsp
*********************************/
function onshowAgentTime(spanname,inputname){
	spanname = $G(spanname);
	inputname = $G(inputname);
    var dads  = document.getElementById("meizzDateLayer2").style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22+"px";
	dads.left = tleft;                                            
	
	outType = 2;  //添加流程代理
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workflow/request/wfAgentList.jsp
*********************************/
function onlistAgentTime(spanname,inputname){
    var dads  = document.getElementById("meizzDateLayer2").style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;                                            
	
	outType = 3;  //流程代理列表
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../hrm/schedule/HrmScheduleMaintanceEdit.jsp
*********************************/
function onHrmSdTime(spanname,inputname){
    var dads  = document.getElementById("meizzDateLayer2").style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;

	outType = 4;  //考勤维护
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../hrm/train/HrmTrainPlanAdd.jsp
*********************************/
function onTrainPlanTime(spanname,inputname){
    var dads  = document.getElementById("meizzDateLayer2").style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;

	outType = 5;  //培训安排
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workflow/search/WFCustomSearch.jsp
*********************************/
function onSearchWFTime(spanname,inputname){
    var dads  = document.getElementById("meizzDateLayer2").style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../workplan/data/WorkPlanAdd.jsp
*********************************/
function onshowPlanTime(inputname,spanname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}

/*********************************
 path: ../meeting/data/NewMeeting.jsp
*********************************/
function onshowMeetingTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outType = 0;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}