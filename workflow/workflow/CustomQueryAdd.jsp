<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
String needfav ="1";
String needhelp ="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
String Querytypeid=Util.null2String(request.getParameter("Querytypeid"));
Querytypeid = (Util.getIntValue(Querytypeid,0)<=0)?"":Querytypeid;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<iframe id="workFlowIFrame" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post >

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>


<%
// }
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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>

    <TR class="Spacing" style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
									          	<TD class=Field>
									        		<INPUT type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' value="">
									          		<SPAN id=Customnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<TR>
									    	<%
									    	String name="";
									    	if(!Querytypeid.equals("")){
									              		RecordSet.executeSql("select * from workflow_customQuerytype where id="+Querytypeid);
									              	
									              		while(RecordSet.next()){
									              			name=RecordSet.getString("typename");
									              		}
									              		//out.print(name);
									              	}
									    		%>
									      		<TD><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TD>
									      		<td>
									              	<INPUT class="wuiBrowser" type=hidden _displayText="<%=name %>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/QueryTypeBrowser.jsp" name=Querytypeid id=Querytypeid value="<%=Querytypeid %>" _required="yes" >
									            </TD>
									        </TR>
									        <TR class="Spacing" style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<% if(detachable==1){ %>
									    	 <tr>
       											 <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
        										 <td  class=field >
        												<INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid %>" _required="yes"
            												_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1"
            												_displayText="<%=subcompanyid.equals("")?"":SubComanyComInfo.getSubCompanyname(subcompanyid) %>"
            												>
            											
        										 </td>
    										</tr>
    										<TR class="Spacing" style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<% } %>
									  		<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD>
									      		<TD class=Field>
                                                    <BUTTON class=Browser type="button" onclick="onShowFormOrBill(isBill, formID, formIDImage)"></BUTTON>
                                                    <SPAN id=formIDImage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
									            	<INPUT type=hidden name=formID id=formID value="">
									            	<INPUT type=hidden name=isBill id=isBill value="">
									            </TD>
									        </TR>

									        <TR class="Spacing" style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									        <%
                                                String outputWorkFlowName="<font color=red>"+SystemEnv.getHtmlLabelName(23801,user.getLanguage())+"</font>";
									        %>
									    	<TR id = "workFlowIDDIV" style="display:none;">
                                                  <TD width="20%" style="border-bottom:1px solid rgb(216, 236, 239);"><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></TD>
                                                  <TD width="80%" class=Field style="border-bottom:1px solid rgb(216, 236, 239);">
                                                      <BUTTON class=Browser type="button" onclick="onShowWorkFlow(workflowids, workflowIDsSpan)"></BUTTON>
                                                      <SPAN id=workflowIDsSpan><%=outputWorkFlowName%></SPAN>
                                                      <INPUT type=hidden name=workflowids id=workflowids value="">
                                                  </TD>
									        </TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <textarea rows="4" cols="80" name="Customdesc" class=Inputstyle></textarea>
                                              </TD>
                                            </TR>
                                            <TR class="Spacing" style="height: 1px">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
    
    
    <input type="hidden" name=operation value=customadd>
 </TBODY></TABLE>
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

<SCRIPT LANGUAGE="javascript">
function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids="+weaver.subcompanyid.value)
	var issame = false
	if (data){
		if (data.id!="0"){
			if (data.id == weaver.subcompanyid.value){
				issame = true
			}
			subcompanyspan.innerHTML = data.name
			weaver.subcompanyid.value=data.id
		}else{
			subcompanyspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			weaver.subcompanyid.value=""
		}
	}
}

function onShowFormOrBill(isBill, inputName, spanName){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp")
	
	if (data){
		if(data.id!=""){
			isBill.value = data.isBill;
			inputName.value = data.id;
			spanName.innerHTML = data.name;
			showDiv("1")
			document.all("workflowids").value = ""
			document.all("workflowIDsSpan").innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(23801,user.getLanguage())%></font>"
		}else{
			spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			isBill.value = ""
			inputName.value = ""
			showDiv("0")
		}
	}
}

function onShowWorkFlow(workflowIDHidden, workflowIDSpan){
var isBill = $G("isBill").value
var formID = $G("formID").value
var workflowids = $G("workflowids").value
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp?value=" + isBill + "_" + formID + "_" + workflowids;
	data = window.showModalDialog(url)
	if (data){
		if (data.id!=""){
			resourceids = data.id
			resourcename = data.name
			var sHtml = ""
			
			if (resourceids.indexOf(",") == 0) {
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			workflowIDHidden.value= resourceids
			ids = resourceids.split(",");
			names =resourcename.split(",");
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;";
				}
			}
		
			workflowIDSpan.innerHTML = sHtml
		}else{
			workflowIDHidden.value = ""
			workflowIDSpan.innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(23801,user.getLanguage())%></font>"
		}
	}
}


function submitData()
{
	var checkfields = "";
	<% if(detachable==1){ %>
		checkfields = 'Customname,Querytypeid,formID,subcompanyid';
	<%}else{%>
		checkfields = 'Customname,Querytypeid,formID';
	<%}%>
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }
}

function submitIFrame()
{
	document.all("workFlowIFrame").src = "WorkFlowofFormIFrame.jsp?isBill=" + document.all("isBill").value + "&formID=" + document.all("formID").value;
}

function showDiv(isShow)
{
	if("1" == isShow)
	{
		document.all("workFlowIDDIV").style.display = "block";
	}
	else
	{
		document.all("workFlowIDDIV").style.display = "none";
	}
}
function doback(){
    enableAllmenu();
    <%if(detachable==1){%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>&subcompanyid=<%=subcompanyid%>";
    <%}else{%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>";
    <%}%>
}
</SCRIPT>

</BODY></HTML>
