<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>
<%
String provinceId = Util.null2String(request.getParameter("province"));
String sqlTerm = Util.null2String(request.getParameter("sqlterm"));
int pageNum = Util.getIntValue(request.getParameter("pagenum"), 1);

String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

int perPage = 10;
String sql = "";
String tempTable = "SATempTable"+ Util.getRandom();
if (provinceId.equals(""))
	return;

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if (rs.getDBType().equals("oracle"))
	sql = "CREATE TABLE " + tempTable + " AS SELECT * FROM (SELECT DISTINCT"
		+ " t1.id, t1.name, t1.manager, t1.website"
		+ " FROM CRM_customerinfo t1, CRM_Contract t3, "+leftjointable+" t2 "
		+ " WHERE t3.crmId = t4.relateditemid AND t3.crmId = t1.id AND t3.status >= 2"
		+ " AND t1.province = " + provinceId
		+ sqlTerm
		+ " ORDER BY t1.id DESC"
		+ ") WHERE rownum < " + ( pageNum * perPage + 2);
else if (rs.getDBType().equals("db2")){
    sql= "create table "+tempTable+"  as ( SELECT DISTINCT"
		+ " t1.id, t1.name, t1.manager, t1.website"
		+ " FROM CRM_customerinfo t1, CRM_Contract t3, "+leftjointable+" t2 ) definition only";
    rs.executeSql(sql);
    sql = "insert into "+tempTable+" ( SELECT DISTINCT"
		+ " t1.id, t1.name, t1.manager, t1.website"
		+ " FROM CRM_customerinfo t1, CRM_Contract t3,"+leftjointable+" t2 "
		+ " WHERE t3.crmId = t4.relateditemid AND t3.crmId = t1.id AND t3.status >= 2"
		+ " AND t1.province = " + provinceId
		+ sqlTerm
		+ " ORDER BY t1.id DESC fetch first "+( pageNum * perPage + 1)+"  rows only)";
}
else
	sql = "SELECT DISTINCT TOP " + ( pageNum * perPage + 1)
		+ " t1.id, t1.name, t1.manager, t1.website INTO "
		+ tempTable + " FROM CRM_customerinfo t1, CRM_Contract t3,"+leftjointable+" t2 "
		+ " WHERE t3.crmId = t4.relateditemid AND t3.crmId = t1.id AND t3.status >= 2"
		+ " AND t1.province = " + provinceId
		+ sqlTerm
		+ " ORDER BY t1.id DESC";
rs.executeSql(sql);
rs.executeSql("SELECT COUNT(id) recordCount FROM " + tempTable);

boolean hasNextPage = false;
int recordCount = 0;
if (rs.next())
	recordCount = rs.getInt("recordCount");

if (recordCount > pageNum * perPage)
	hasNextPage = true;

if (rs.getDBType().equals("oracle"))
	sql = "SELECT * FROM (SELECT * FROM  " + tempTable + " ORDER BY id) WHERE rownum < "
			+ (recordCount - (pageNum - 1) * perPage + 1);
else if (rs.getDBType().equals("db2"))
	sql = "SELECT  * FROM "
			+ tempTable + " ORDER BY id fetch first  " + (recordCount - (pageNum - 1) * perPage) + " rows only";
else
	sql = "SELECT TOP " + (recordCount - (pageNum - 1) * perPage) + " * FROM "
			+ tempTable + " ORDER BY id";

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage()) + SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if (pageNum > 1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:goBackPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if (hasNextPage) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:goNextPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">

            <FORM id="frmmain" name="frmmain" method="post" action="SellAreaResult.jsp">
            <INPUT type="hidden" name="province" value="<%=provinceId%>">
			<INPUT type="hidden" name="sqlterm" value="<%=sqlTerm%>">
			<INPUT type="hidden" name="pagenum" value="<%=pageNum%>">
            <TABLE class="ListStyle" cellspacing="1" id="result">
			<COLGROUP>
			<COL width="50%">
			<COL width="20%">
			<COL width="30%">
			<TBODY>
			<TR class="Header">
			  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
			  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
			  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></TD>
			</TR>
			<TR class="Line"><TD colspan="3"></TD></TR>
		<%
			boolean isLight = false;
			int lineCount = 0;
			String m_id = "";
			String m_name = "";
			String m_manager = "";
			String m_website = "";
			rs.executeSql(sql);
			if (rs.last()) {
				do {
					if (hasNextPage) {
						lineCount ++;
						if (lineCount > perPage)
							break;
					}

					m_id = Util.null2String(rs.getString("id"));
					m_name = Util.null2String(rs.getString("name"));
					m_manager = Util.null2String(rs.getString("manager"));
					m_website = Util.null2String(rs.getString("website"));

					m_manager = resourceComInfo.getLastname(m_manager);

					isLight = !isLight;
		%>
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
		<TD><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=m_id%>"><%=m_name%></A></TD>
		<TD><%=m_manager%></TD>
		<TD><%=m_website%></TD>
		</TR>
		<%

				} while (rs.previous());
			}

			rs.executeSql("DROP TABLE "+ tempTable);
		%>

			</TBODY>
            </TABLE>
            </FORM>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

<SCRIPT language="JavaScript">
function goBack() {
	document.location.href="/CRM/sellchance/SellAreaProRpSum.jsp"
}

function goNextPage() {
	document.all("pagenum").value = <%=pageNum+1%>;
    document.frmmain.submit();
}

function goBackPage() {
	document.all("pagenum").value = <%=pageNum-1%>;
    document.frmmain.submit();
}
</SCRIPT>
</BODY>
</HTML>