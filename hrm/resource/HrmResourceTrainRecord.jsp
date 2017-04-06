<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
AllManagers.getAll(resourceid);
//added by hubo,20060113
if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
boolean isSelf		=	false;
boolean isManager	=	false;
if (resourceid.equals(""+user.getUID()) ){
	isSelf = true;
}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:TrainRecord",user))) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(816,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
<td ></td>
<td valign="top">

<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<% if(HrmUserVarify.checkUserRight("HrmResourceTrainRecordAdd:Add",user)){ %>
<!--<BUTTON class=Btn id=button1 accessKey=A 
onclick='location.href="HrmResourceTrainRecordAdd.jsp?resourceid=<%=resourceid%>"' name=button1><U>A</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>-->
<% } %>

<TABLE class=ListStyle cellspacing=1 >
  <TBODY>   
  <TR class=Header> 
    <TH width="15%" colspan=7><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
  <TR class=Header> 
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></TD>
    <TD width="30%"><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></TD>
    <td width="5%"></td>
  </TR>

<%
int i=0;
RecordSet.executeProc("HrmTrainRecord_SByResourceID",resourceid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String train = RecordSet.getString("traintype");
String trainstartdate = RecordSet.getString("trainstartdate");
String trainenddate = RecordSet.getString("trainenddate");
String traintype = RecordSet.getString("traintype");
String trainunit = RecordSet.getString("trainunit");
int result = Util.getIntValue(RecordSet.getString("trainrecord"));
int test =(int)RecordSet.getFloat("trainhour");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>  
    <td><%=TrainComInfo.getTrainname(train)%></td>
    <td><%=Util.toScreen(trainstartdate,user.getLanguage())%></td>
    <td><%=Util.toScreen(trainenddate,user.getLanguage())%></td>    
    <td>
     <%if(test==0){%><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%> <%}%>
     <%if(test==1){%> <%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%>  <%}%>
     <%if(test==2){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%>   <%}%>
     <%if(test==3){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>   <%}%>
    </td>
    <td> <%=TrainResourceComInfo.getResourcename(trainunit)%></td>
    <td>
       <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(result==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(result==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(result==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
    </td>
    <td><a href="HrmResourceTrainRecordEdit.jsp?paraid=<%=id%>&traintypeid=<%=traintype%>&resourceid=<%=resourceid%>">>>></a></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>

</BODY></HTML>