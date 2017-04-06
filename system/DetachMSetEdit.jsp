<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
RecordSet.executeProc("SystemSet_Select","");
RecordSet.next();
String detachable= Util.null2String(RecordSet.getString("detachable"));

//String appdetachable = Util.null2String(RecordSet.getString("appdetachable"));

int dftsubcomid=Util.getIntValue(RecordSet.getString("dftsubcomid"),0);

boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(18581,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SystemSetOperation.jsp">
<input type="hidden" name=operation  value="detachmanagement">
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

			  <% if(canedit) { %>
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17862,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=detachable  value="1" <% if(detachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="changeDiv()">
				  </td>
				</tr>
<%--
				<TR class=Spacing>
				  <TD class=Line colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(24327,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=appdetachable  value="1" <% if(appdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
--%>
                <div id=beforeDiv style="display:<%if (detachable.equals("1")) {%>''<%} else {%>'none'<%}%>">
                <TABLE class=ViewForm>
                <COLGROUP>
                <COL width="20%">
                <COL width="80%">

                <TBODY>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				    <td><%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%></td>
                    <TD class=Field>
                        <button type=button  class=Browser id=SelectSubcomany onclick="onShowSubcompany()"></BUTTON> 
                        <SPAN id=supsubcomspan>                
                            <%if(dftsubcomid>0){%>     
                                <%=SubComanyComInfo.getSubCompanyname(""+dftsubcomid)%>
                            <%}%>           
                        </SPAN> 
                        <input class=inputstyle id=dftsubcomid type=hidden name=dftsubcomid value="<%=dftsubcomid%>">  
                    </TD>
				</tr>
                    </TBODY>
                    </TABLE>
                </div>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				</TBODY>
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
  </FORM>
</BODY>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowSubcompany() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $GetEle("dftsubcomid").value
			, $GetEle("supsubcomspan")
			, $GetEle("dftsubcomid")
			, true);
}
</script>

<script language="javascript">
    function onSubmit()
    {
        frmMain.submit();
    }

    function changeDiv(){
        if ($GetEle("beforeDiv").style.display == "")
        $GetEle("beforeDiv").style.display = 'none' ;
        else 
        $GetEle("beforeDiv").style.display = ''	;
    }
</script>

</HTML>
