<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<html>
<%	
String id = request.getParameter("id");

String sql = "select * from HrmTrain where id = "+id;
rs.executeSql(sql);
rs.next();
String summarizer = Util.null2String(rs.getString("summarizer"));
String summarizedate = Util.null2String(rs.getString("summarizedate"));
String fare = Util.null2String(rs.getString("fare"));
String faretype = Util.null2String(rs.getString("faretype"));
String advice = Util.null2String(rs.getString("advice"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(405,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16152,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD>
  </TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16154,user.getLanguage())%> </td>
          <td class=Field>            
            <%=ResourceComInfo.getResourcename(summarizer)%>
	      </td>	   
        </tr> 
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16155,user.getLanguage())%> </td>
          <td class=Field>            
            <%=summarizedate%>
	      </td>	   
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16153,user.getLanguage())%> </td>
          <td class=Field>            
            <%=fare%>
	      </td>	   
        </tr> 
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></td>
          <td class=Field>
          <%=BudgetfeeTypeComInfo.getBudgetfeeTypename(faretype)%>                  
          </td>
        </tr>      
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></td>
          <td class=Field>
             <%=advice%>      
          </td>
        </tr>    
        <TR><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE> 
<input type="hidden" name=operation> 
<input type=hidden name=id value=<%=id%>>
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
sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if Not isempty(id) then
	if id(0)<> 0 then
	faretypespan.innerHtml = id(1)
	frmMain.faretype.value=id(0)
	else
	faretypespan.innerHtml = ""
	frmMain.faretype.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function dosave(){      
    document.frmMain.operation.value="finish";
    document.frmMain.submit();
  } 
 </script>
 
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
