<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
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

String annualyear = Util.null2String(request.getParameter("annualyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
String tempyear = currentyear;
if(!annualyear.equals("")){
   session.setAttribute("annualyear",annualyear);
}
if(session.getAttribute("annualyear")!=null){
   tempyear = session.getAttribute("annualyear").toString();
}

String showname="";
String excelname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   excelname=DepartmentComInfo.getDepartmentname(""+departmentid);
   sql = "select * from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select * from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where subcompanyid1 = " + subcompanyid + " and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}

String annualperiod = "";
try{annualperiod = HrmAnnualManagement.getAnnualPeriod(subcompanyid+"",tempyear);}catch(Exception e){}
String enddate = Util.TokenizerString2(annualperiod,"#")[1];

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
if(enddate.compareTo(currentdate)>-1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
}
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
<form id=frmmain name=frmmain method=post action="HrmSalaryManageView.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<table class=Viewform>
  <COLGROUP><COL width="18%"><COL width="82%">
      <TBODY>
      <TR class=Title colspan=5>
        <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
        <TD class=Line1 colspan=5></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
        <TD class=field>
          <select id=annualyear name=annualyear onchange="changeyear(this)">
          <%//输出的列表为，2005年到当前年加10年，
           int length = Integer.parseInt(currentyear)-2005+10;           
           for(int i=0;i<length;i++){
              String str = "<option value="+(2005+i)+">"+(2005+i)+"</option>";   
              if(2005+i==Integer.parseInt(tempyear)) str="<option value="+(2005+i)+" selected>"+(2005+i)+"</option>";
              out.println(str);
           } 
          %>   
          </select>
        </TD>
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
    ExcelFile.init();
    ExcelSheet es = new ExcelSheet();

    ExcelRow er = es.newExcelRow ();

    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"ID");
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(19517,user.getLanguage()));
    
    RecordSet.executeSql(sql);
    boolean color = false;
    while(RecordSet.next()){
        String workcode = Util.null2String(RecordSet.getString("workcode"));
        String id = RecordSet.getString("id");
        String lastname = RecordSet.getString("lastname");
        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
        String tempdepartmentid = RecordSet.getString("departmentid");
        String jobtitle = Util.null2String(RecordSet.getString("jobtitle"));
        String tempannualdays = Util.null2String(RecordSet.getString("annualdays"));

    if(departmentid>0){
       if(!tempdepartmentid.equals(departmentid+"")) continue;
    }else{
       if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
    }
    
    if(jobtitle.equals("")) continue;
    
    er = es.newExcelRow () ;

    er.addStringValue(id);
    er.addStringValue(lastname);
    er.addStringValue(SubCompanyComInfo.getSubCompanyname(tempsubcompanyid));
    er.addStringValue(DepartmentComInfo.getDepartmentname(tempdepartmentid));
    er.addStringValue(JobTitlesComInfo.getJobTitlesname(jobtitle));
    er.addStringValue(tempyear);
    er.addStringValue(Util.getFloatValue(tempannualdays,0)+"");
        
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
     <td><%=Util.getFloatValue(tempannualdays,0)%></td>
  </tr>
  <%
    }
   ExcelFile.setFilename(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage())) ;
   ExcelFile.addSheet(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage()),es) ;
    
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
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="10%" width="10%" scrolling=no></iframe>
<script language=javascript>
function onEdit(){
    frmmain.action="AnnualManagementEdit.jsp";
    frmmain.submit();
}
function changeyear(){
    frmmain.action="AnnualManagementView.jsp";
    frmmain.submit();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
