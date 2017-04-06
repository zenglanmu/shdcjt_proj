<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
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
String titlename = "期刊";
String needfav ="1";
String needhelp ="";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
String typeName = "";
String typeRemark = "";
RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
if (RecordSet.next()) 
{
	typeName = Util.null2String(RecordSet.getString("name"));
	typeRemark = Util.null2String(RecordSet.getString("remark"));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/web/webmagazine/WebMagazineTypeEdit.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{增加刊号,/web/webmagazine/WebMagazineAdd.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineTypeList.jsp,_self} " ;
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
				
			<TABLE class=ViewForm>
			<COLGROUP><COL width="10%"><COL width="90%">
			<TBODY>
			<tr> 
				<td>
					刊名
				</td>
				<td class=Field>
					<%=typeName%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<TR>
				<TD>
					<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>
				</TD>
				<TD class=Field>
					<%=typeRemark%>
				</TD>
			</TR>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR>
			</TABLE>

			  <table Class=ListStyle cellspacing=1 ><COLGROUP>
				<COL width="50%">
				<COL width="30%">
				<COL width="20%">
			   <tr class=header> 
					<td>刊号</td>
					<td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></td>
			   </tr>
			   <TR class=Line style="height: 1px!important;"><TD colspan="3" ></TD></TR> 
			<%
			int num = 0;
			boolean isLight=false;
			RecordSet.executeSql("select id  , releaseYear , name , createDate from WebMagazine where typeID = " + typeID + " order by id desc");
			while (RecordSet.next())
			{
			if(isLight)
					{%>	
				<TR CLASS=DataDark>
			<%		}else{%>
				<TR CLASS=DataLight>
			<%		}%>
			  <td>
				<a href='/web/webmagazine/WebMagazineView.jsp?id=<%=RecordSet.getString("id")%>'><%=RecordSet.getString("releaseYear")%>年<%=RecordSet.getString("name")%></a>
			  </td>
			  <td><%=RecordSet.getString("createDate")%></td>
			  <td><a href="javascript:onDel('/web/webmagazine/WebMagazineOperation.jsp?method=del&id=<%=RecordSet.getString("id")%>&typeID=<%=typeID%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>
			  </tr>
			<%
			isLight = !isLight;
			}
			%>
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
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function onDel(addr){
		if(isdel) window.location=addr;
	}
//-->
</SCRIPT>