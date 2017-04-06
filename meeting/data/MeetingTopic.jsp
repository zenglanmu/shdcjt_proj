<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));



%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int topicrows=0;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<FORM id=weaver name=weaver action="/meeting/data/MeetingTopicOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="edit">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" name="topicrows" value="0">
	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
            <Td align=right>
				<A href="#" onclick="javascript:addRow();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="#" onclick="javascript:if(isdel()){deleteRow1();}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>		
			</Td>
          </TR>
        <TR class=spacing>
          <TD class=Sep1 colspan=2></TD></TR>
        
        <tr><td colspan=2>
            <table class=liststyle cellspacing=1>
                <colgroup>
                <col width=4%>
                <col width=20%>
                <col width=20%>
                <col width=20%>
                <col width=20%>
                <col width=16%>
                <tr class=header>
                    <td>&nbsp;</td>
                    <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
                    <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
                    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
                    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
                    <td><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
                </tr>
                <TR class=Line><TD colspan="8" ></TD></TR> 

            </table>
        </td></tr>
        
        <TR>
          <TD colspan=2> 
	  <TABLE class=viewForm  cols=6 id="oTable" >
      	<COLGROUP>
      	<COL width="4%">
		<COL width="20%">
		<COL width="20%">
		<COL width="20%">
		<COL width="20%">
		<COL width="16%">
        <TBODY>
<%
RecordSet.executeProc("Meeting_Topic_SelectAll",meetingid);
while(RecordSet.next()){
%>
		<tr>
            <td class=Field><input class=inputstyle type='checkbox' name='check_node' value='0'><input class=inputstyle type='hidden' name='recordsetid_<%=topicrows%>' value='<%=RecordSet.getString("id")%>'></td>
            <td class=Field><input class=inputstyle type='input' style=width:99% name='topicsubject_<%=topicrows%>' value="<%=RecordSet.getString("subject")%>"></td>
            <td class=Field><button class=Browser onClick=onShowMHrm('topichrmids_<%=topicrows%>span','topichrmids_<%=topicrows%>')></button> <span class=inputStyle id=topichrmids_<%=topicrows%>span>
<%
	ArrayList arrayhrmids = Util.TokenizerString(RecordSet.getString("hrmids"),",");
	for(int i=0;i<arrayhrmids.size();i++){
%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayhrmids.get(i)%>'><%=ResourceComInfo.getResourcename(""+arrayhrmids.get(i))%></a>&nbsp
<%	
	}
%>			</span><input class=inputstyle type='hidden' name='topichrmids_<%=topicrows%>' id='topichrmids_<%=topicrows%>' value="<%=RecordSet.getString("hrmids")%>"></td>
			<td class=Field><button class=browser onclick=onShowMProj('topicprojid_<%=topicrows%>span','topicprojid_<%=topicrows%>')></button>
    			<span id="topicprojid_<%=topicrows%>span"><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a></span>
    			<input class=inputstyle type='hidden' name='topicprojid_<%=topicrows%>' id='topicprojid_<%=topicrows%>' value="<%=RecordSet.getString("projid")%>">
			</td>
			<td class=Field><button class=browser onclick=onShowMCrm('topiccrmid_<%=topicrows%>span','topiccrmid_<%=topicrows%>')></button>
    			<span id="topiccrmid_<%=topicrows%>span"><a href="/CRM/data/ViewCustomer.jsp?CrmID=<%=RecordSet.getString("crmid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmid")),user.getLanguage())%></a></span>
    			<input class=inputstyle type='hidden' name='topiccrmid_<%=topicrows%>' id='topiccrmid_<%=topicrows%>' value="<%=RecordSet.getString("crmid")%>">
			</td>
			<td class=Field><%if(RecordSet.getString("isopen").equals("1")){%><input class=inputstyle type=checkbox  checked  name='topicopen_<%=topicrows%>' value='1'><%}else{%><input class=inputstyle type=checkbox  name='topicopen_<%=topicrows%>' value='1'><%}%><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
		</tr>
<%
topicrows = topicrows +1;
}
%>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
</FORM>
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
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>  
function submitData() {
window.parent.close();
}
var rowColor="" ;
rowindex = "<%=topicrows%>";
function addRow()
{
	ncol = oTable.cols;
	rowColor = getRowBg();
	oRow = oTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99% name='topicsubject_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick=onShowMHrm('topichrmids_"+rowindex+"span','topichrmids_"+rowindex+"')></button> " + 
        					"<span class=inputStyle id=topichrmids_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topichrmids_"+rowindex+"' id='topichrmids_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick=onShowMProj('topicprojid_"+rowindex+"span','topicprojid_"+rowindex+"')></button> " + 
        					"<span class=inputStyle id=topicprojid_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topicprojid_"+rowindex+"' id='topicprojid_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick=onShowMCrm('topiccrmid_"+rowindex+"span','topiccrmid_"+rowindex+"')></button> " + 
        					"<span class=inputStyle id=topiccrmid_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topiccrmid_"+rowindex+"' id='topiccrmid_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='topicopen_"+rowindex+"' value='1'>¹«¿ª"; //ºº×Ö
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
		}
	}
	rowindex = rowindex*1 +1;
	
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function doSave(){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.topicrows.value=rowindex;
		document.weaver.submit();
	}
}
</script>
<script language=vbs>

sub onShowHrm(spanname,inputename,needinput)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml= "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	document.all(inputename).value=id(0)
	else 
	if needinput = "1" then
	document.all(spanname).innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else
	document.all(spanname).innerHtml= ""
	end if
	document.all(inputename).value=""
	end if
	end if
end sub

sub onShowMProj(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	document.all(inputname).value=id(0)
	else 
	document.all(spanname).innerHtml =""
	document.all(inputname).value="0"
	end if
	end if
end sub

sub onShowMHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)

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
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if

end sub

sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
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
						sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
end sub

sub onShowDoc(spanname,inputename)
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		document.all(spanname).innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		document.all(inputename).value=id(0)&""
	end if	
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
