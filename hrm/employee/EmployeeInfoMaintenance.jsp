<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String sql_1 = "select hrmid from HrmInfoMaintenance where id =1 ";
rs.executeSql(sql_1);
rs.next();
String hrmid_1=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_2 = "select hrmid from HrmInfoMaintenance where id =2 ";
rs.executeSql(sql_2);
rs.next();
String hrmid_2=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_3 = "select hrmid from HrmInfoMaintenance where id =3 ";
rs.executeSql(sql_3);
rs.next();
String hrmid_3=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_4 = "select hrmid from HrmInfoMaintenance where id =4 ";
rs.executeSql(sql_4);
rs.next();
String hrmid_4=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_5 = "select hrmid from HrmInfoMaintenance where id =5 ";
rs.executeSql(sql_5);
rs.next();
String hrmid_5=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_6 = "select hrmid from HrmInfoMaintenance where id =6 ";
rs.executeSql(sql_6);
rs.next();
String hrmid_6=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_7 = "select hrmid from HrmInfoMaintenance where id =7 ";
rs.executeSql(sql_7);
rs.next();
String hrmid_7=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_8 = "select hrmid from HrmInfoMaintenance where id =8 ";
rs.executeSql(sql_8);
rs.next();
String hrmid_8=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_9 = "select hrmid from HrmInfoMaintenance where id =9 ";
rs.executeSql(sql_9);
rs.next();
String hrmid_9=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_10 = "select hrmid from HrmInfoMaintenance where id =10 ";
rs.executeSql(sql_10);
rs.next();
String hrmid_10=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6137,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=resource id=resource action="/hrm/employee/EmployeeMainOperation.jsp" method=post>
<TABLE class=ViewForm>
 <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR> 
<TD><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>£­<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>£º</TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=hrmid_1
            type=hidden name=hrmid_1 value="<%=hrmid_1%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
			_displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			_displayText="<a target='_blank' href='/hrm/resource/HrmResource.jsp?id=<%=hrmid_1%>'>
                <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_1),user.getLanguage())%>
                </a>">
            </TD>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%if(software.equals("ALL") || software.equals("HRM")){%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>£­<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>£º</TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=hrmid_2
            type=hidden name=hrmid_2  value="<%=hrmid_2%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
			_displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			_displayText="<a target='_blank' href='/hrm/resource/HrmResource.jsp?id=<%=hrmid_2%>'>
                <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_2),user.getLanguage())%>
                </a>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%}%>
<%if(software.equals("ALL")){%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15806,user.getLanguage())%>£­<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>£º</TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=hrmid_3
            type=hidden name=hrmid_3   value="<%=hrmid_3%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
			_displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			_displayText="<a target='_blank' href='/hrm/resource/HrmResource.jsp?id=<%=hrmid_3%>'>
                <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_3),user.getLanguage())%>
                </a>">
            </TD>
          </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	 <!--TD9064-->
          <!--TR> 
            <TD><b><%=SystemEnv.getHtmlLabelName(15807,user.getLanguage())%>£º</b></TD>
            <TD class=Field><BUTTON class=Browser id=SelectHrmid_10 onClick="onShowHrmid_10()"></BUTTON> 
              <span 
            id=hrmid_10span><%if(hrmid_10.equals("")){%><img src="/images/BacoError.gif"
            align=absMiddle><%}%>
             <a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid_10%>">
            <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_10),user.getLanguage())%>
            </a>
            </span>
              <INPUT class=inputStyle id=hrmid_10
            type=hidden name=hrmid_10  value="<%=hrmid_10%>">
            </TD>
          </TR-->

<%}%>
<tr><td colspan=2>

<%=SystemEnv.getHtmlLabelName(15168,user.getLanguage())%>£º
</td></tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr><td colspan=2>
<%=SystemEnv.getHtmlLabelName(21744,user.getLanguage())%>
</td></tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr><td colspan=2>
<%=SystemEnv.getHtmlLabelName(21745,user.getLanguage())%>
</td></tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr><td colspan=2>
<%=SystemEnv.getHtmlLabelName(21746,user.getLanguage())%>
</td></tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr><td colspan=2>
<%=SystemEnv.getHtmlLabelName(21747,user.getLanguage())%>
</td></tr>
</TBODY> 
</TABLE>
</TD>
 </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbs>
sub onShowHrmid_1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_1span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_1.value=id(0)
	else 
	hrmid_1span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_1.value=""
	end if
	end if
end sub

sub onShowHrmid_2()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_2span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_2.value=id(0)
	else 
	hrmid_2span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_2.value=""
	end if
	end if
end sub

sub onShowHrmid_3()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_3span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_3.value=id(0)
	else 
	hrmid_3span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_3.value=""
	end if
	end if
end sub
sub onShowHrmid_4()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_4span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_4.value=id(0)
	else 
	hrmid_4span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_4.value=""
	end if
	end if
end sub
sub onShowHrmid_5()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_5span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_5.value=id(0)
	else 
	hrmid_5span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_5.value=""
	end if
	end if
end sub
sub onShowHrmid_6()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_6span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_6.value=id(0)
	else 
	hrmid_6span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_6.value=""
	end if
	end if
end sub
sub onShowHrmid_7()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_7span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_7.value=id(0)
	else 
	hrmid_7span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_7.value=""
	end if
	end if
end sub
sub onShowHrmid_8()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_8span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_8.value=id(0)
	else 
	hrmid_8span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_8.value=""
	end if
	end if
end sub
sub onShowHrmid_9()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_9span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_9.value=id(0)
	else 
	hrmid_9span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_9.value=""
	end if
	end if
end sub

sub onShowHrmid_10()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_10span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_10.value=id(0)
	else 
	hrmid_10span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.hrmid_10.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript">
function OnSubmit(obj){    if(check_form(document.resource,"hrmid_1,hrmid_2,hrmid_3,hrmid_4,hrmid_5,hrmid_6,hrmid_7,hrmid_8,hrmid_9,hrmid_10")) {	
	obj.disabled=true;
	document.resource.submit();
	}
}
</script>
</BODY>
</HTML>