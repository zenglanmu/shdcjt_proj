<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"  %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST"  %>
<%@ page import="weaver.file.Prop"  %>
<%@page import="java.net.*"%>
<link href='/css/Weaver.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver.js'></script>
<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<%
 String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
 String eid = Util.null2String(request.getParameter("eid"));
 String tabId = Util.null2String(request.getParameter("tabId"));
 String tabTitle = Util.null2String(request.getParameter("tabTitle"));	
 tabTitle = URLDecoder.decode(tabTitle, "utf-8");
 String showCopy = Util.null2String(request.getParameter("showCopy"));
 int completeflag = 0;
 if(!"1".equals(showCopy)){
	 showCopy = "0";
 }
try {

int viewType=1;	

//int isExclude=0;
RecordSet rs=new RecordSet();
rs.executeSql("select * from hpsetting_wfcenter where eid="+eid+" and tabid="+tabId);
if(rs.next()){ 
	viewType=rs.getInt("viewType");
	completeflag=rs.getInt("completeflag");
	tabTitle = rs.getString("tabtitle");
//	isExclude=rs.getInt("isExclude");			
}else{
	if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		if (tabAddList.containsKey(tabId)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
			viewType = Util.getIntValue((String) tabInfo.get("viewType"));
			completeflag = Util.getIntValue((String) tabInfo.get("completeflag"));
		}
	}
}



String radViewType_1="  ";
String radViewType_2="  ";
String radViewType_3="  ";
String radViewType_4="  "; 
String radViewType_5="  "; 
String radViewType_6="  "; 
String radViewType_7="  "; 
String radViewType_8="  "; 
String showCopyDivDispaly = "none";
String showCopyChecked = "";
String showMyrequestDivDispaly = "none";
if(viewType==1){ 
	radViewType_1=" selected ";
	showCopyDivDispaly = "";
	if("0".equals(showCopy)){
		showCopyChecked = "";
	}else{
		showCopyChecked = "checked";
	}
}
else if(viewType==2) radViewType_2=" selected ";
else if(viewType==3) radViewType_3=" selected ";
else if(viewType==4) radViewType_4=" selected ";
else if(viewType==5) radViewType_5=" selected ";
else if(viewType==6) radViewType_6=" selected ";
else if(viewType==7) radViewType_7=" selected ";
else if(viewType==8) radViewType_8=" selected ";		

String isselected_0 = " selected ";
String isselected_1 = "";
String isselected_2 = "";
String myrequestselect = "";
if(viewType==4){
    showMyrequestDivDispaly = "";
    if(completeflag==1){
        isselected_0 = "";
        isselected_1 = " selected ";
        isselected_2 = "";
    }else if(completeflag==2){
        isselected_0 = "";
        isselected_1 = "";
        isselected_2 = " selected ";
    }
}

//String strExclude1="";
//String strExclude2="";
//if(isExclude==0){
//	strExclude1=" selected ";
//} else {
//	strExclude2=" selected ";
//}

Prop prop = Prop.getInstance();
String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
String returnStr = "";
String spanDisplay ="";
if(!tabTitle.equals("")){
	spanDisplay ="none";
}
returnStr +="<body onload=load()><table class='viewForm'><TR><TD CLASS=LINE COLSPAN=2></TD></TR><TR valign=top><TD>"+SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId))+"</TD><TD class=field><input class=inputStyle id='tabTitle_"+eid+"' type='text' value=\""+Util.toHtml2(tabTitle.replaceAll("&","&amp;"))+"\" onchange='checkinput(\"tabTitle_"+eid+"\",\"tabTitleSpan_"+eid+"\")' /><SPAN id='tabTitleSpan_"+eid+"'>";
if(tabTitle.equals("")){
	returnStr+="<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
}
returnStr+="</SPAN></TD></TR>";
returnStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";

returnStr+="<TR   valign=top><TD>"+SystemEnv.getHtmlLabelName(17483,Util.getIntValue(userLanguageId))+"<!--查看类型--></TD>" +
		"<TD class=field>" +
		"<input type='hidden' name=_whereKey_"+eid+" value=''>"+
		"<select name='radViewType_"+eid+"' id='radViewType_"+eid+"' onchange='onViewTypeChange(this,"+eid+")'>" +
				"<option value='1' "+radViewType_1+">"+SystemEnv.getHtmlLabelName(1207,Util.getIntValue(userLanguageId))+"</option>" +  //待办事宜
				"<option value='2' "+radViewType_2+">"+SystemEnv.getHtmlLabelName(17991,Util.getIntValue(userLanguageId))+"</option>" +  //已办事宜
				"<option value='3' "+radViewType_3+">"+SystemEnv.getHtmlLabelName(17992,Util.getIntValue(userLanguageId))+"</option>" +  //办结事宜
				"<option value='4' "+radViewType_4+">"+SystemEnv.getHtmlLabelName(1210,Util.getIntValue(userLanguageId))+"</option>" +  //我的请求
				"<option value='5' "+radViewType_5+">"+SystemEnv.getHtmlLabelName(21639,Util.getIntValue(userLanguageId))+"</option>" +  //抄送事宜
				"<option value='6' "+radViewType_6+">"+SystemEnv.getHtmlLabelName(21640,Util.getIntValue(userLanguageId))+"</option>";  //督办事宜
 if(!"".equals(hasOvertime)){
	 returnStr+="<option value='7' "+radViewType_7+">"+SystemEnv.getHtmlLabelName(21641,Util.getIntValue(userLanguageId))+"</option>";  //超时事宜
 }
 
 if(!"".equals(hasChangStatus)){
	 returnStr+="<option value='8' "+radViewType_8+">"+SystemEnv.getHtmlLabelName(21643,Util.getIntValue(userLanguageId))+"</option>";  //反馈事宜
 }			
				
 returnStr+="</select>" ;
 returnStr+="<span id='showCopySpan_"+eid+"' style='display:"+showCopyDivDispaly+"'>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(89,Util.getIntValue(userLanguageId))+SystemEnv.getHtmlLabelName(21639,Util.getIntValue(userLanguageId))+"<input type=checkbox  "+showCopyChecked+" name=showCopy_"+eid+" id=showCopy_"+eid+" onclick='onShowCopyClick(this)'></span>";
 returnStr+="<span id='myrequestSpan_"+eid+"' style='display:"+showMyrequestDivDispaly+"'><select id='completeflag_"+eid+"' onchange='setCompleteFlag(this.value)'><option value=0 "+isselected_0+"></option><option value=1 "+isselected_1+">"+SystemEnv.getHtmlLabelName(732,Util.getIntValue(userLanguageId))+"</option><option value=2 "+isselected_2+">"+SystemEnv.getHtmlLabelName(1961,Util.getIntValue(userLanguageId))+"</option></select></span>";
 returnStr+="</TD></TR><TR><TD CLASS=LINE COLSPAN=2></TD></TR>";


returnStr+="<TR   valign=top><TD>"+SystemEnv.getHtmlLabelName(21672,Util.getIntValue(userLanguageId))+"</TD><!--流程来源-->" +
		"<TD class=field>" +
		"<iframe  style='overflow-x:yes;'BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE id='ifrmViewType_"+eid+"' name='ifrmViewType_"+eid+"' width='100%' height='300px'  scrolling='auto'" +
		" src='/homepage/element/setting/WorkflowCenterBrowser.jsp?tabId="+tabId+"&viewType="+viewType+"&eid="+eid+"&random="+Math.random()+"'></iframe>" +
			"<TD></TR><TR><TD CLASS=LINE COLSPAN=2></TD></TR></table></body>" ;

//returnStr+="<TR   valign=top><TD>显示方式</TD><!--显示方式-->" +
//"<TD class=field>" +
//"<select  name='isExclude_"+eid+"' id='isExclude_"+eid+"'><option value='0' "+strExclude1+">显示所选类型流程</option><option value='1' "+strExclude2+">排除所选类型流程</option></select>" +
//	"<TD></TR>" ;
out.print(returnStr);
} catch (Exception e) {			
e.printStackTrace();
}

%>

<SCRIPT LANGUAGE="JavaScript">

	function load(){
		<%if("1".equals(showCopy)){%>
			window.frames["ifrmViewType_<%=eid%>"].document.getElementById("showCopy").value = "1"; 
		<%}%>
	}

	function onViewTypeChange(obj,eid){	
		
		if(obj.value=='1'){
			document.getElementById("showCopySpan_<%=eid%>").style.display=''
			document.getElementById("myrequestSpan_<%=eid%>").style.display='none'
		}else if(obj.value=='4'){
			document.getElementById("showCopySpan_<%=eid%>").style.display='none'
			document.getElementById("myrequestSpan_<%=eid%>").style.display=''
		}else{
			document.getElementById("showCopySpan_<%=eid%>").style.display='none'
			document.getElementById("myrequestSpan_<%=eid%>").style.display='none'
		}
		document.getElementById("ifrmViewType_"+eid).src="/homepage/element/setting/WorkflowCenterBrowser.jsp?viewType="+obj.value+"&eid="+eid+"&tabId=<%=tabId%>&showCopy=<%=showCopy%>&completeflag=<%=completeflag%>";
		//alert(obj.value)
	}
	
	function onShowCopyClick(obj){
		if(obj.checked){
			window.frames["ifrmViewType_<%=eid%>"].document.getElementById("showCopy").value = "1"; 
			
		}else{
			window.frames["ifrmViewType_<%=eid%>"].document.getElementById("showCopy").value = "0";
		}
	}
	
	function setCompleteFlag(flagValue){
	    window.frames["ifrmViewType_<%=eid%>"].document.getElementById("completeflag").value = flagValue; 
	}
  
  </SCRIPT>

