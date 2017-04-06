<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />

<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">
				
				
				
    <TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">

		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TH>
		</TR>

		<TR class=Line style="height:1px">
			<TD colSpan=3 style="padding:0px"></TD>
		</TR>

        <TR class=DataDark>
			<TD><a href="/workflow/request/RequestUserDefault.jsp"><%=SystemEnv.getHtmlLabelName(16452,user.getLanguage())%></a></TD>
		</TR>
	
		<TR class=DataLight>	
			<TD><a href="/workflow/sysPhrase/PhraseList.jsp"><%=SystemEnv.getHtmlLabelName(17561,user.getLanguage())%></a></TD>
		</TR>

	</TABLE>

    <TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">

		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></TH>
		</TR>

		<TR class=Line style="height:1px">
			<TD colSpan=3 style="padding:0px"></TD>
		</TR>

        <TR class=DataDark>
			<TD><a href="/docs/tools/DocUserDefault.jsp"><%=SystemEnv.getHtmlLabelName(16452,user.getLanguage())%></a></TD>
		</TR>
	
	</TABLE>
<TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">

		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH>
		</TR>

		<TR class=Line style="height:1px">
			<TD colSpan=3 style="padding:0px"></TD>
		</TR>

        <TR class=DataDark>
			<TD><a href="/hrm/group/HrmGroup.jsp"><%=SystemEnv.getHtmlLabelName(17617,user.getLanguage())%></a></TD>
		</TR>
	
		<TR class=DataLight>	
			<TD><a href="/worktask/base/WorktaskUserDefault.jsp"><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%></a></TD>
		</TR>
	</TABLE>
    <TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">

		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(16373,user.getLanguage())%></TH>
		</TR>

		<TR class=Line style="height:1px">
			<TD colSpan=3 style="padding:0px"></TD>
		</TR>

        <TR class=DataDark>
			<TD><a href="/systeminfo/setting/HrmUserSetting.jsp"><%=SystemEnv.getHtmlLabelName(17627,user.getLanguage())%></a></TD>
		</TR>
	
	</TABLE>

    <TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="100%">

		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(17721,user.getLanguage())%></TH>
		</TR>

		<TR class=Line style="height:1px">
			<TD colSpan=3 style="padding:0px"></TD>
		</TR>
		
		<TR class=DataDark>
			<TD><a href="/systeminfo/menuconfig/MenuMaintenanceList.jsp?type=top&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>"><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%></a></TD>
		</TR>


        <TR class=DataDark>
			<TD><a href="/systeminfo/menuconfig/MenuMaintenanceList.jsp?type=left&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>"><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())%></a></TD>
		</TR>
		
	
		<TR class=DataLight>	
			<TD><a href="/systeminfo/template/templateSelectFrame.jsp"><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%></a></TD>
		</TR>

	</TABLE>
	<%
		String strHpUrl=hpu.getHomepageUrl(user,true);		
		if(!"/workspace/WorkSpace.jsp".equals(strHpUrl)){
	%>
    
    <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
        <COL width="100%">

        <TR class=Header>
            <TH><%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19419,user.getLanguage())%></TH>
        </TR>

        <TR class=Line style="height:1px">
            <TD colSpan=3 style="padding:0px"></TD>
        </TR>
		<%
		String strHpSql="select id,infoname,subcompanyid from hpinfo where  isuse='1'  ";
		if(user.getUID()==1) { //系统管理员
			
		} else { //普通管理员及分部管理员
			strHpSql+=" and islocked='0' and id in " +
			 "(select distinct hpid  from  shareinnerhp where (type=1 and content="+user.getUID()+" ) " +
			  "or (type=2 and content="+user.getUserSubCompany1()+" ) " +
			   "or (type=3 and content="+user.getUserDepartment()+" ) or" +
			    " (type=5 and   content=1 )) ";
		}
		//out.println(strHpSql);
		int row=0;
		RecordSet.executeSql(strHpSql);


		while (RecordSet.next()){
			String tempId=Util.null2String(RecordSet.getString("id"));
			String tempName=Util.null2String(RecordSet.getString("infoname"));	
			String tempSubcompanyid=Util.null2String(RecordSet.getString("subcompanyid"));	
			String tempUrl="/homepage/Homepage.jsp?isSetting=true&from=addElement&hpid="+tempId+"&subCompanyId="+tempSubcompanyid;
			row++;	
			
		%>
       
        <TR class="<%if(row%2==0) out.println("DataLight"); else out.println("DataDark");%>">
            <TD><a href="<%=tempUrl%>"><%=tempName%></a></TD>
        </TR>
		<%}%>
    </TABLE>
	<%}%>

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



</body>
</html>

