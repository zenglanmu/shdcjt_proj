<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.Util,weaver.general.GCONST,weaver.file.Prop,
                 weaver.docs.category.security.AclManager,
                 weaver.docs.category.CategoryTree,
                 weaver.docs.category.CommonCategory" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));

int infoId = Util.getIntValue(request.getParameter("id"),0);
int userid=0;
userid=user.getUID();
Prop prop = Prop.getInstance();
String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));

//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

String selectArr = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this,event),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(18016,user.getLanguage())+",javascript:onNormal(this),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  
  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
	<input name="method" type="hidden" value="addadvanced"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="parentId" type="hidden" value="<%=infoId!=0?""+infoId:""%>">
	<input name="type" type="hidden" value="<%=type%>">
	
	<%-- 图标 --%>
	<INPUT name="customIconUrl" type="hidden" value="<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3.gif<%} else {%>/images/folder.png<%}%>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">

<TABLE class="Shadow">
	<tr>
		<td valign="top">
	    <TABLE class=ViewForm>
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			
			<TBODY>
			
                <TR class=Title>
				  <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
				  <TH><%if(!"3".equals(resourceType)){%><div  align="right"><%=SystemEnv.getHtmlLabelName(20827,user.getLanguage())%><input type="checkbox" value="1" id="chkSynch" name="chkSynch"> &nbsp;</div><%}%></TH>
				</TR>
				<TR class=Spacing style="height: 1px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>

                <%-- 菜单名称 --%>
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customMenuName" value="" onchange="checkinput('customMenuName','Nameimage')">
				  	<SPAN id=Nameimage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>


				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customName_e" value="">				
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%if(GCONST.getZHTWLANGUAGE()==1){ %>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customName_t" value="">				
				  </td>
				</tr>
				<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%} %>

				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%></td>
				  <td class=Field>				  
					<input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow></span>
				  </td>
				</tr>
                <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

		        <%if(infoId==0){%>
	                <tr>
					  <td><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())+SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></td>
					  <td class=Field>				  
						<input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;
					  </td>
					</tr>
					<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%}%>

				<%-- 模块 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></td>
				  <td class=Field>
					<input type="radio" name="customModule" value="1" onClick="onChangeModule(this);" checked><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
					<input type="radio" name="customModule" value="2" onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>
					<input type="radio" name="customModule" value="3" onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>
					<input type="radio" name="customModule" value="4" onClick="onChangeModule(this);"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>
				  </td>
				</tr>
                <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

				<%-- 菜单类型 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></td>
				  <td class=Field>
				  	<select name="customType_1" style="display:block" onChange="onChangeModuleType(this);">
				  		<option value="1" selected><%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%></option>
				  		<option value="2" ><%=SystemEnv.getHtmlLabelName(1212,user.getLanguage())%></option>
				  		<option value="3" ><%=SystemEnv.getHtmlLabelName(16397,user.getLanguage())%></option>
				  		<option value="4" ><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></option>
				  	</select>	
				  	<select name="customType_2" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" selected><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></option>
				  		<option value="2" ><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></option>
				  		<option value="3" ><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%></option>
				  		<option value="4" ><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></option>
						<option value="6" ><%=SystemEnv.getHtmlLabelName(21639,user.getLanguage())%></option>
						<option value="7" ><%=SystemEnv.getHtmlLabelName(21640,user.getLanguage())%></option>
						<%if(!"".equals(hasOvertime)){%>
						<option value="8" ><%=SystemEnv.getHtmlLabelName(21641,user.getLanguage())%></option>
						<%}%>
						<%if(!"".equals(hasChangStatus)){%>
						<option value="9" ><%=SystemEnv.getHtmlLabelName(21643,user.getLanguage())%></option>
						<%}%>
				  		<option value="5" ><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></option>
				  	</select>
				  	<select name="customType_3" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" selected><%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%></option>
				  	</select>
				  	<select name="customType_4" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" selected><%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%></option>
				  		<option value="2" ><%=SystemEnv.getHtmlLabelName(16408,user.getLanguage())%></option>
				  		<option value="3" ><%=SystemEnv.getHtmlLabelName(16409,user.getLanguage())%></option>
				  		<option value="4" ><%=SystemEnv.getHtmlLabelName(16410,user.getLanguage())%></option>
				  		<option value="5" ><%=SystemEnv.getHtmlLabelName(16411,user.getLanguage())%></option>
				  		<option value="6" ><%=SystemEnv.getHtmlLabelName(16412,user.getLanguage())%></option>
				  	</select>
				  </td>
				</tr>
                <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

			</TBODY>
		</TABLE>
		<div id="divContent"></div>
		</TD></TR>
				
			</TBODY>
		</TABLE>
	</td>
	</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

    </FORM>


</body>

<script LANGUAGE="JavaScript">

$(document).ready(function () {
	getData("adddoc");
});

function getData(type){
	$("#divContent").html("<img src=/images/loading2.gif>&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...");
	
	$.get("MenuMaintenanceAddAdvancedGet.jsp",{"type":type}, function(data){
	    $("#divContent").html(data);
	});	
}
function checkSubmit(obj,event){
	<% if(infoId == 0) { %>
	if(check_form(frmmain,'customMenuCName')){
		obj.disabled=true;
		frmmain.submit();
	}
	<% } else { %>
	if(check_form(frmmain,'customMenuName,customMenuLink')){
		//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		event = jQuery.event.fix(event);
		event.target.disabled = true;
		obj.disabled=true;
		frmmain.submit();
	}
	<% } %>
	
}

function onBack(obj){
	location.href="MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onNormal(obj){
	location.href="MenuMaintenanceAdd.jsp?type=<%=type%>&id=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onChangeModule(obj){
	for(var i=1;i<=4;i++){
		var typeObj = eval("frmmain.customType_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var currTypeObj = eval("frmmain.customType_"+obj.value);
	if(currTypeObj!=null){
		currTypeObj.style.display = "block";
		onChangeModuleType(currTypeObj);
	}
}

function onChangeModuleType(obj){
	var splitname = obj.name;
	var typeObj = null;
	for(var i=1;i<=15;i++){
		typeObj = document.getElementById("customSetting_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var splitstrarray = obj.name.split("_");
	var currselect = 0;
	
	if(splitstrarray[1]=="1"&&obj.value=="1"){//新建文档
		getData("adddoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="2"){//我的文档
		getData("mydoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="3"){//最新文档
		getData("newdoc");
	} else if(splitstrarray[1]=="1"&&obj.value=="4"){//文档目录
		getData("doccategory");
	} else if(splitstrarray[1]=="2"&&obj.value=="1"){//新建流程
		getData("addwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="2"){//待办事宜
		getData("waitdowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="3"){//已办事宜
		getData("donewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="4"){//办结事宜
		getData("alreadydowf");
	} else if(splitstrarray[1]=="2"&&obj.value=="5"){//我的请求
		getData("mywf");
	} else if(splitstrarray[1]=="3"&&obj.value=="1"){//新建客户
		getData("addcus");
	} else if(splitstrarray[1]=="4"&&obj.value=="1"){//新建项目
		getData("addproject");
	} else if(splitstrarray[1]=="4"&&obj.value=="2"){//项目执行

	} else if(splitstrarray[1]=="4"&&obj.value=="3"){//审批项目

	} else if(splitstrarray[1]=="4"&&obj.value=="4"){//审批任务

	} else if(splitstrarray[1]=="4"&&obj.value=="5"){//当前任务

	} else if(splitstrarray[1]=="4"&&obj.value=="6"){//超期任务

	} else if(splitstrarray[1]=="2"&&obj.value=="6"){//抄送事宜
		getData("sendwf");
	} else if(splitstrarray[1]=="2"&&obj.value=="7"){//督办事宜
		getData("supervisewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="8"){//超时事宜
		getData("overtimewf");
	} else if(splitstrarray[1]=="2"&&obj.value=="9"){//反馈事宜
		getData("backwf");
	}
}


function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}

</script>

</html>

