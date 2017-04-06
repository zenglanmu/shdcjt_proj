<%--
	Created By Charoes Huang On May 28,2004

--%>

<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*,weaver.general.Util,weaver.conn.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id = Util.null2String(request.getParameter("id"));
if("".equals(id)) return;

 int hrmid = user.getUID();
 boolean ism = ResourceComInfo.isManager(hrmid,id);

 int departmentid = user.getUserDepartment();
 /*
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
 boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 */
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));



 if(!(ism || ishe || ishr)) return; //如果不是上级，或本人，或人力资源管理员就不能查看合同信息

String sqlStr = "Select * From HrmContract WHERE ContractMan ="+id;
RecordSet rs = new RecordSet();
rs.executeSql(sqlStr);
%>
 <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=15%>
			<COL width=20%>
			<COL width=15%>
			<COL width=50%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(6161,user.getLanguage())%></TH>
          </TR>
            <tr class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></TD>
		  </tr>
          
		  <%while(rs.next()){
			    String contractid = Util.null2String(rs.getString("id"));
				String name  = Util.null2String(rs.getString("contractname"));
				String typeid  = Util.null2String(rs.getString("contracttypeid"));
				String typename = ContractTypeComInfo.getContractTypename(typeid);
				String man  = Util.null2String(rs.getString("contractman"));
				String startdate  = Util.null2String(rs.getString("contractstartdate"));
				String enddate  = Util.null2String(rs.getString("contractenddate"));
			  %>
		  
				<TR>
					<TD CLASS="Field"><a href=javascript:openFullWindowForXtable("/hrm/contract/contract/HrmContractView.jsp?id=<%=contractid%>") target='_self'><%=name%></a></TD>
					<TD CLASS="Field"><%=typename%></TD>
					<TD CLASS="Field"><%=startdate%></TD>
					<TD CLASS="Field"><%=enddate%></TD>
				</TR>
		  <%}%>
		  </TBODY>
	    </TABLE>
	</TD>
</TR>