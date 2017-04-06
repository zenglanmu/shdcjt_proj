<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo,weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<html>
<%!
/**
* Created By Charoes Huang On June 1,2004 ，For bug 304
* 
*/
private boolean canAddAssess(String id ,String userid){
	  RecordSet rs = new RecordSet();
	  String sql = "select resourceid from HrmTrainAssess where trainid = '"+id+"'";
	  rs.executeSql(sql);
	  while(rs.next()){
		  if(rs.getString("resourceid").equals(userid)){
			  return false;
		  }
	  }
	  return true;
  }

%>
<%	
int userid = user.getUID();
String trainid = request.getParameter("trainid");
boolean isOperator = TrainComInfo.isOperator(trainid,""+user.getUID());
boolean isActor = TrainComInfo.isActor(trainid,""+user.getUID());
boolean isFinish = TrainComInfo.isFinish(trainid);
boolean canAddAssess = canAddAssess(trainid,""+userid);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6102,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
 if((!isFinish &&canAddAssess)&&(isActor||isOperator)){//只有参与人、组织人、创建人并且还没有考评的才能考评，参与人只有在设定考评日期的情况下才有权限
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
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

<FORM id=weaver name=frmMain action="TrainOtherOperation.jsp" method=post >

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(16144,user.getLanguage())%></TH></TR>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </td>
    <td><%=SystemEnv.getHtmlLabelName(15677,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
  </tr> 
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
  int needchange = 0;
  String sql = "select * from HrmTrainAssess where trainid = "+trainid +" order by id";  
  rs.executeSql(sql);
  while(rs.next()){
    String resourceid = rs.getString("resourceid");
    if(!isOperator &&!ResourceComInfo.isManager(user.getUID(),resourceid)&&!resourceid.equals(""+user.getUID()))
      continue;
    int result = Util.getIntValue(rs.getString("implement"),2);
    String testdate = rs.getString("assessdate");
    String explain = rs.getString("explain");
if(needchange%2==0){
      needchange ++;
%>
  <tr class=datalight>
<%
    }else{
    needchange ++;
%>  
  <tr class=datadark>
<%
    }
%>
    <td>
     <%=ResourceComInfo.getResourcename(resourceid)%>
    </td>
    <td>
     <%if(Util.getIntValue(resourceid,0) == user.getUID() && !isFinish){%>
     <a href="HrmTrainAssessEdit.jsp?id=<%=rs.getString("id")%>">
       <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(result==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(result==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(result==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
     </a>
     <%}else{
     %>
       <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(result==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(result==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(result==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
     <%}%>
    </td>
    <td>
     <%=testdate%>
    </td>
    <td>
      <%=explain%>
    </td>
  </tr>
<%    
  }
%>          
 </TBODY>
</TABLE> 
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type=hidden name=trainid value=<%=trainid%>>
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

 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub
</script>
<script language=javascript>
function dosave(){      
    location="HrmTrainAssessAdd.jsp?trainid=<%=trainid%>";
  } 
 </script>
 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
