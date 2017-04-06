<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
<%
//added by hubo,20060113
 String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());

 int hrmid = user.getUID();
 int isView = Util.getIntValue(request.getParameter("isView"));
 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 int departmentid = user.getUserDepartment();
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
 if(!ishe&&!ishr ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
}
%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19599,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:1px; ">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<%if(HrmListValidate.isValidate(6)){%>
<% if(ishe||ishr){ // 薪酬调整信息, 工资信息本人和人力资源管理员,本人的所有经理看到 %>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <TBODY>
  <TR class=Header>
    <TH colspan=8><%=SystemEnv.getHtmlLabelName(19599,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15819,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15820,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19603,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15821,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15822,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19604,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15823,user.getLanguage())%></th>
  </tr>

<%
    rs.executeSql("select * from HrmSalaryChange where multresourceid like '%," + id +",%' order by id desc");
    boolean isLight = false;
	while(rs.next())
	{
        String itemid = Util.null2String(rs.getString("itemid")) ;
        String changedate = Util.null2String(rs.getString("changedate")) ;
        String changetype = Util.null2String(rs.getString("changetype")) ;
        String salary = Util.null2String(rs.getString("salary")) ;
        String changeresion = Util.toScreen(rs.getString("changeresion"),user.getLanguage()) ;
        String changeuser = Util.null2String(rs.getString("changeuser")) ;
        String oldsalary = Util.null2String(rs.getString("oldvalue")) ;
        String newsalary = Util.null2String(rs.getString("newvalue")) ;
		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
        <TD><%=Util.toScreen(SalaryComInfo.getSalaryname(itemid),user.getLanguage())%></TD>
        <TD><%=changedate%></TD>
        <TD align=right><%=oldsalary%></TD>
        <TD>
            <%if(changetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>
            <%} else if(changetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>
            <%} else if(changetype.equals("3")){%><%=SystemEnv.getHtmlLabelName(15816,user.getLanguage())%><%}%>
        </TD>
		<TD align=right><%=salary%></TD>
        <TD align=right><%=newsalary%></TD>
           <TD><%=changeresion%></TD>
        <TD><%=Util.toScreen(ResourceComInfo.getResourcename(changeuser),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%}%>
<%}%>
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
  function goBack(){
      location = "/hrm/resource/HrmResourceFinanceView.jsp?isfromtab=<%=isfromtab%>&isView=<%=isView%>";
  }
</script>
</BODY>
</HTML>