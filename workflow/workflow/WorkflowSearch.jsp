<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%
int uid=user.getUID();
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),-1);
String isbill = Util.null2String(request.getParameter("isbill"));

%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/workflow/WorkflowSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S style="display:none" id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing style="height:1px;"><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=workflowname ></TD>
   
<TD width=15%><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=isTemplate name=isTemplate >
          <option value="" <%if(isTemplate==-1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value=0 <%if(isTemplate==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
          <option value=1 <%if(isTemplate==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18334,user.getLanguage())%></option>
        </select>   
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR> 

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></TD>
<TD width=35% class=field>
        <select class=inputstyle id=isbill name=isbill >
          <option value="" <%if(isbill.equals("")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value=0 <%if(isbill.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></option>
          <option value=1 <%if(isbill.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15590,user.getLanguage())%></option>
        </select>   
</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=typeid name=typeid>
		<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		<% while(WorkTypeComInfo.next()) {			
		%>
          <option value=<%=WorkTypeComInfo.getWorkTypeid()%> >
		  <%=Util.toScreen(WorkTypeComInfo.getWorkTypename(),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</tr>

</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
<input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub

Sub btnsub_onclick()
    document.all("tabid").value=2   
    document.SearchForm.submit
End Sub
</SCRIPT>

</BODY>
</HTML>