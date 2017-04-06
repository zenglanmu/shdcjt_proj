<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%
int docid = Util.getIntValue(Util.null2o(request.getParameter("docid")));


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19461,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

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

			<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1>
				<TR class=DataHeader>
				<TH width=0% style="display:none"></TH>
				<TH width=50%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
				<TH width=18%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
				<TH width=14%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
				<TH width=18%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
				</tr><TR class=Line><TH colSpan=5></TH></TR>
				<%
				int i=0;
				RecordSet.executeSql(" select * from DocDetail where maindoc = " + docid + " and (isHistory<>'1'or isHistory is null or isHistory='') and docstatus in (1,2,5) order by id desc " );
				while(RecordSet.next()){
					String currdocid = Util.null2String(RecordSet.getString("id"));

					if(currdocid.equals(""+docid)) continue;

					String currmainid = Util.null2String(RecordSet.getString("mainCategory"));
					String currsubject = Util.null2String(RecordSet.getString("docSubject"));
					String currcreaterid = Util.null2String(RecordSet.getString("ownerid"));
					String currmodifydate = Util.null2String(RecordSet.getString("docLastModDate"));
					String currusertype = Util.null2String(RecordSet.getString("usertype"));
					if(i==0){
						i=1;
					%>
					<TR class=DataLight>
					<%
					} else {
						i=0;
					%>
					<TR class=DataDark>
					<%
					}
					%>
						<TD width=0% style="display:none"><A HREF=#><%=currdocid%></A></TD>
						<TD><a href="/docs/docs/DocDsp.jsp?id=<%=currdocid%>"><%=currsubject%></a></TD>
						<TD><%=MainCategoryComInfo.getMainCategoryname(currmainid)%></TD>
						<TD><%if(currusertype.equals("1")){%>
								<%=Util.toScreen(ResourceComInfo.getResourcename(currcreaterid),user.getLanguage())%>
								<%}else{%>
								<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(currcreaterid),user.getLanguage())%>
								<%}%>
						</TD>
						<TD><%=currmodifydate%></TD>
					</TR>
				<%}%>
			</TABLE>

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
</BODY></HTML>