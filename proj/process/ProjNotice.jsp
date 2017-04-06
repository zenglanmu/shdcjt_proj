<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
    String ProjID = request.getParameter("ProjID");
    
    String Memname="";
    RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
    RecordSet.next();

    String members = RecordSet.getString("members");
    ArrayList Members_proj = Util.TokenizerString(members,",");
    int Membernum = Members_proj.size();
    for(int i=0;i<Membernum;i++){
        Memname= Memname+""+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage());
        Memname+=" ";
    }
%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-2),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver NAME=weaver STYLE="margin-bottom:0" action="/proj/plan/PlanOperation.jsp" method=post>

<input type=hidden name="ProjID" value="<%=ProjID%>">
<input type=hidden name="method" value="tellmember">

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


<table width=100% class=viewform>



<tr class=header>
    <td width=20%><%=SystemEnv.getHtmlLabelName(15280,user.getLanguage())%></td>
    <TD class=Field>
        <input class="wuiBrowser" type=hidden name="hrmids02" value="<%=members%>" _param="resourceids"
        	_displayText="<%=Memname %>"
        	_url="/systeminfo/BrowserMain.jsp?url=/proj/process/MutiResourceBrowser_proj.jsp?ProjID=<%=ProjID %>">
    </TD> 
</tr><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<tr class=header >
    <td width=20%><%=SystemEnv.getHtmlLabelName(15281,user.getLanguage())%></td>
     <TD class=Field><INPUT class=inputstyle maxLength=100 size=40 name="noticetitle" onchange='checkinput("noticetitle","spannoticetitle")'> <SPAN id=spannoticetitle><IMG src="/images/BacoError.gif"align=absMiddle></SPAN></TD>
	 
    </TD> 
</tr><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
 <TR class="Header">
   <TD><%=SystemEnv.getHtmlLabelName(15282,user.getLanguage())%></TD>

   <TD class=Field><TEXTAREA class=inputstyle name="noticecontent" ROWS=8 STYLE="width:99%" onchange='checkinput("noticecontent","spannoticecontent")' ></TEXTAREA><SPAN id=spannoticecontent><IMG src="/images/BacoError.gif"align=absMiddle></SPAN></td>
  
 </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
</table>
<TABLE ID=BrowseTable class=Data STYLE="margin-top:0">


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

</FORM></BODY></HTML>


<SCRIPT LANGUAGE=VBS>
sub onShowMHrm(spanname,inputename,prjid)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/MutiResourceBrowser_proj.jsp?resourceids="&tmpids&"&ProjID="&prjid)
        if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml ="<IMG src='/images/BacoError.gif' align=absMiddle>"
					document.all(inputename).value=""
				end if
        end if
end sub



</SCRIPT>
<script language=javascript>
function doSave(){
	if(check_form(document.weaver,'hrmids02,noticetitle,noticecontent')){	    
		document.weaver.submit();
        window.parent.close();
	}
}

</SCRIPT>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'hrmids02,noticetitle,noticecontent'))
		weaver.submit();
}
</script>