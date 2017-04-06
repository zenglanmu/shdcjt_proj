<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String urlfrom = Util.null2String(request.getParameter("urlfrom"));
String imagefilename = "/images/hdMaintenance.gif";
DocMouldComInfo.removeDocMouldCache();
String titlename = "";
String log_id = "";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid1= -1;
int operatelevel= 0;
if(detachable==1){
        subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
    	operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldAdd:add",subcompanyid1);
}else{
	if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user) || HrmUserVarify.checkUserRight("DocMould:log", user))
		operatelevel=2;
}
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(64,user.getLanguage());
  log_id ="110";
}else{
  titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(16449,user.getLanguage());
  log_id ="75";
}
if(subcompanyid1==-1 && detachable==1 && urlfrom.equals("hr"))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="Click on the left branch of the Division for the contract template set</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(22176,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
String needfav ="1";
String needhelp ="";
%>
<BODY>


<%@ include file="/systeminfo/TopTitle.jsp" %>


<table width=100%  border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<%
if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user)){
%>
<%
	if(operatelevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16388,user.getLanguage())+",javascript:location='/docs/mouldfile/DocMouldAdd.jsp?urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+"',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%
}
if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+log_id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%}
%>
 
 <TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="30%">
  <COL width="30%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></th>
  </tr>
  <tr class=Line><th></th><th></th><th ></th></tr>
<%
	int id=0;
    String mouldName=null;
	String mouldType=null;

    String sql =null;

    if(urlfrom.equals("hr")){
    	if(detachable==1){
    		sql="select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet where subcompanyid = "+subcompanyid1+") order by mouldType asc,id asc";
    	}else{
			sql="select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet) order by mouldType asc,id asc";
		}
    }else{
		sql="select id,mouldname,mouldType from DocMouldFile WHERE ID NOT IN (Select TEMPLETDOCID From HrmContractTemplet) order by mouldType asc,id asc";
    }
    RecordSet.executeSql(sql);

    boolean isLight = false;
	while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"));
		mouldName=Util.null2String(RecordSet.getString("mouldName"));
		mouldType=Util.null2String(RecordSet.getString("mouldType"));

		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>

		<TD>
		    <a href="DocMouldDsp.jsp?id=<%=id%>&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>"><%=id%></a>
		</TD>
		<TD>
		    <a href="DocMouldDsp.jsp?id=<%=id%>&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>"><%=mouldName%></a>
		</TD>
		<TD>
<%
		
		if(mouldType.equals("0")){
%>
	        HTML&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%
		}else if(mouldType.equals("2")){
%>
	        WORD&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%
		}else if(mouldType.equals("3")){
%>
	        EXCEL&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%
		}else if(mouldType.equals("4")){
%>
	        <%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%
		}else if(mouldType.equals("5")){
%>
	        <%=SystemEnv.getHtmlLabelName(24545,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%
		}
%>
		</TD>
	</TR>
<%
	}

%>
 </TABLE>		
		
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>
 <%@ include file="/systeminfo/RightClickMenu.jsp" %>
 </BODY></HTML>
