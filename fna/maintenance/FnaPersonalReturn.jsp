<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<% if(!HrmUserVarify.checkUserRight("FinanceWriteOff:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
	RecordSet rs = new RecordSet();
	rs.executeSql("select detachable from SystemSet");
	int detachable=0;
	if(rs.next()){
	    detachable=rs.getInt("detachable");
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language=javascript src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16506,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_TOP} " ;
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
<FORM id=weaver name=frmmain method=post action="FnaPersonalReturnOperation.jsp" >
<INPUT type="hidden" name="operation" value="add">
    <%

    String organizationid=Util.null2String(request.getParameter("organizationid"));
    String organizationtype=Util.null2String(request.getParameter("organizationtype"));
    String showname="";
    if(organizationtype.equals("3")){
                                showname = "<A href='/hrm/resource/HrmResource.jsp?id="+organizationid+"'>"+Util.toScreen(ResourceComInfo.getLastname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("2")){
                                showname = "<A href='/hrm/company/HrmDepartment.jsp?id="+organizationid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("1")){
                                showname = "<A href='/hrm/company/HrmSubCompany.jsp?id="+organizationid+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())+"</A>";
                                }


    %>
<TABLE class=ViewForm>
    <COL width=15%><COL width=35%><COL width=15%><COL width=35%>
    <TR class=Title><TH colspan=4><%=SystemEnv.getHtmlLabelName(17390,user.getLanguage())%></TH></TR>
    <TR class=Spacing style="height:2px"><TD class=Line1 colSpan=4></TD></TR>
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(18797,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
        <TD class=field>
            <select id='organizationtype' name='organizationtype' onchange='clearSpan()'>
                <option value=3 <%if(organizationtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
                <option value=2 <%if(organizationtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value=1 <%if(organizationtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option></select>
                <button class=Browser type="button" onclick='onShowOrganization(organizationspan,organizationid)'></button>
                <span id='organizationspan'>
                   <%=showname%>
                    <%
                        if (organizationid.equals("")) {
                    %>
                     <img src="/images/BacoError.gif" align=absmiddle>
                   <%
                        }
                   %>
                </span>
                   <input type=hidden id='organizationid' name='organizationid' value=<%=organizationid%>>
        </TD>
       <TD><%=SystemEnv.getHtmlLabelName(15394,user.getLanguage())%></TD>
        <TD class=field>
            <BUTTON class=calendar type="button" onclick="onShowDate(occurdatespan,occurdate)"></BUTTON>
            <SPAN id=occurdatespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
            <INPUT type=hidden name="occurdate">
        </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></TD>
        <TD class=field>
        	<select name="operationtype">
        		<option value="0"><%=SystemEnv.getHtmlLabelName(24862,user.getLanguage())%></option>
        		<option value="1"><%=SystemEnv.getHtmlLabelName(24861,user.getLanguage())%></option>
        	</select>
        </TD>
        <TD><%=SystemEnv.getHtmlLabelName(15395,user.getLanguage())%></TD>
        <TD class=field>
            <INPUT class=inputstyle type=text name="amount" size=10 onKeyPress="ItemNum_KeyPress()" 
            onBlur="checknumber1(this);checkinput('amount','amountspan')">
            <SPAN id="amountspan"><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
        </TD>
    </TR>
    <TR style="height: 1px;"><TD class=Line colSpan=4></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></TD>
        <TD class=field>
            <INPUT class=inputstyle type=text size=30 name="debitremark" onchange="checkinput('debitremark','debitremarkspan')">
            <SPAN id="debitremarkspan"><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
        </TD>
        <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
        <TD class=field>
            <BUTTON class=browser type="button" onclick="onShowRequest()"></BUTTON>
            <SPAN id="requestspan"></SPAN>
            <INPUT class=inputstyle type=hidden name="requestid" >
        </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
        <TD colspan=3 class=field>
            <TEXTAREA class=inputstyle name="summary" style="width:80%" rows=3></TEXTAREA>
        </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</TABLE>

<table class=ListStyle cellspacing=0 >
    <col width=15%>
    <col width=10%>
    <col width=15%>
    <col width=25%>
    <col width=35%>
    <tr class=Header><th colspan=5><%=SystemEnv.getHtmlLabelName(18798,user.getLanguage())%></th></tr>
    <TR class=Spacing style="height: 1px;"><TD class=Line colSpan=5 style="padding: 0px;"></TD></TR>

    <tr class=header>
        <td><%=SystemEnv.getHtmlLabelName(15397,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(15398,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(793,user.getLanguage())%></td>
    </td></tr>

<%
    if( ! organizationid.equals("") ) {
		//"order by occurdate" added by lupeng 2004.05.13 for TD448.
        String sql="select * from fnaloaninfo where organizationtype="+organizationtype+" and organizationid="+organizationid+" order by occurdate";
        boolean islight=true;
        RecordSet.executeSql(sql);
        while(RecordSet.next()){
            String tmpid= Util.null2String( RecordSet.getString("id") ) ;
            String tmprequestid= Util.null2String( RecordSet.getString("requestid") ) ;
            String tmprequestname= Util.null2String( RequestComInfo.getRequestname(tmprequestid));
            String tmpamount= Util.null2String( RecordSet.getString("amount") ) ;
            String tmpoccurdate= Util.null2String( RecordSet.getString("occurdate") ) ;
            String tmpdebitremark= Util.null2String( RecordSet.getString("debitremark") ) ;
            String tmptype= Util.null2String( RecordSet.getString("loantype") ) ;
            String manager= Util.null2String( RecordSet.getString("processorid") ) ;

            if(!tmptype.equals("1")) tmpamount = ""+Util.getDoubleValue(tmpamount,0) ;
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark<%}%>>
        <td><%=tmpoccurdate%></td>
        <td><%if(Util.getDoubleValue(tmpamount,0)<=0){%><%=SystemEnv.getHtmlLabelName(24862,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(24861,user.getLanguage())%><%}%></td>
        <td><font color=<%if(Util.getDoubleValue(tmpamount,0)<=0){%>red<%}else{%>blue<%}%>><%=Math.abs(Util.getDoubleValue(tmpamount,0))%></font></td>
        <td><A href="FnaPersonalReturnView.jsp?paraid=<%=tmpid%>">No:<%=tmpdebitremark%></A></td>
        <td>
        <%if(tmptype.equals("2")){%><%=SystemEnv.getHtmlLabelName(15399,user.getLanguage())%> (æ≠∞Ï»À:<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>)<%} else {%>
        <a href="/workflow/request/ViewRequest.jsp?requestid=<%=tmprequestid%>">
        <%=tmprequestname%></a>
        <%}%>
        </td>
    </tr>
<%  
            islight=!islight;
        }
    

        String loanamount= "" ;
        RecordSet.executeSql("select sum(amount) as amount from fnaloaninfo where organizationtype="+organizationtype+" and organizationid="+organizationid);
        if( RecordSet.next() ) loanamount= Util.null2String( RecordSet.getString("amount") );
%>
    <tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
        <td><%=SystemEnv.getHtmlLabelName(18801,user.getLanguage())%></td>
        <td>&nbsp;</td>
        <td><font color=<%if(Util.getDoubleValue(loanamount,0)<=0){%>red<%}else{%>blue<%}%>><%=Math.abs(Util.getDoubleValue(loanamount,0))%></font></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
<%  }   %>
</TABLE>
</FORM>
</TD>
</TR>
</TABLE>
</TD>
<TD></TD>
</TR>
<TR style="height:0px">
<TD height="0" colspan="3"></TD>
</TR>
</TABLE>
<!--
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	frmmain.action="FnaPersonalReturn.jsp"
    frmmain.submit()
	else 
	resourcespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowDoc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	docspan.innerHtml = "<A href='/docs/docs/DocDetail.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.docid.value=id(0)
	else 
	docspan.innerHtml = ""
	frmmain.docid.value=""
	end if
	end if
end sub

sub onShowRequest()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	requestspan.innerHtml = "<A href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="&id(0)&"' target='_blank'>"&id(1)&"</A>"
	frmmain.requestid.value=id(0)
	else 
	requestspan.innerHtml = ""
	frmmain.requestid.value=""
	end if
	end if
end sub
</script>-->
<script language=javascript>
function doRefresh(){
    
}
function submitData() {
if(check_form(frmmain,'resourceid,name,occurdate,amount,debitremark')){
 document.forms[0].submit();
}
}

function onShowRequest(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp");
	if (data!=null){
		if (data.id != ""){
			jQuery("#requestspan").html("<A href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+data.id+"' target='_blank'>"+data.name+"</A>");
			jQuery("input[name=requestid]").val(data.id);
		}else{ 
			jQuery("#requestspan").html("");
			jQuery("input[name=requestid]").val("");
		}
	}
}

function clearSpan() {
    jQuery("#organizationspan").html("");
    jQuery("input[name=organizationid]").val("");
}
function onShowOrganization(spanname, inputname) {
    if (jQuery("select[name=organizationtype]" ).val() == "3")
        return onShowHR(spanname, inputname);
    else if (jQuery("select[name=organizationtype]" ).val() == "2")
        return onShowDept(spanname, inputname);
    else if (jQuery("select[name=organizationtype]" ).val() == "1")
        return onShowSubcom(spanname, inputname);
    else
        return null;
}
function onShowHR(spanname, inputname) {
	try {
	if (<%=detachable%> == 1) {
    	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByDecDet.jsp?rightStr=FinanceWriteOff:Maintenance");
    } else {
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");    
    }
    if (data != null) {
        if (data.id != "0") {
            jQuery(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp";
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	 } catch(e) {
        return;
    }
}

function onShowDept(spanname, inputname) {
	try {
		if (<%=detachable%> == 1) {
	    	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowserByDec.jsp?rightStr=FinanceWriteOff:Maintenance&selectedids="+jQuery(inputname).val());
	    } else {
			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery(inputname).val());    
	    }
    
    if (data != null) {
        if (data.id != "0") {
            jQuery(spanname).html("<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp";
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	} catch(e) {
        return;
    }
}
function onShowSubcom(spanname, inputname) {
	try {
		if (<%=detachable%> == 1) {
	    	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp?rightStr=FinanceWriteOff:Maintenance&selectedids="+inputname.value);
	    } else {
			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+inputname.value);    
	    }
    if (data != null) {
        if (data.id != "0") {
            jQuery(spanname).html("<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp" ;
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	 } catch(e) {
        return;
    }
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>