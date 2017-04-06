<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />

<%
boolean CanEdit = HrmUserVarify.checkUserRight("DocSysDefaults:Edit", user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>

</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(112,user.getLanguage());
String needfav ="1";
String needhelp ="";

String  saved=Util.null2String(request.getParameter("saved"));
%>
<script language=javascript>
function onLoad(){
    if(<%=(saved.equals("true")?"true":"false")%>){
        alert("±£´æ³É¹¦");
    }
}
</script>
<BODY onload="onLoad()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocSysDefaults:log", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =7',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<%
String sql="select * from docsysdefault";
RecordSet.executeSql(sql);
RecordSet.next();
String fgpicwidth=RecordSet.getString("fgpicwidth");
String fgpicfixtype=RecordSet.getString("fgpicfixtype");
String docdefmouldid=RecordSet.getString("docdefmouldid");
String docapprovewfid=RecordSet.getString("docapprovewfid");
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


<FORM id=weaver name=frmmain action="DocSysDefaultsOperation.jsp" method=post >
<table class=ViewForm>
	<colgroup>
	<COL width="49%">
	<COL width=10>
	<COL width="49%">
	<TBODY>
	<TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TH>
          </TR>
<TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%></TD>
		  <%if (CanEdit) {%>
			<TD class=Field><input class=InputStyle  type=text name="fgpicwidth" size=14
			onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'
			value="<%=Util.toScreenToEdit(fgpicwidth,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></TD>
		  <% }
			else {%>
		  	<TD class=Field><%=Util.toScreen(fgpicwidth,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></TD>
			<%}%>
        </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(209,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=InputStyle  name="fgpicfixtype" size="1" class=InputStyle>
				<option value="1" <%if (fgpicfixtype.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(211,user.getLanguage())%></option>
				<option value="2" <%if (fgpicfixtype.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(212,user.getLanguage())%></option>
				<option value="3" <%if (fgpicfixtype.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(213,user.getLanguage())%></option>
				<option value="4" <%if (fgpicfixtype.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(214,user.getLanguage())%></option>
		  </select>
		  </TD>
         </TR>    
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>                
        </TBODY></TABLE>
				
			</TD>
    <TD></TD>
    <TD vAlign=top>
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=50> <COL width=50> <TBODY> 
          <TR class=Title> 
            <TH><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
          </TR>
<TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(2008,user.getLanguage())%></td>
            <%int docmouldid = Util.getIntValue(docdefmouldid,0) ;
              String spanHTml = "";
          	  if(docmouldid!=0) {
                  spanHTml = "<a href='/docs/mould/DocMouldDsp.jsp?id="+docmouldid+"'>"+Util.toScreen(DocMouldComInfo.getDocMouldname(""+docmouldid),user.getLanguage())+"</a>";
              }
		  if (CanEdit) {%>
		  
            <td class=Field>
            	<!-- 
            	<button class=Browser onClick="onShowMould('docmouldidname','docdefmouldid')"></button> 
              
              <span id=docmouldidname>
              <%=spanHTml %>
              </span> 
               -->
              <input class="wuiBrowser" _displayText="<%=spanHTml %>" _url="/docs/mould/DocMouldBrowser.jsp" _displayTemplate="<a href='/docs/mould/DocMouldDsp.jsp?id=#b{id}'>#b{name}</a>" type=hidden name=docdefmouldid value="<%=docmouldid%>">
            </td>
            <% }
			else {%>
            <td class=Field><span id=docmouldidname>
              <% if(docmouldid!=0) {%>
              <a href="/docs/mould/DocMouldDsp.jsp?id=<%=docmouldid%>"> <%=Util.toScreen(DocMouldComInfo.getDocMouldname(""+docmouldid),user.getLanguage())%></a>
              <%}%>
              </span></td>
            <%}%>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<!--
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(3004,user.getLanguage())%></TD>
            <%
		  if (CanEdit) {%>
            <TD class=Field>
              <input class=InputStyle type=text size= 7  name=docapprovewfid value="<%=docapprovewfid%>">
            </TD>
            <% }
			else {%>
            <TD class=Field><%=docapprovewfid%></TD>
            <%}%>
          </TR>
-->
          </TBODY>
        </TABLE>
      </TD></TR></TBODY></TABLE></form>
  <script language=vbs>
sub onShowMould(tdname,inputename)
	id = window.showModalDialog("/docs/mould/DocMouldBrowser.jsp")
	document.all(tdname).innerHtml = "<a href='/docs/mould/DocMouldDsp.jsp?id="& id(0) & "'>" & id(1) & "</a>"
	document.all(inputename).value=id(0)
end sub
</script>  

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

</html>