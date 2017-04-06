<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<%@ page import = "weaver.general.Util" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%

%>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16481 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
if(subcompanyid.equals(""))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else if(user.getLanguage()==9){s+="點擊左邊分部對該分部進行薪酬設置</li></TD></TR></TABLE>";}
    else{s+="点击左边分部对该分部进行薪酬设置</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceComponentAdd:Add",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user))
        operatelevel=2;
}
if(operatelevel<0){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
}
boolean CanAdd=false;
if(operatelevel>0)
    CanAdd=true;

String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentAdd:Add" , user);
//RecordSet.executeSql("select  * from hrmsalaryitem where subcompanyid="+subcompanyid) ;
RecordSet.executeSql("select  * from hrmsalaryitem where subcompanyid="+subcompanyid+" order by showorder asc,id asc") ;
%>

<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/finance/salary/HrmSalaryItemAdd.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class = ListStyle cellspacing=1>
  <COLGROUP>
  <COL width = "25%">
  <COL width = "20%">
  <COL width = "20%">
  <COL width = "15%">
  <COL width = "20%">
  <TBODY>
  <TR class = Header>
  <th><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(590 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(63 , user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15824 , user.getLanguage())%></th>
  <TH><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></TH>
  </tr>


<%
boolean isLight = false ; 
	while(RecordSet.next()) {
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String itemname = Util.toScreen(RecordSet.getString("itemname") , user.getLanguage()) ; 
        String itemcode = Util.null2String(RecordSet.getString("itemcode")) ; 
        String itemtype = Util.null2String(RecordSet.getString("itemtype")) ; 
        String isshow = Util.null2String(RecordSet.getString("isshow")) ; 
        String applyscope = Util.null2String(RecordSet.getString("applyscope")) ;
        String scope;
        if(applyscope.equals("0"))
        scope=SystemEnv.getHtmlLabelName(140,user.getLanguage());
        else if(applyscope.equals("1"))
        scope=SystemEnv.getHtmlLabelName(141,user.getLanguage());
        else if(applyscope.equals("2"))
        scope=SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(18921,user.getLanguage());
        else
        scope="";

		if(isLight = !isLight)
		{%>	
	<TR CLASS = DataLight>
<%}else{ %>
	<TR CLASS = DataDark>
<%} %>
		<TD>
            <%
        if(CanAdd&&(!applyscope.equals("0")||(applyscope.equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))))){%><a href = "/hrm/finance/salary/HrmSalaryItemDsp.jsp?id=<%=id%>&subcompanyid=<%=subcompanyid%>"><%=itemname%></a>
        <%}else{%>
        <%=itemname%>
        <%}%>
        </TD>          
        <TD><%=itemcode%></TD>
		<TD> 
            <%if(itemtype.equals("1")){%><%=SystemEnv.getHtmlLabelName(1804 , user.getLanguage())%>
            <%} else if(itemtype.equals("2")){%><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())%>
            <%} else if(itemtype.equals("3")){%><%=SystemEnv.getHtmlLabelName(15826 , user.getLanguage())%>
            <%} else if(itemtype.equals("4")){%><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())%>
            <%} else if(itemtype.equals("5")){%><%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%>
            <%} else if(itemtype.equals("6")){%><%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%>
            <%} else if(itemtype.equals("7")){%><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%>
            <%} else if(itemtype.equals("9")){%><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%>
            <%}%>
        </TD>
		<TD>
			<%if(isshow.equals("1")){%><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%>
		    <%}else{%><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%><%}%>
        </TD>
   		<TD>
			<%=scope%>
        </TD>
	</TR>
<%} %>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>