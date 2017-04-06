<%@ page language="java" contentType="text/html; charset=GBK" %>
<%-- 
	Modified By Charoes Huang ,June 3,2004 ,FOR Bug 118
--%>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(385,user.getLanguage())+SystemEnv.getHtmlLabelName(80,user.getLanguage());
String needfav ="1";
String needhelp ="";

String fromid=Util.null2String(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));
int type=Util.getIntValue(request.getParameter("type"),0);
int crmallnum=Util.getIntValue(request.getParameter("crmallnum"),0);
int projectallnum=Util.getIntValue(request.getParameter("projectallnum"),0);
int resourceallnum=Util.getIntValue(request.getParameter("resourceallnum"),0);
int docallnum=Util.getIntValue(request.getParameter("docallnum"),0);
int eventAllNum=Util.getIntValue(request.getParameter("eventAllNum"),0);  //apollo
int coworkAllNum=Util.getIntValue(request.getParameter("coworkAllNum"),0);

String crmidstr=Util.null2String(request.getParameter("crmidstr"));
//{modified by chengfeng.han 2011-7-4 start  22692 
String crmtype=Util.null2String(request.getParameter("crmtype"));
String crmstatus=Util.null2String(request.getParameter("crmstatus"));
//end}
//{modified by chengfeng.han 2011-7-5 start  22692 
String projecttype=Util.null2String(request.getParameter("projecttype"));
String projectstatus=Util.null2String(request.getParameter("projectstatus"));
String worktype=Util.null2String(request.getParameter("worktype"));
//end}
String projectidstr=Util.null2String(request.getParameter("projectidstr"));
String resourceidstr=Util.null2String(request.getParameter("resourceidstr"));
String docidstr=Util.null2String(request.getParameter("docidstr"));
String eventIDStr=Util.null2String(request.getParameter("eventIDStr"));//apollo
String coworkIDStr=Util.null2String(request.getParameter("coworkIDStr"));

ArrayList crmids=new ArrayList();
ArrayList projectids=new ArrayList();
ArrayList resourceids=new ArrayList();
ArrayList docids=new ArrayList();
ArrayList eventIDs=new ArrayList();//apollo
ArrayList coworkIDs=new ArrayList();

String crmall=Util.null2String(request.getParameter("crmall"));
String projectall=Util.null2String(request.getParameter("projectall"));
String resourceall=Util.null2String(request.getParameter("resourceall"));
String docall=Util.null2String(request.getParameter("docall"));
String eventAll=Util.null2String(request.getParameter("eventAll"));//apollo
String coworkAll=Util.null2String(request.getParameter("coworkAll"));

String crmallFlag=Util.null2String(request.getParameter("crmallFlag"));
String projectallFlag=Util.null2String(request.getParameter("projectallFlag"));
String resourceallFlag=Util.null2String(request.getParameter("resourceallFlag"));
String docallFlag=Util.null2String(request.getParameter("docallFlag"));
String eventAllFlag=Util.null2String(request.getParameter("eventAllFlag"));//apollo
String coworkAllFlag=Util.null2String(request.getParameter("coworkAllFlag"));

if(crmallFlag.equals("0")){
    crmall = "0";
}
if(projectallFlag.equals("0")){
    projectall = "0";
}
if(resourceallFlag.equals("0")){
    resourceall = "0";
}
if(docallFlag.equals("0")){
    docall = "0";
}
if(eventAllFlag.equals("0")){
    eventAll = "0";
}
if(coworkAllFlag.equals("0")){
    coworkAll = "0";
}

int i=0;
int j=0;
%>
<BODY onload="showdata()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//{modified by chengfeng.han 2011-7-4 start  22692 
//如果是crm模块的话，改刷新为搜索
if(type == 1 || type == 2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(),_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doRefresh(),_self} " ;
}
//end}
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+",javascript:CheckAll(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onreset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<TABLE class=Shadow>
<tr>
<td valign="top">

<form id=frmmain1 name=frmmain1 method=post action="HrmRightTransfer.jsp">

<input type=hidden name="fromid" value="<%=fromid%>">
<input type=hidden name="toid" value="<%=toid%>">
<input type=hidden name="crmidstr" value="<%=crmidstr%>">
<!--Add by chengfeng.han 2011-7-4 Start 22692 -->
<input type=hidden name="h_crmtype" value="<%=crmtype%>">
<input type=hidden name="h_crmstatus" value="<%=crmstatus%>">
<!--Add by chengfeng.han 2011-7-4 end  22692-->
<!--Add by chengfeng.han 2011-7-5 Start 22692 -->
<input type=hidden name="h_projecttype" value="<%=projecttype%>">
<input type=hidden name="h_projectstatus" value="<%=projectstatus%>">
<input type=hidden name="h_worktype" value="<%=worktype%>">
<!--Add by chengfeng.han 2011-7-5 end  22692-->

<input type=hidden name="projectidstr" value="<%=projectidstr%>">
<input type=hidden name="resourceidstr" value="<%=resourceidstr%>">
<input type=hidden name="docidstr" value="<%=docidstr%>">
<input type=hidden name="eventIDStr" value="<%=eventIDStr%>"><!-- apollo-->
<input type=hidden name="coworkIDStr" value="<%=coworkIDStr%>">

<input type=hidden name="crmall" value="<%=crmall%>">
<input type=hidden name="projectall" value="<%=projectall%>">
<input type=hidden name="resourceall" value="<%=resourceall%>">
<input type=hidden name="docall" value="<%=docall%>">
<input type=hidden name="eventAll" value="<%=eventAll%>"><!-- apollo-->
<input type=hidden name="coworkAll" value="<%=coworkAll%>">

<input type=hidden name="crmallnum" value="<%=crmallnum%>">
<input type=hidden name="projectallnum" value="<%=projectallnum%>">
<input type=hidden name="resourceallnum" value="<%=resourceallnum%>">
<input type=hidden name="docallnum" value="<%=docallnum%>">
<input type=hidden name="eventAllNum" value="<%=eventAllNum%>"><!-- apollo-->
<input type=hidden name="coworkAllNum" value="<%=coworkAllNum%>">

<input type=hidden name="type" value="<%=type%>">
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmRightTransferDetailData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    //Add by chengfeng.han 2011-7-4 Start 22692
    var ctype = $GetEle("h_crmtype").value;
    var cstatus = $GetEle("h_crmstatus").value;
	    //Add by chengfeng.han 2011-7-5 Start 22692
	    var ptype = $GetEle("h_projecttype").value;
	    var pstatus = $GetEle("h_projectstatus").value;
	    var worktype = $GetEle("h_worktype").value;
	    //end
    ajax.send("type=<%=type%>&fromid=<%=fromid%>&resourceallnum=<%=resourceallnum%>&resourceidstr=<%=resourceidstr%>"
    		+"&docallnum=<%=docallnum%>&docidstr=<%=docidstr%>&crmallnum=<%=crmallnum%>&crmidstr=<%=crmidstr%>"
    		+"&projectallnum=<%=projectallnum%>&projectidstr=<%=projectidstr%>&eventAllNum=<%=eventAllNum%>"
    		+"&eventIDStr=<%=eventIDStr%>&coworkAllNum=<%=coworkAllNum%>&coworkIDStr=<%=coworkIDStr%>" 
    		+"&crmtype=" + ctype + "&crmstatus=" + cstatus
    		+"&projecttype=" + ptype + "&projectstatus=" + pstatus + "&worktype=" + worktype
    		 );
    //ajax.send("type=<%=type%>&fromid=<%=fromid%>&resourceallnum=<%=resourceallnum%>&resourceidstr=<%=resourceidstr%>&docallnum=<%=docallnum%>&docidstr=<%=docidstr%>&crmallnum=<%=crmallnum%>&crmidstr=<%=crmidstr%>&projectallnum=<%=projectallnum%>&projectidstr=<%=projectidstr%>&eventAllNum=<%=eventAllNum%>&eventIDStr=<%=eventIDStr%>&coworkAllNum=<%=coworkAllNum%>&coworkIDStr=<%=coworkIDStr%>");
    //end
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("showdatadiv").innerHTML=ajax.responseText;
                <%if(docall.equals("1")){%> 
                <%}%>
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<div id="showdatadiv">
	<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
	<tr>
			<td align="center" valign="center">
				<fieldset style="width:100%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
			</td>
	</tr>
	</table>
</div>
</form>
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

<script language=javascript>
function onreset() {
 frmmain1.reset();
}

	function selectDone(){
		o = document.getElementsByName("ids");
        len=o.length;
		var i=0;
		var tempvalue="";
        var checkedAll = true;
        var checknum=0;
        for( i=0; i<len; i++) {

				if(o[i].checked){
					tempvalue=tempvalue+o[i].value+",";
                    checknum++;
                }
                else{
                    checkedAll = false;
                }

		}
		
		tempvalue=tempvalue.substring(0,tempvalue.length-1);
		if(<%=type%>==4) {
            frmmain1.docidstr.value=tempvalue;
            if(frmmain1.docallnum.value==checknum){
                frmmain1.docall.value = "1";
            }else{
                frmmain1.docall.value = "0";
            }
        }
		if(<%=type%>==1) {
            frmmain1.crmidstr.value=tempvalue;
            if(frmmain1.crmallnum.value==checknum){
                frmmain1.crmall.value = "1";
            }else{
                frmmain1.crmall.value = "0";
            }
        }
		if(<%=type%>==2) {
            frmmain1.projectidstr.value=tempvalue;
            if(frmmain1.projectallnum.value==checknum){
                frmmain1.projectall.value = "1";
            }else{
                frmmain1.projectall.value = "0";
            }
        }
		if(<%=type%>==3) {
            frmmain1.resourceidstr.value=tempvalue;
            if(frmmain1.resourceallnum.value==checknum){
                frmmain1.resourceall.value = "1";
            }else{
                frmmain1.resourceall.value = "0";
            }
        }
       if(<%=type%>==5) {
            frmmain1.eventIDStr.value=tempvalue;
            
            if($GetEle("eventAllNum").value==checknum){
            	
                frmmain1.eventAll.value = "1";
            }else{
            	
                frmmain1.eventAll.value = "0";
            }
            
        }
       if(<%=type%>==6) {
            frmmain1.coworkIDStr.value=tempvalue;
            if($GetEle("coworkAllNum").value==checknum){
                frmmain1.coworkAll.value = "1";
            }else{
                frmmain1.coworkAll.value = "0";
            }
        }

		frmmain1.submit();
	}
	function CheckAll() {
		o = document.getElementsByName("ids");
        len=o.length;
        for( i=0; i<len; i++) {

                o[i].checked=true;

        }
	}
	function doRefresh(){
		frmmain1.action="HrmRightTransferDetail.jsp";
		o = document.getElementsByName("ids");
        len=o.length;
		var i=0;
		var tempvalue="";
		for( i=0; i<len; i++) {

				if(o[i].checked)
					tempvalue=tempvalue+o[i].value+",";
		}
		tempvalue=tempvalue.substring(0,tempvalue.length-1);
 
		if(<%=type%>==4) frmmain1.docidstr.value=tempvalue;
		//modified by chengfeng.han 2011-7-5 start 22692
		if(<%=type%>==1) frmmain1.crmidstr.value=tempvalue;
		if(<%=type%>==2) frmmain1.projectidstr.value=tempvalue;
		//end
		if(<%=type%>==3) frmmain1.resourceidstr.value=tempvalue;
        if(<%=type%>==5) frmmain1.eventIDStr.value=tempvalue;
        if(<%=type%>==6) frmmain1.coworkIDStr.value=tempvalue;
		frmmain1.submit();
	}
</script>
</body>
</html>