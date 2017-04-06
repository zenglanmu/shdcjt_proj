<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/jquery/jquery.js"></script>
</HEAD>
<%

String CustomerID=Util.null2String(request.getParameter("CustomerID"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6070,user.getLanguage()) + ":" + CustomerInfoComInfo.getCustomerInfoname(CustomerID);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String needfav ="1";
String needhelp ="";

String name="";
String proportionstr="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("CRM_Evaluation_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 proportionstr=Util.null2String(RecordSet.getString("proportion"));
	}
}

%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6070,user.getLanguage())+",javascript:doSubmit(),_top} " ;
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
		<%if(!isfromtab) {%>
		<TABLE class=Shadow>
		<%}else {%>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

<FORM id=weaverD name="weaverD" action="/CRM/Maint/EvaluationOperation.jsp" method=post>
<input type="hidden" name="method" value="getvalue">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <COL width="25%">
  <COL width="15%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6072,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=3 style="padding: 0px"></TD></TR>
<%
int proportionint = 0;
RecordSet.executeProc("CRM_Evaluation_Select","");
boolean isLight = false;
int itemCount = RecordSet.getCounts();
	while(RecordSet.next())
	{	
	String evaluationID = RecordSet.getString("id");
	proportionint += Util.getIntValue(RecordSet.getString("proportion"),0);
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>		
		<TD><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
		<input type="hidden" name="evaluationID" value="<%=RecordSet.getString("id")%>">
		<TD>
		 <select class=InputStyle id="level" name="level">
			<%
			String ischeckle = "";
			while (EvaluationLevelComInfo.next()) {
			  rs.executeSql("select levelID from CRM_Evaluation_LevelDetail where customerID = "+CustomerID+" and evaluationID ="+ evaluationID +" and levelID = "+EvaluationLevelComInfo.getEvaluationLevellevelvalue());											
			  if(rs.next()){										
		        ischeckle = rs.getString("levelID");
			  } 
			%>
            <option value="<%=EvaluationLevelComInfo.getEvaluationLevellevelvalue()%>" <%if(ischeckle.equals(EvaluationLevelComInfo.getEvaluationLevellevelvalue())){ %>selected <%}%>>
				<%=EvaluationLevelComInfo.getEvaluationLevelname()%>
			</option>
			<%}%>
		</select>
		</TD>
		<TD>
		<input type="hidden" name="proportion" value="<%=RecordSet.getString("proportion")%>">		
		<%=Util.toScreen(RecordSet.getString("proportion"),user.getLanguage())%>%</TD>
	</TR>
<%
	}
%>
 </TABLE>
</FORM>

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
</BODY>
</HTML>
<script language=javascript >
function doSubmit(){
		if ("<%=itemCount%>" < 1){
				alert("<%=SystemEnv.getHtmlLabelName(16497,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>");
		} else {
		    if($("#level").val() == null){
		        alert("<%=SystemEnv.getHtmlLabelName(16328,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>");
		    } else {
		    		weaverD.submit();
		    }
		}
}
</script>