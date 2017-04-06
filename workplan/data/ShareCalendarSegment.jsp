<%@ page language="java" contentType="text/html; charset=GBK" %> 

<DIV id="workPlanShareSplash" style="display:none;padding:10px;overflow-y:scroll;height: 450px;">


<DIV id="workPlanShareSetSplash" >

<TABLE class="ViewForm">
<INPUT type="hidden" id="workPlanArrayIdShare" name="workPlanArrayIdShare" value="">
<COLGROUP>
	<COL width="30%">
	<COL width="40%">
	<COL width="30%">
<TBODY>
<!--================== 共享类型选择 ==================-->
	
<TR>					  
	<TD>
		<SELECT id="shareTypeShare" name="shareTypeShare" onchange="onChangeShareType()" class=InputStyle>
			<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
			<OPTION value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
			<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
			<OPTION value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
			<OPTION value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
		</SELECT>
	</TD>
	<TD class=field colSpan=2>
		<button type="button" class="Browser" id="shareIdShareBtn" onclick="onShowShareResource('shareIdShare','shareIdShareSpan',event)"  ></button>
		<INPUT  id="shareIdShare" type="hidden" name="shareIdShare" value=""  />
		<span id="shareIdShareSpan"></span>
	</TD>		
</TR>				
<tr id="roleLevelSpanShare">
	<td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:</td>
	<td>
			<SELECT id="roleLevelShare" name="roleLevelShare" class=InputStyle>
				<OPTION value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<OPTION value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<OPTION value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
	</td>
</tr>			
<TR style="height:1px;">
	<TD class=Line colSpan=2  style="padding:0;"></TD>
</TR>
<tr id="secLevelSpanShare">
	<td>
	<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
	
	</td>
	<td>
	<INPUT class=InputStyle id="secLevelShare" name="secLevelShare" maxLength=3 size=5 onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('secLevelShare');checkinput('secLevelShare','secLevelImageShare')" value="10">
	<SPAN id="secLevelImageShare" name="secLevelImageShare"></SPAN>
	</td>
</tr>
<TR style="height:1px;">
	<TD class=Line colSpan=2  style="padding:0;"></TD>
</TR>
<!--================== 共享级别 ==================-->
<TR>
	<TD>
		<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
	</TD>
	<TD class=field>
		<SELECT id="shareLevelShare" name="shareLevelShare" class=InputStyle>
			<OPTION value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>									  
			<OPTION value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>						
		</SELECT>
	</TD>
	<TD class=field>
		<!--============ 按钮 ============-->					
		<button id="addShareBtn" type="button" Class=Btn type=button onclick="addShare()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
 	</TD>		
</TR>
	
<TR style="height:1px;">
	<TD class=Line colSpan=2  style="padding:0;"></TD>
</TR>
</TABLE>
<BR>
</DIV>

<DIV id="workPlanShareListSplash">
<!--================== 共享列表 ==================-->
<TABLE name="workPlanShareListTable" id="workPlanShareListTable" class="ViewForm">
	<COLGROUP> 
		<COL width="25%"> 
		<COL width="65%"> 
		<COL width="10%"> 
	<TBODY> 
	<TR class=Title> 
		<TH><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></TH>
		<TD align="right" colspan="2">&nbsp;</TD>
	</TR>
	<TR class="Spacing" style="height:1px;"> 
		<TD class="Line1" colspan="3" style="padding:0;"></TD>
	</TR>
	

	</TBODY>
</TABLE>
</DIV>


</DIV>

<SCRIPT language="JavaScript">
function onShowShareResource(inputname,spanname,e){
	changeUrl(inputname,spanname,e);
}
function changeUrl(inputname,spanname,e) 
{
	var thisValue = $("#shareTypeShare").val();
	//$("input[name=shareIdShare]").val("");
	//$("#shareIdShareSpan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	$("#secLevelSpanShare").show();
	$("#roleLevelSpanShare").hide();
	
	$("#multiHumanResourceShare").hide();
	$("#multiDepartmentShare").hide();
	$("#singleRoleShare").hide();
	$("#multiSubcompanyShare").hide();
	
	$("input[name=secLevelShare]").val(10);
	$("#shareIdShareBtn").show();
	//人力资源
	if(1 == thisValue)
	{
		
		$("#secLevelSpanShare").hide();
		onShowResource(inputname,spanname);
	}	
	//部门
	else if(2 == thisValue)
	{
		onShowDepartment(inputname,spanname);
	}	
	//角色
	else if(3 == thisValue)
	{
 		$("#singleRoleShare").show();
		$("#roleLevelSpanShare").show();
		onShowRole(inputname,spanname);
	}
    //所有人
	else if(4 == thisValue)
	{
		$("#shareIdShareBtn").hide();
		$("#shareIdShare").val("-1");
		$("#shareNameShare").html("");
	}	
	//分部
	else if(5 == thisValue){
 		//$("multiSubcompanyShare").style.display = "";
		onShowSubcompany(inputname,spanname);
	}
}
function onChangeShareType() 
{
var thisValue = $("#shareTypeShare").val();
	
	$("input[name=shareIdShare]").val("");
	$("#shareIdShareSpan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	$("#secLevelSpanShare").show();
	$("#roleLevelSpanShare").hide();
	
	$("#multiHumanResourceShare").hide();
	$("#multiDepartmentShare").hide();
	$("#singleRoleShare").hide();
	$("#multiSubcompanyShare").hide();
	
	$("input[name=secLevelShare]").val(10);
	$("#shareIdShareBtn").show();

	//人力资源
	if(1 == thisValue)
	{
		$("#secLevelSpanShare").hide();
	}	
	//部门
	else if(2 == thisValue)
	{
	}	
	//角色
	else if(3 == thisValue)
	{
		$("#roleLevelSpanShare").show();
	}
    //所有人
	else if(4 == thisValue)
	{
		$("#shareIdShareBtn").hide();
		$("#shareIdShare").val("-1");
		$("#shareIdShareSpan").html("");
	}	
	//分部
	else if(5 == thisValue)
	{
	}
}
function addShare(){
	if($.trim($("#shareIdShare").val())==""){
		alert("请检查必填项");
		return;
	}
	var param={
			 method:"addCalendarShare"
			 ,id:$("#workPlanArrayIdShare").val()
			 ,shareType:$("#shareTypeShare").val()
			 ,shareId:$("#shareIdShare").val()
			 ,roleLevel:$("#roleLevelShare").val()
			 ,secLevel:$("#secLevelShare").val()			 
			 ,shareLevel:$("#shareLevelShare").val()
	}
	$.post("WorkPlanViewOperation.jsp",param,function(data){
		if(data.isSuccess){
			var shareType = $("#shareTypeShare").val();

			var oRow = $("#workPlanShareListTable")[0].insertRow(-1);		        
			var oCell;
			var oDiv;

			oRow.setAttribute("shareId", data.shareId);

			/* 类型 */
			oCell = oRow.insertCell(-1);
		    oDiv = document.createElement("div");        
		    oDiv.innerHTML = $($("#shareTypeShare")[0].options[$("#shareTypeShare")[0].selectedIndex]).text();
		    oCell.appendChild(oDiv);
		    
		    /* 内容 */
			var content = "";	
			//框
			if(4 != shareType)
			{
				content += $("#shareIdShareSpan").text();
			}	
			//角色
			if(3 == shareType)
			{	content += " ";
				content += $($("#roleLevelShare")[0].options[$("#roleLevelShare")[0].selectedIndex]).text();
			}		
			//安全级别
			if(1 != shareType)
			{
				if(4 != shareType)
				{
					content += " / ";
				}
				content += "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>";
				content += " : ";
				content += $("#secLevelShare").val();
			}	
			//查看编辑
			content += " / ";
			content += $($("#shareLevelShare")[0].options[$("#shareLevelShare")[0].selectedIndex]).text();
			
		    oCell = oRow.insertCell(-1);
		    oCell.className = "Field";
		    oDiv = document.createElement("div");
		    oDiv.innerHTML = content;        
		    oCell.appendChild(oDiv);

			/* 删除 */
		    oCell = oRow.insertCell(-1);
		    oCell.className = "Field";
		    oDiv = document.createElement("div");        
		    oDiv.innerHTML = "<A href='javascript:void(0)' onclick='doDelete(" + data.shareId + ")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>"
		    oCell.appendChild(oDiv);
		       
		    //下划线
		    oRow = $("#workPlanShareListTable")[0].insertRow(-1);
		    oRow.style.height="1px";
		    oCell = oRow.insertCell(-1);
		    oCell.setAttribute("colSpan", 3);
		    
		    oCell.className = "Line";
		    $(oCell).css("padding","0");
		    resizeDialog2();
		    
		    if(shareType!=4){
		       jQuery("#shareIdShareSpan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		       jQuery("#shareIdShare").val("");
		    }   
		}
		
		
	},"json");
}
function fillShare(eventId){
	 $("#shareTypeShare").val(2)
	 onChangeShareType();
	 $("#workPlanArrayIdShare").val(eventId);
	 /*
	 var table=$("#workPlanShareListTable")[0];
	 for(var i=2;i<table.rows.length-1;i++){
		$(table.rows[i]).remove();
	 }
	 */
	 $("#workPlanShareListTable").find("tr:gt(1)").remove();
	var param={
		method:"getCalendarShare",
		id:eventId
	}
	$.post("WorkPlanViewOperation.jsp",param,function(shareInfo){
		var table=$("#workPlanShareListTable")[0];
		var data=shareInfo.data;
		for(var i=0;i<data.length;i++){
			var row=table.insertRow(-1);
			row.setAttribute("shareId",data[i].shareId);
			var cell1=row.insertCell(-1);
			$(cell1).html(data[i].shareTypeName);
			var cell2=row.insertCell(-1);
			$(cell2).attr("class","Field");
			$(cell2).html(data[i].shareContent);
			var cell3=row.insertCell(-1);
			$(cell3).attr("class","Field");
			$(cell3).html("<a onclick=\"doDelete("+data[i].shareId+")\" href=\"javascript:void(0)\">删除</a>");
			var rowLine=table.insertRow(-1);
			$(rowLine).css("height","1px");
			var cellLine=rowLine.insertCell(-1);
			cellLine.setAttribute("class","Line");
			cellLine.setAttribute("colSpan","3");
			$(cellLine).css("padding","0");
		}
		resizeDialog2();
	},"json");
}

function doDelete(shareId){
	var param={
		method:"deleteCalendarShare",
		id:shareId
	};
	$.post("WorkPlanViewOperation.jsp",param,function(data){
		if(data.IsSuccess){
			var curRow=$("tr[shareId="+shareId+"]");
			curRow.next().remove();
			curRow.remove();
			resizeDialog2();
		}else{
			alert("删除失败");
		}
	},"json");
}
function resizeDialog2(){
	var curHeight=$("#workPlanShareSplash").height();
	dialog2.setSize(dialog2.Width,curHeight<400?400:curHeight+20);
}

function onShowSubcompany(inputname,spanname)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}


function onShowRole(inputename,tdname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}

</SCRIPT>
