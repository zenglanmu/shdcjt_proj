<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdDOC.gif";
    String titlename = SystemEnv.getHtmlLabelName(16400,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_top} " ;
    //RCMenuHeight += RCMenuHeightStep ;
%>

<%

    String sql = "select t1.id, t1.name,t1.type,t1.manager,t1.status,t2.movedate from CRM_CustomerInfo t1 ,CRM_ViewLog2 t2 where (t1.deleted=0 or t1.deleted is null) and t1.id=t2.customerid and t1.manager="+user.getUID()+" order by t2.movedate desc,t2.movetime desc";
    //String sql = "select distinct t1.id,t1.name,t1.type,t1.manager,t1.status,t1.createdate from CRM_CustomerInfo t1 where t1.manager=80 and t1.id not in(select id from CRM_ViewLog1) order by t1.createdate";
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);

%>
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



<TABLE class=ListStyle  cellspacing=1 >
  <TBODY>
  <TR class=Header>
      <th width=20%><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(18901,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colSpan=5 style="padding: 0"></TD></TR>
  <%
      int i=2;
      while(RecordSet.next()){
          if(i%2==0){
  %>
  <TR class=datadark>
  <%
          }else{
  %>
  <TR class=datalight>
  <%
          }
  %>
      <td width=20%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("id")%>">
        <%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
      </a>
      </td>
      <td width=20%>
      <%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%>
      </td>
      <td width=20%>
      <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>
      </td>
      <td width=20%>
      <%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(RecordSet.getString("status")),user.getLanguage())%>
      </td>
      <td width=20%>
      <%=RecordSet.getString("movedate")%>
      </td>
  </tr>
  <%}%>
  </tbody>
</table>




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
</body>
</html>