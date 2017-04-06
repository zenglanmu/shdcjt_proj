<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;

if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());

char separator = Util.getSeparator() ;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(6156,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=Shadow>
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
    <TH width="15%" colspan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
	<TD width="20%"><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>   
  </TR>

<%
	int i=0;
	String applyworkflowid = "" ;
    rs.executeSql("select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' ");
    if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id"));

    ArrayList al = new ArrayList();
    al = TrainPlanComInfo.getTrainPlanByResource(resourceid);
    for(int j = 0; j<al.size(); j++){
    String trainplanid = (String)al.get(j);

	String createrid = "";
	String planstartdate = "";
	String planenddate = "";
	String organizer = "";
	rs2.executeSql("select * from HrmTrainPlan where id ="+trainplanid);
	while(rs2.next()){
		createrid = Util.null2String(rs2.getString("createrid"));
		organizer = Util.null2String(rs2.getString("planorganizer"));
		planstartdate = Util.null2String(rs2.getString("planstartdate"));
		planenddate = Util.null2String(rs2.getString("planenddate"));
	}
    %>
    <td class=field align=right>
    
                    </td>
                    <%
                   
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
    <td><a href="/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=<%=trainplanid%>"><%=TrainPlanComInfo.getTrainPlanname(trainplanid)%></a></td>
	<td><%=ResourceComInfo.getMulResourcename(organizer)%></td>
	<td><%=planstartdate%></td>
	<td><%=planenddate%></td>
    <td><%if(user.getUID()==Util.getIntValue(resourceid) && !applyworkflowid.equals("")){%><a href="/workflow/request/AddRequest.jsp?workflowid=<%=applyworkflowid%>&TrainPlanId=<%=trainplanid%>"><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%></a><%}%></td>
<%
}
%>
</TR>
  </TBODY> 
</TABLE>

</BODY></HTML>