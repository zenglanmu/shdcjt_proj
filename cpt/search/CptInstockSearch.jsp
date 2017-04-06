<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(6050,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",/cpt/capital/CptCapitalMove.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",/cpt/capital/CptCapitalLend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",/cpt/capital/CptCapitalLoss.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",/cpt/capital/CptCapitalDiscard.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(22459,user.getLanguage())+",/cpt/capital/CptCapitalMend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",/cpt/capital/CptCapitalBack.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",/cpt/capital/CptCapitalInstock1.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",/cpt/search/CptInstockSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			  <table Class=ListStyle cols=4 cellspacing="1"><COLGROUP>
				<COL width="10%">
				<COL width="30%">
				<COL width="15%">
				<COL width="15%">
				<COL width="30%">
			   <tr class=header> 
					<td><%=SystemEnv.getHtmlLabelName(751,user.getLanguage())+SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15357,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(913,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
					
			   </tr>
			   <TR class=Line><TD colspan="5" ></TD></TR> 
			<%
			String sqlstr = "select * from CptStockInMain where ischecked = 0 and checkerid =" + user.getUID();
			RecordSet.executeSql(sqlstr);
			boolean isLight=false;
			while (RecordSet.next())
			{
			if(isLight)
					{%>	
				<TR CLASS=DataDark>
			<%		}else{%>
				<TR CLASS=DataLight>
			<%		}%>
			   <td><%=RecordSet.getString("id")%></td>
			   <td><a href='/cpt/capital/CptCapitalInstock.jsp?id=<%=RecordSet.getString("id")%>'><%=SystemEnv.getHtmlLabelName(15359,user.getLanguage())%></a></td>
				<td><a href="/cpt/capital/CapitalInstock1Operation.jsp?method=delete&id=<%=RecordSet.getString("id")%>" 
						onclick="return isdel()"><img src="/images/BacoDelete.gif" width="16" height="16" border="0"></a></td>
			   <td><A href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("buyerid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("buyerid")),user.getLanguage())%></A></td>
			   <td><%=RecordSet.getString("stockindate")%></td>   
			   </tr>
			<%
			isLight = !isLight;
			}%>
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

 </form>
<script language="javascript">
 function back()
{
	window.history.back(-1);
}
</script>
</BODY>
</HTML>
