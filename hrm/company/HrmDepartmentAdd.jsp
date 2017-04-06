<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

//int supdepid = Util.getIntValue(request.getParameter("supdepid"),0);
//String departmentmark=Util.null2String(request.getParameter("departmentmark"));
//String departmentname=Util.null2String(request.getParameter("departmentname"));
//int showorder = Util.getIntValue(request.getParameter("showorder"),0);
//String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
 
String departmentmark=Util.null2String((String)session.getAttribute("departmentmark"));
String departmentname=Util.null2String((String)session.getAttribute("departmentname"));
int showorder= Util.getIntValue((String)session.getAttribute("showorder"),0);
int supdepid=Util.getIntValue((String)session.getAttribute("supdepid"),0);
String subcompanyid=Util.null2String((String)session.getAttribute("subcompanyid"));

session.removeAttribute("departmentmark");
session.removeAttribute("departmentname");
session.removeAttribute("showorder");
session.removeAttribute("supdepid");
session.removeAttribute("subcompanyid");

if(supdepid==0){
	 supdepid = Util.getIntValue(request.getParameter("supdepid"),0);
}
if("".equals(subcompanyid) || subcompanyid ==null){
	subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
}

int coadjutant= Util.getIntValue(request.getParameter("coadjutant"),0);
/*Added by Charoes Huang ,For bug 517*/
String[] strObj = null ;
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	try{	
		strObj = (String[])request.getSession().getAttribute("Department.level.error");
		if(strObj != null){
			errorMsg = SystemEnv.getHtmlLabelName(17428,user.getLanguage());
		}
	}catch(Exception e){}
}else{
	request.getSession().removeAttribute("Department.level.error");
}

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

<FORM id=weaver name=frmMain action="DepartmentOperation.jsp" method=post>
  <TABLE class=ViewForm width="100%">
    <TBODY>
   
    <COLGROUP> 
    <COL width="48%"> 
    <COL width=24> 
    <COL width="48%"> 
 <%
if(msgid!=-1){
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>

	<%if(!"".equals(errorMsg)){
		/*部门不能超过10级*/
		%>
	<TR>
		<TD colspan = "3">
			<li><font color="red">
				<%=errorMsg%>
			</font></li>
		</TD>
	</TR>
   <%}%>

    <TR class=Title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      <TD>&nbsp;</TD>
      <TH><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
    </TR>
    <TR vAlign=top> 
      <TD> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="40%"> <COL width="60%"> <TBODY> 
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <INPUT class=InputStyle  name=departmentmark maxLength=60  onblur="checkLength('departmentmark',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("departmentmark","departmentmarkimage")' <%if(msgid>0){%>value="<%=(strObj==null?departmentmark:strObj[0])%>"<%}else{%>value="<%=(strObj==null?"":strObj[0])%>"<%}%>>
              <SPAN id=departmentmarkimage>
			  <%if("".equals(errorMsg) && departmentmark.trim().equals("")){%>
			  <IMG src="/images/BacoError.gif" align=absMiddle>
			  <%}%>
			  </SPAN>
              </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
            <TD class=FIELD><nobr> 
              <INPUT class=InputStyle  name=departmentname maxLength=60  onblur="checkLength('departmentname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("departmentname","departmentnameimage")' <%if(msgid>0){%>value="<%=(strObj==null?departmentname:strObj[1])%>"<%}else{%>value="<%=(strObj==null?"":strObj[1])%>"<%}%>>
              <SPAN id=departmentnameimage>
			  <%if("".equals(errorMsg) && departmentname.trim().equals("")){%>
			  <IMG src="/images/BacoError.gif" align=absMiddle>
			  <%}%>
			  </SPAN>
			  
			  </TD>
          </TR>          
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15772,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=departmentid type=hidden name=supdepid value="<%=supdepid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp"
			  _displayText="<%=DepartmentComInfo.getDepartmentname(""+supdepid)%>">                           
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=coadjutant type=hidden name=coadjutant value="<%=coadjutant%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp"
			  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _displayText="<%=ResourceComInfo.getLastname(""+coadjutant)%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=InputStyle name=showorder size=4 maxlength=4  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("showorder")' onchange='checkinput("showorder","showorderimage")' value="<%=(strObj==null?""+showorder:strObj[4])%>">
              <SPAN id=showorderimage></SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=departmentcode size=20 maxlength=100 value="">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%></TD>
            <TD class=Field>

            	<input class="wuiBrowser" id="zzjgbmfzr" name="zzjgbmfzr" value="" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;">

            </TD>
          </TR>
          <TR style="height:1px;display:none"  style="display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%></TD>
            <TD class=Field>
				
				<input class="wuiBrowser" id="zzjgbmfgld" name="zzjgbmfgld" value="" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%></TD>
            <TD class=Field>
				
				<input class="wuiBrowser" id="jzglbmfzr" name="jzglbmfzr" value="" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%></TD>
            <TD class=Field>
			
				<input class="wuiBrowser" id="jzglbmfgld" name="jzglbmfgld" value="" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;">
			
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>

          </TBODY> 
        </TABLE>
      </TD>
      <TD>&nbsp;</TD>
      <TD> 
        <table class=ViewForm width="100%">
          <colgroup> <col width="40%"> <col width="60%"> 
          <tr class=Spacing style="height:2px"> 
            <td class=Line1 colspan=2></td>
          </tr>
          
         <%
         
         //while(CompanyComInfo.next()){
         	//subcompanyid +=1;
         	//String curid=CompanyComInfo.getCompanyid();
         	CompanyComInfo.next();
         	String curname = CompanyComInfo.getCompanyname();
         %>
         <tr> 
            <td><%=curname%></td>
            <td class=FIELD> 
             
              <INPUT class="wuiBrowser" id=subcompanyid1 type=hidden name=subcompanyid1 value="<%=subcompanyid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp"
			  _displayText="<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)%>"
			  _required="yes" _callback="changeValue()">
              <INPUT id=subcompanyid1old type=hidden name=subcompanyid1old value="<%=subcompanyid%>">
            </td>
          </tr>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
         <%
         // break;
         //}%>
        </table>
      </TD>
    </TR>
          
  </TABLE>
   <input class=inputstyle type=hidden name=operation value="add">
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
<script language=javascript>
function submitData() {
if(check_form(frmMain,'departmentmark,departmentname,showorder,subcompanyid1')){
 frmMain.submit();
}
}

function changeValue(){
	jQuery("#subcompanyid1old").val(jQuery("#subcompanyid1").val());
}
</script>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?allselect=all&notCompany=1&rightStr=HrmDepartmentAdd:Add&isedit=1&subcompanyid="&frmMain.subcompanyid1old.value&"&selectedids="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	if id(0) = frmMain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmMain.departmentid.value=""
	end if
	end if
end sub
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?allselect=all&rightStr=HrmSubCompanyAdd:Add&isedit=1&selectedids="&frmMain.subcompanyid1.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	if id(0) = frmMain.subcompanyid1.value then
		issame = true
	end if
	subcompanyspan.innerHtml = id(1)
	frmMain.subcompanyid1.value=id(0)
	else
	subcompanyspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.subcompanyid1.value=""
	end if
	end if
	if frmMain.subcompanyid1old.value <> frmMain.subcompanyid1.value then
		departmentspan.innerHtml = ""
		frmMain.departmentid.value=""
	end if

	frmMain.subcompanyid1old.value = frmMain.subcompanyid1.value
end sub
sub onShowMHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
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
						sHtml = sHtml&"<a href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
			end if
end sub
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmDepartmentAdd:Add")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	coadjutantspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmMain.coadjutant.value=id(0)
	else
	coadjutantspan.innerHtml = ""
	frmMain.coadjutant.value=""
	end if
	end if
end sub    
</script>
</BODY>
</HTML>