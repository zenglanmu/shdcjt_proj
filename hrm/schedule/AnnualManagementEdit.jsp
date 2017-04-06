<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门
int message = Util.getIntValue(request.getParameter("message"),-1);
String annualyear = Util.null2String(request.getParameter("annualyear"));
String tempyear = annualyear;
String showname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where subcompanyid1 = " + subcompanyid + " and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}

%>

<%    
String imagefilename = "/images/hdHRMCard.gif";
String titlename =SystemEnv.getHtmlLabelName(21590,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21611,user.getLanguage())+",javascript:BatchProcess(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:onImport(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
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
<form id=frmmain name=frmmain method=post action="AnnualManagementOperation.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<input type="hidden" name="annualyear" value="<%=annualyear%>">
<input type="hidden" name="operation" value="edit">
<%if(message==12){%>
<span><font color='red'><%=SystemEnv.getHtmlLabelName(21612,user.getLanguage())%></font></span>
<%}%>
<table class=Viewform>
  <COLGROUP><COL width="18%"><COL width="82%">
      <TBODY>
      <TR class=Title colspan=5>
        <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
        <TD class=Line1 colspan=2></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
        <TD class=field><%=annualyear%></TD>
      </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></TD>
        <TD class=field>
          <SPAN id=jobtitlespan><%=showname%></SPAN>          
        </TD>               
      </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     </TBODY>
</table>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
    <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
    <TH width=20%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
    <TH width=20%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
    <TH width=20%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
    <TH width=20%><%=SystemEnv.getHtmlLabelName(19517,user.getLanguage())%></TH>
  </tr>
  <%
    RecordSet.executeSql(sql);
    boolean color = false;
    while(RecordSet.next()){
        String id = RecordSet.getString("id");
        String lastname = RecordSet.getString("lastname");
        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
        String tempdepartmentid = RecordSet.getString("departmentid");
        String jobtitle = RecordSet.getString("jobtitle");
        String tempannualdays = Util.null2String(RecordSet.getString("annualdays"));

    if(departmentid>0){
       if(!tempdepartmentid.equals(departmentid+"")) continue;
    }else{
       if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
    }
   
    if(jobtitle.equals("")) continue;
   
    color = !color; 
  %>
  <%
    if(color) out.println("<tr class='datalight'>");
    else out.println("<tr class='datadark'>");
  %>
     <td><a href=javascript:this.openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=id%>')><%=lastname%></a></td>
     <td><a href=javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartment.jsp?subcompanyid=<%=tempsubcompanyid%>')><%=SubCompanyComInfo.getSubCompanyname(tempsubcompanyid)%></a></td>
     <td><a href=javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id=<%=tempdepartmentid%>')><%=DepartmentComInfo.getDepartmentname(tempdepartmentid)%></a></td>
     <td><a href=javascript:this.openFullWindowForXtable('/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>')><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%><a></td>
     <td><input type=text size=4 class=inputstyle name=annualdays value="<%=Util.getFloatValue(tempannualdays,0)%>"></td>
     <input type=hidden size=4 class=inputstyle name=resourceid value="<%=id%>">
  </tr>
  <%
    }
  %>
  </TBODY>
 </TABLE>
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
<script language=javascript>
function onSave(){
    frmmain.submit();
}
function goBack(){
    frmmain.action="AnnualManagementView.jsp?subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>";
    frmmain.submit();
}
function BatchProcess(){
    document.frmmain.operation.value="batchprocess";
    frmmain.submit();
}
function onImport(){
    location="AnnualManagementImport.jsp?annualyear=<%=annualyear%>&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>";
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
