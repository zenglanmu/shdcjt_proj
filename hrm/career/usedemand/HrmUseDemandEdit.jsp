<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = request.getParameter("id");

String jobtitle = "";
String demandnum = "";
String otherrequest = "";
String date = "";
int status = 0;
String leastedulevel = "";
int createkind = 0;
String demandkind = "";

String referman = "";
String department = "";
String referdate = "";

String sql = "select * from HrmUseDemand where id ="+id;
rs.executeSql(sql); 
while(rs.next()){
  jobtitle = Util.null2String(rs.getString("demandjobtitle"));
  demandnum = Util.null2String(rs.getString("demandnum"));
  status = Util.getIntValue(rs.getString("status"),0);
  leastedulevel = Util.null2String(rs.getString("leastedulevel"));  
  date = Util.null2String(rs.getString("demandregdate"));
  otherrequest = Util.null2String(rs.getString("otherrequest"));
  createkind = Util.getIntValue(rs.getString("createkind"),0);
  demandkind = Util.null2String(rs.getString("demandkind"));
  
  referman = Util.null2String(rs.getString("refermandid"));
  department = Util.null2String(rs.getString("demanddep"));
  referdate = Util.null2String(rs.getString("referdate"));
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(89,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)&&createkind == 1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(status == 2||status == 3){
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doclose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmUseDemand:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+69+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/usedemand/HrmUseDemand.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<FORM id=weaver name=frmMain action="UseDemandOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
          <TD class=Field>            
               <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>               
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>            
               <%=DepartmentComInfo.getDepartmentname(department) %>               
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
          <TD class=Field>
            <%=demandnum%>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></td>
          <td class=Field >
             <%=UseKindComInfo.getUseKindname(demandkind)%>             
          </td>
        </tr>          
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
            <%if(status == 0){%><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%><%}%>          
            <%if(status == 1){%><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%><%}%>          
            <%if(status == 2){%><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%><%}%>          
            <%if(status == 3){%><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%><%}%>          
            <%if(status == 4){%><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%><%}%>         
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TD>
          <TD class=Field> 
<!--                     
	            <%if(leastedulevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("12")){%><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("13")){%><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("3")){%><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("4")){%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("5")){%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("6")){%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("7")){%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("8")){%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
	            <%if(leastedulevel.equals("9")){%>MBA<%}%>
	            <%if(leastedulevel.equals("10")){%>EMBA<%}%>
	            <%if(leastedulevel.equals("11")){%><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%><%}%>	                   
-->	    
             <%=EducationLevelComInfo.getEducationLevelname(leastedulevel)%>         
          </TD>
        </TR>    
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></td>
          <td class=Field>
            <%=date%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
          <TD class=Field>            
               <%=ResourceComInfo.getResourcename(referman) %>              
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></TD>
          <TD class=Field>            
               <%=referdate %>               
          </td>
        </TR>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></td>
          <td class=Field>
            <%=otherrequest%>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
<input type="hidden" name=operation>
<input type=hidden name=id value="<%=id%>">
 </form>
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
<script language=vbs>
sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	frmMain.demandkind.value=id(0)
	else 
	usekindspan.innerHtml = ""
	frmMain.demandkind.value=""
	end if
	end if
end sub
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmMain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmMain.jobtitle.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
 function doedit(){
   location="HrmUseDemandEditDo.jsp?id=<%=id%>";
 }
 function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
     document.frmMain.operation.value="delete";
     document.frmMain.submit();
   }
 }
 function doclose(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15751,user.getLanguage())%>")){
     document.frmMain.operation.value="close";
     document.frmMain.submit();
   }
 }
</script> 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
