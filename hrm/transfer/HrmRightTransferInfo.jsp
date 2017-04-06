<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
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

boolean CanTran = HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user);
String fromid=Util.null2String(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));
String numberstr=Util.null2String(request.getParameter("numberstr"));
String number[]=Util.TokenizerString2(numberstr,",");
//CRM
int crmallnum=Util.getIntValue(number[0],0);
int crmnum=Util.getIntValue(number[1],0);

//PROJECT
int projectallnum=Util.getIntValue(number[2],0);
int projectnum=Util.getIntValue(number[3],0);

//RESOURCE
int resourceallnum=Util.getIntValue(number[4],0);
int resourcenum=Util.getIntValue(number[5],0);

//DOC
int docallnum=Util.getIntValue(number[6],0);
int docnum=Util.getIntValue(number[7],0);

//Event
int eventAllNum=Util.getIntValue(number[8],0);
int eventNum=Util.getIntValue(number[9],0);

//Cowork
int coworkAllNum=Util.getIntValue(number[10],0);
int coworkNum=Util.getIntValue(number[11],0);
int eventFinishNum = Util.getIntValue(number[12],0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanTran){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/transfer/HrmRightTransfer.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<table class=viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width=24>
  <COL width="15%">
  <COL width="33%">
  <TBODY>
  <TR class=title><TD colSpan=5><B><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></B></TD></TR>
  <TR class=spacing style="height: 1px"><TD class=line1 colSpan=6></TD></TR>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></td>
     <td class=field><%=ResourceComInfo.getResourcename(fromid)%></td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=crmnum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=crmallnum%> )</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></td>
     <td class=field><%=ResourceComInfo.getResourcename(toid)%></td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=projectnum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=projectallnum%> )</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
  <tr>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=resourcenum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=resourceallnum%> )</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=6 ></TD></TR> 
  <tr>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=docnum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=docallnum%> )</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=6 ></TD></TR> 
  <tr>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=eventNum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=eventAllNum%> )</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=6 ></TD></TR> 
  <tr>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
     <td class=field>( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%> <%=coworkNum%>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=coworkAllNum%> )</td>
  </tr>
  
  <TR style="height: 1px"><TD class=Line colSpan=6 ></TD></TR> 
  </tbody>
</table>
<table class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">  
  <TBODY>
  <TR class=Header><TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(80,user.getLanguage())%>(<%=(crmnum+projectnum+resourcenum+docnum+eventNum+coworkNum)%>)</B></TD></TR>
  <tr class=header>
  	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
  	<td><%=SystemEnv.getHtmlLabelName(80,user.getLanguage())%></td>
  </tr>
  <tr class=datalight>
  	<td><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></td>
  	<td><%if(crmnum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=crmnum%><%}%></td>
  </tr>
  <tr class=datadark>
  	<td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
  	<td><%if(projectnum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=projectnum%><%}%></td>
  </tr>
  <tr class=datalight>
  	<td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  	<td><%if(resourcenum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=resourcenum%><%}%></td>
  </tr>
  <tr class=datadark>
  	<td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
  	<td><%if(docnum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=docnum%><%}%></td>
  </tr>
  <tr class=datalight>
    <td><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></td>
    <td><%if(eventNum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=eventFinishNum %><%}%></td>
  </tr>
  <tr class=datadark>
    <td><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
    <td><%if(coworkNum==0){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%><%=coworkNum%><%}%></td>
  </tr>
	<tr class=Header>
		<td colspan=2>
			<font color=red>
				<%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%>:
				<%=SystemEnv.getHtmlNoteName(22,user.getLanguage())%>,<%=SystemEnv.getHtmlNoteName(23,user.getLanguage())%>
				<%=ResourceComInfo.getResourcename(toid)%>
				
				<%
					if("show".equals(session.getAttribute("showTransferMessage")))
					{
						out.print("<br>" + SystemEnv.getHtmlLabelName(18739, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(20404, user.getLanguage()));
					}								
				%>				
			</font>
		</td>
		</td>
	</tr>
  </tbody>
</table>
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
</body>
</html>