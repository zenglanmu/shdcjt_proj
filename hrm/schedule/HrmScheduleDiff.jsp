<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<HTML>
<HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
if(subcompanyid.equals(""))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's schedule category</li></TD></TR></TABLE>";}
    else if(user.getLanguage()==9){s+="點擊左邊分部對該分部進行考勤種類設置</li></TD></TR></TABLE>";}
    else{s+="点击左边分部对该分部进行考勤种类设置</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmScheduleDiffAdd:Add",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add", user))
        operatelevel=2;
}
if(operatelevel<0){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
}
boolean CanAdd=false;
if(operatelevel>0)
    CanAdd=true;

String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmScheduleDiffAdd.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) ="+17+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?subcompanyid="+subcompanyid+"&sqlwhere=where operateitem ="+17+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
    String sql="select * from HrmScheduleDiff where subcompanyid="+subcompanyid;
    //System.out.println(sql);
    RecordSet.executeSql(sql);
    //RecordSet.executeProc("HrmScheduleDiff_Select_All" , "") ;

%>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>

</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<b>
<%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>
</b>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>

  <TR class=spacing>

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></TH>
      <TH style="display:none"><%=SystemEnv.getHtmlLabelName(16712,user.getLanguage())%></TH>
      <TH style="display:none"><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
  </TR>

<%

boolean isLight = false;


	while(RecordSet.next()){
		if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
     <% String scope;
        if(RecordSet.getString("diffscope").equals("0"))
        scope=SystemEnv.getHtmlLabelName(140,user.getLanguage());
        else if(RecordSet.getString("diffscope").equals("1"))
        scope=SystemEnv.getHtmlLabelName(141,user.getLanguage());
        else
        scope=SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(18921,user.getLanguage());

    %>
    <TD><%
        if(CanAdd&&(!RecordSet.getString("diffscope").equals("0")||(RecordSet.getString("diffscope").equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))))){%><a href = "HrmScheduleDiffEdit.jsp?id=<%=RecordSet.getInt("id")%>&subcompanyid=<%=RecordSet.getInt("subcompanyid")%>"><%=RecordSet.getString("diffname")%></a>
        <%}else{%>
        <%=RecordSet.getString("diffname")%>
        <%}%>
        </TD>

      <TD><%=scope%></TD>
      <TD style="display:none"><%=SalaryComInfo.getSalaryname(RecordSet.getString("salaryitem"))%></TD>
      <% String difftype;
        if(RecordSet.getString("difftype").equals("0"))
        difftype=SystemEnv.getHtmlLabelName(456,user.getLanguage());
        else
        difftype=SystemEnv.getHtmlLabelName(457,user.getLanguage());
    %>
      <TD style="display:none"><%=difftype%></TD>
      <TD><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"))%></TD>
      <TD><%=RecordSet.getString("diffdesc")%></TD>




  </TR>
<%
	isLight = !isLight;

}

%>

 </TBODY>
 </TABLE>

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
</body>
</html>