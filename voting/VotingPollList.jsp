<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = Util.toScreen("网上调查",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";
boolean canview = false ;
boolean canedit = false ;

canview=HrmUserVarify.checkUserRight("Voting:Maint", user);
canedit=HrmUserVarify.checkUserRight("Voting:Maint", user);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<DIV class=HdrProps></DIV>

<TABLE class=ListShort>
  <COLGROUP>
  <COL width="40%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th>名称</th>
  <th>创建人</th>
  <th>创建日期</th>
  <th>投票人数</th>
  <th>当前状态</th>
  </tr>
  <%
boolean islight=true ;
String sql="";
sql="select t1.* from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+userid+" and t1.status!=0 order by t1.status,t1.begindate desc";
RecordSet.executeSql(sql);
     
while(RecordSet.next()){
	String votingid=RecordSet.getString("id");
	String subject = RecordSet.getString("subject");
    String begindate=RecordSet.getString("begindate");
    String begintime=RecordSet.getString("begintime");
    String createrid=RecordSet.getString("createrid");
    String votingcount=RecordSet.getString("votingcount");
    String status = RecordSet.getString("status");
%> 
  <TR <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>>
  <td><A href="VotingPoll.jsp?votingid=<%=votingid%>"><%=subject%></A></td>
  <td><%=ResourceComInfo.getResourcename(createrid)%></td>
  <td><%=begindate%></td>
  <td><%=votingcount%></td>
  <td>
  <%if(status.equals("1")){%>进行<%}%>
  <%if(status.equals("2")){%>结束<%}%>
  </td>
  </tr>
<%
    islight=!islight ;
}
%>
</table>

</BODY></HTML>