<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
int currentyear = today.get(Calendar.YEAR) ;
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
String needcheck = "name";
String id = ""+Util.getIntValue(request.getParameter("id"),0);
String typeID = "0";
String releaseYear = "";
String name = "";
String HeadDoc = "";
RecordSet.executeSql("select * from WebMagazine where id = " + id);
if (RecordSet.next()) 
{
	typeID = ""+Util.getIntValue(RecordSet.getString("typeID"),0);  
	releaseYear = Util.null2String(RecordSet.getString("releaseYear"));
	name = Util.null2String(RecordSet.getString("name"));
	HeadDoc = Util.null2String(RecordSet.getString("docID"));	
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/web/webmagazine/WebMagazineEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineList.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10"  colspan="3"></td>
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
				<%
					String typeName = "";
					RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
					if (RecordSet.next()) 
					{
						typeName = Util.null2String(RecordSet.getString("name"));
					}
					out.print(typeName);
				%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<tr> 
				<td>
					刊号
				</td>
				<td class=Field>
					<%=releaseYear%>年<%=name%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<TR>
				<TD>
					刊首文章
				</TD>
				<TD class=Field>
				<%
					ArrayList docIDArray= Util.TokenizerString(HeadDoc,",");
					for(int i=0;i<docIDArray.size();i++)
					{
						out.print("<a href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>&nbsp;&nbsp;");
					}
				%>
				</TD>
			</TR>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR>			
			</TABLE>

			<table Class=ListStyle id="oTable" cellspacing="1"><COLGROUP>
				<COL width="35%">
				<COL width="30%">
				<COL width="30%">
			  <tr class=header> 
					<td>组名</td>
					<td>是否显示组名</td>
					<td>文档</td>
			   </tr>
			   <TR class=Line style="height: 1px!important;"><TD colspan="3" ></TD></TR> 
			   <%
				boolean colorFlag = false ;
				RecordSet.executeSql("select * from WebMagazineDetail where mainID = " + id +" order by id asc");
				while(RecordSet.next()){
				if (colorFlag){
				%>
				<tr class="DataDark"> 
				<%}else{%>
				<tr class="DataLight"> 
				<%}%>
					<td><%=RecordSet.getString("name")%></td>
					<td>
					<%if(RecordSet.getString("isView").equals("0")){%>
					<img src="/images/BacoCross.gif" border="0">
					<%}
					else 
					if(RecordSet.getString("isView").equals("1")){%>
					<img src="/images/BacoCheck.gif" border="0">
					<%}%>
					</td>
					<td>
					<%
					docIDArray = Util.TokenizerString(Util.null2String(RecordSet.getString("docID")),",");
					for(int i=0;i<docIDArray.size();i++)
					{
						out.print("<a href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>&nbsp;&nbsp;");
					}
					%></td>
			   </tr>
 			  <%
			   colorFlag = !colorFlag;
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