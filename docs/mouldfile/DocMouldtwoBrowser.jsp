<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String doctype = request.getParameter("doctype");
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"),0);
if(doctype!=null&&"".equals(doctype)) doctype = "0";
else if(doctype!=null&&!"".equals(doctype)){
	if(doctype.equals(".htm")) doctype = "0";
	else if(doctype.equals(".doc")) doctype = "2";
	else if(doctype.equals(".xls")) doctype = "3";
	else if(doctype.equals(".wps")) doctype = "4";
	else if(doctype.equals(".et")) doctype = "5";
}


String imagefilename = "/images/hdMaintenance.gif";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocMouldtwoBrowser.jsp.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class= Spacing><TD class=Line1 colspan=4></TD></TR>
<TR>
<TR class= Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<BR>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0">

  <COLGROUP>  
  <COL width="40%">
  <COL width="60%">
  
  <TR class=DataHeader>
  </TR>
  <TR class=DataHeader>    
	<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	</tr><TR class=Line><TH colspan="8" ></TH></TR>

<%
int i= 0;
String sqlstr = "";
if(detachable==1){
	sqlstr = "select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet where subcompanyid = "+subcompanyid1+")and mouldType="+Util.getIntValue(doctype,-1)+" order by id asc" ;
}else{
	sqlstr = "select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet)and mouldType="+Util.getIntValue(doctype,-1)+" order by id asc" ;
}


//System.out.println("sqlstr###:"+sqlstr);
rs.executeSql(sqlstr);
while(rs.next()) {
	String id = rs.getString("id") ;
	//String templetdocid = Util.toScreen(rs.getString("templetdocid"),user.getLanguage()) ;
	String mouldname = Util.toScreen(rs.getString("mouldname"),user.getLanguage()) ;
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
	<TD><%=id%></TD>
	<TD><%=mouldname%></TD>
    </TR>
<%}%>
  </TABLE>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

</SCRIPT>