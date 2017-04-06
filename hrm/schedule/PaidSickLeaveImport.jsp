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
if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门

String PSLyear = Util.null2String(request.getParameter("PSLyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String tempyear = currentyear;
if(!PSLyear.equals("")){
   session.setAttribute("PSLyear",PSLyear);
}
if(session.getAttribute("PSLyear")!=null){
   tempyear = session.getAttribute("PSLyear").toString();
}

String showname="";
String excelname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   excelname=DepartmentComInfo.getDepartmentname(""+departmentid);
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select * from (select id,lastname,subcompanyid1,departmentid,jobtitle,dsporder from hrmresource where subcompanyid1 = " + subcompanyid + " and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmPSLmanagement b on a.id = b.resourceid and PSLyear = '" + tempyear + "' order by dsporder,lastname,a.id";
}

%>

<%    
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(24047,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
ExcelFile.init() ;
ExcelSheet es = new ExcelSheet();
//ExcelRow title = es.newExcelRow () ;
//title.addStringValue("");
//title.addStringValue(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage()));

//ExcelRow space = es.newExcelRow () ;

ExcelRow er = es.newExcelRow () ;

    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"ID");
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(24032,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(24043,user.getLanguage()));

    RecordSet.executeSql(sql);

    while(RecordSet.next()){
        String id = RecordSet.getString("id");
        String lastname = RecordSet.getString("lastname");
        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
        String tempdepartmentid = RecordSet.getString("departmentid");
        String jobtitle = Util.null2String(RecordSet.getString("jobtitle"));
        String tempPSLdays = Util.null2String(RecordSet.getString("PSLdays"));

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
    er.addStringValue(Util.getFloatValue(tempPSLdays,0)+"");
    
    }
    
   ExcelFile.setFilename(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(24032,user.getLanguage())) ;
   ExcelFile.addSheet(excelname+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(24032,user.getLanguage()),es) ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(this),_self}" ;
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
<FORM id=frmmain name=frmmain action="PaidSickLeaveImportOperation.jsp" method=post enctype="multipart/form-data">
<TABLE class=Shadow>
<tr>
<td valign="top">
<input type="hidden" name="operation" value="import">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<input type="hidden" name="PSLyear" value="<%=PSLyear%>">
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
        <TD><%=SystemEnv.getHtmlLabelName(24032,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
        <TD class=field><%=tempyear%></TD>
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
<span><font color="red"><%
    String msg1[] = Util.TokenizerString2(Util.null2String(request.getParameter("msg1")),",");
    String msg2[] = Util.TokenizerString2(Util.null2String(request.getParameter("msg2")),",");
    String msg = Util.null2String(request.getParameter("msg"));
    if(msg1.length>0){
      for(int i=0;i<msg1.length;i++){
        out.println(SystemEnv.getHtmlLabelName(18620,user.getLanguage())+msg1[i]+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+msg2[i]+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+" ");
      }    
    }
    if(msg.equals("sucess")){
        out.println(SystemEnv.getHtmlLabelName(24034,user.getLanguage()));
    }
 %> 
</font></span>
 <br>
  <table class=Viewform>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <tbody> 
    <tr class=Title> 
      <td><nobr><b><%=SystemEnv.getHtmlLabelName(24032,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())%></b></td>
      <td align=right></td>
    </tr>
    <tr class=spacing style="height:2px"> 
      <td class=Line1 colspan=2></td>
    </tr>
    <tr class=spacing> 
      <td colspan=2 height=8></td>
    </tr>
    <tr class=spacing> 
      <td><%= SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></td>
      <td class=Field>
        <input class=inputstyle type="file" name="excelfile">
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </tbody> 
  </table>
  <br>
  <table class=viewform>
    <COLGROUP> <COL width="20%"> <COL width="80%"><tbody> 
    <tr > 
      <td colspan=2><nobr><b>导入模板及注意事项</b></td>
    </tr>
   <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
   <tr> 
      <td>请点击下载</td>
      <td><a href='/weaver/weaver.file.ExcelOut'><font color="red">导入文件Excel模板</font></a>&nbsp;</td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td>注意事项</td>
      <td>
       1、人员的带薪病假数据必须填入导入文件Excel模板的第一个sheet中。<br><br>
       2、模板中的第一行为标题行，不能占用。数据必须从第二行开始，中间不能有空行<br><br>
       3、模板中的数据除了带薪病假天数以外，其它数据不允许修改。<br><br>
       4、带薪病假天数只能为数字。
      </td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    </tbody> 
  </table>   
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
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="10%" width="10%"></iframe>
<script language=javascript>
function onSubmit(obj){
    if(document.all("excelfile").value==""){
       alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
       return false;
    }
    frmmain.submit();
    obj.disabled = true;
}
function goBack(){
    frmmain.action="PSLManagementEdit.jsp?annualyear=<%=PSLyear%>&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>";
    frmmain.submit();
}
</script>
</BODY>
</HTML>
