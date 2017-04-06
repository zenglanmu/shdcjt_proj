<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ResourceUtil" class="weaver.hrm.resource.ResourceUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog.js"></script>
</head>
<%
int departid = Util.getIntValue(request.getParameter("id"),1);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
rs.executeProc("HrmDepartment_SelectByID",""+departid);
String departmentmark="";
String departmentname="";
String subcompanyid1="";
String allsupdepid = "";
int supdepid = 0;
int showorder = 0;
String departmentcode = "";
int coadjutant=0;    
String zzjgbmfzr = "";//组织机构部门负责人
String zzjgbmfgld = "";//组织机构部门分管领导
String jzglbmfzr = "";//矩阵管理部门负责人
String jzglbmfgld = "";//矩阵管理部分分管领导
if(rs.next()){
	departmentmark = rs.getString(2);
	departmentname = rs.getString(3);
	supdepid = Util.getIntValue(rs.getString("supdepid"),0);
	allsupdepid = rs.getString("allsupdepid");
	subcompanyid1 = rs.getString("subcompanyid1");
	showorder = Util.getIntValue(rs.getString("showorder"),0);
	departmentcode = Util.toScreen(rs.getString("departmentcode"),user.getLanguage());
    coadjutant = Util.getIntValue(rs.getString("coadjutant"),0);
    zzjgbmfzr = Util.null2String(rs.getString("zzjgbmfzr"));//组织机构部门负责人
    zzjgbmfgld = Util.null2String(rs.getString("zzjgbmfgld"));//组织机构部门分管领导
    jzglbmfzr = Util.null2String(rs.getString("jzglbmfzr"));//矩阵管理部门负责人
    jzglbmfgld = Util.null2String(rs.getString("jzglbmfgld"));//矩阵管理部分分管领导
}
if(msgid>0){
    //departmentmark=Util.null2String(request.getParameter("departmentmark"));
    //departmentname = Util.null2String(request.getParameter("departmentname"));
    //supdepid=Util.getIntValue(request.getParameter("supdepid"),0);
    //showorder=Util.getIntValue(request.getParameter("showorder"),0);
    //subcompanyid1 = Util.null2String(request.getParameter("subcompanyid"));
    
    departmentmark=Util.null2String((String)session.getAttribute("departmentmark"));
    departmentname=Util.null2String((String)session.getAttribute("departmentname"));
	showorder= Util.getIntValue((String)session.getAttribute("showorder"));
	supdepid=Util.getIntValue((String)session.getAttribute("supdepid"));
	subcompanyid1=Util.null2String((String)session.getAttribute("subcompanyid"));

	session.removeAttribute("departmentmark");
	session.removeAttribute("departmentname");
	session.removeAttribute("showorder");
	session.removeAttribute("supdepid");
	session.removeAttribute("subcompanyid");
    coadjutant=Util.getIntValue(request.getParameter("coadjutant"),0);
    zzjgbmfzr = Util.null2String(request.getParameter("zzjgbmfzr"));//组织机构部门负责人
    zzjgbmfgld = Util.null2String(request.getParameter("zzjgbmfgld"));//组织机构部门分管领导
    jzglbmfzr = Util.null2String(request.getParameter("jzglbmfzr"));//矩阵管理部门负责人
    jzglbmfgld = Util.null2String(request.getParameter("jzglbmfgld"));//矩阵管理部分分管领导
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int deplevel=0;
if(detachable==1){
    deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",Integer.parseInt(subcompanyid1));
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user))
        deplevel=2;
}
if(subcompanyid1.equals("0"))
subcompanyid1="";
String imagefilename = "/images/hdMaintenance.gif";
String titlename = departmentname+","+departmentmark;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(deplevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(deplevel>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

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

<FORM id=weaver name=frmMain action="DepartmentOperation.jsp" method=post >

<%
if(msgid!=-1){
%>
  <DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

  <TABLE class=ViewForm width="100%">
    <TBODY>
    <COLGROUP>
    <COL width="48%">
    <COL width=24>
    <COL width="48%">
	<%
		String message = Util.null2String(request.getParameter("message"));
		if("1".equals(message)){
	%>
	<TR>
		<TD colspan="3">
			<li>
			<font color="red">
				<%=SystemEnv.getHtmlLabelName(17428,user.getLanguage())%>
			</font>
			</li>
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
          <COLGROUP>
          <COL width="40%">
          <COL width="60%">
          <TBODY>
          <TR class=Spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=InputStyle  name=departmentmark maxLength=60 onblur="checkLength('departmentmark',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" value="<%=departmentmark%>" onchange='checkinput("departmentmark","departmentmarkimage")'>
                 <SPAN id=departmentmarkimage></SPAN>
              </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
            <TD class=FIELD><nobr>
              <INPUT class=InputStyle  name=departmentname maxLength=60   onblur="checkLength('departmentname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" value="<%=departmentname%>" onchange='checkinput("departmentname","departmentnameimage")'>
              <SPAN id=departmentnameimage></SPAN>
              </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15772,user.getLanguage())%></TD>
            <TD class=Field>
				<BUTTON class=Browser type="button" id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
              <SPAN id=departmentspan><%=DepartmentComInfo.getDepartmentname(""+supdepid)%>
              </SPAN>
              <INPUT id=departmentid type=hidden name=supdepid value="<%=supdepid%>">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=coadjutant type=hidden name=coadjutant value="<%=coadjutant%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmDepartmentAdd:Add"
			  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _displayText="<%=ResourceComInfo.getLastname(""+coadjutant)%>">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=showorder size=4 maxlength=4 value="<%=showorder%>" size=4 maxlength=4  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("showorder")' onchange='checkinput("showorder","showorderimage")'>
              <SPAN id=showorderimage></SPAN>
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=departmentcode size=20 maxlength=100 value="<%=departmentcode%>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
         
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%></TD>
            <TD class=Field>
            	
            	<input class="wuiBrowser" id="zzjgbmfzr" name="zzjgbmfzr" value="<%=zzjgbmfzr%>" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;"
				_displayText="<%=ResourceUtil.getHrmShowNameHref(zzjgbmfzr)%>">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%></TD>
            <TD class=Field>
				
				<input class="wuiBrowser" id="zzjgbmfgld" name="zzjgbmfgld" value="<%=zzjgbmfgld%>" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;"
				_displayText="<%=ResourceUtil.getHrmShowNameHref(zzjgbmfgld)%>">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%></TD>
            <TD class=Field>
				
				<input class="wuiBrowser" id="jzglbmfzr" name="jzglbmfzr" value="<%=jzglbmfzr%>" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;"
				_displayText="<%=ResourceUtil.getHrmShowNameHref(jzglbmfzr)%>">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%></TD>
            <TD class=Field>
				
				<input class="wuiBrowser" id="jzglbmfgld" name="jzglbmfgld" value="<%=jzglbmfgld%>" type="hidden"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
				_displayTemplate="<a href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name}</a>&nbsp;"
				_displayText="<%=ResourceUtil.getHrmShowNameHref(jzglbmfgld)%>">
				
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
         
          </TBODY>
        </TABLE>
      </TD>
      <TD>&nbsp;</TD>
      <TD>
        <table class=ViewForm width="100%">
          <colgroup>
          <col width="40%">
          <col width="60%">
          <tr class=Spacing  style="height:2px">
            <td class=line1 colspan=2></td>
          </tr>

         
         <tr>
            <td><a href="HrmCompanyEdit.jsp?id=1"><%=CompanyComInfo.getCompanyname("1")%></a></td>
            <td class=FIELD>
             <BUTTON class=Browser type="button" id=SelectSubcompany onclick="onShowSubcompany()"></BUTTON>
              <SPAN id=subcompanyspan>
                  <%if("".equals(subcompanyid1)){%>
			  <IMG src="/images/BacoError.gif" align=absMiddle>
			  <%}else{%>
              <%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid1)%>
              <%}%>
              </SPAN>
              <INPUT id=subcompanyid1 type=hidden name=subcompanyid1 value="<%=subcompanyid1%>">
			  <INPUT id=subcompanyid1old type=hidden name=subcompanyid1old value="<%=subcompanyid1%>">
            </td>
          </tr>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        </table>
      </TD>
    </TR>

  </TABLE>
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=departid%>">
   <input type=hidden name=allsupdepid value="<%= allsupdepid%>">
 </FORM>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="10" colspan="3"></td>
</tr>
</table>

<script language=javascript>
 function onSave(){
   if(document.frmMain.supdepid.value==<%=departid%>){
     alert("<%=SystemEnv.getHtmlLabelName(15773,user.getLanguage())%>");
   }else{
 	if(check_form(document.frmMain,'departmentmark,departmentname,showorder,subcompanyid1')){
 		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 }
 function onDelete(){
     invoke(<%=departid%>);

}
function check(o){
     if(o)
     alert('无法删除：该部门中存在人员！') ;
     else{
       if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
           }
     }
     return o;
 }
function invoke(id){

     Validator.departmentIsUsed(id,check) ;
 }
function encode(str){
    return escape(str);
}

jQuery(document).ready(function(){
	jQuery(".wuiBrowser").modalDialog();
});

function changeValue(){
	jQuery("#subcompanyid1old").val(jQuery("#subcompanyid1").val());
}

function onShowDepartment(){
    url=encode("/hrm/company/DepartmentBrowser2.jsp?deptlevel=10&notCompany=1&excludeid=<%=departid%>&rightStr=HrmDepartmentEdit:Edit&isedit=1&subcompanyid="+jQuery("input[name=subcompanyid1old]").val()+"&selectedids="+jQuery("input[name=supdepid]").val());
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	issame = false;
	if (data!=null){
		if (data.id!= ""){
			if (data.id == jQuery("#departmentid").val()){
				issame = true
			}
			jQuery("#departmentspan").html(data.name);
			jQuery("#departmentid").val(data.id);
		}else{
			jQuery("#departmentspan").html("");
			jQuery("#departmentid").val("");
		}
	}
}

function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmSubCompanyEdit:Edit&isedit=1&selectedids="+jQuery("input[name=subcompanyid1]").val());
	issame = false;
	if (data!=null){
		if (data.id!= ""){
			if (data.id == jQuery("input[name=subcompanyid1]").val()){
				issame = true;
			}
			jQuery("#subcompanyspan").html(data.name);
			jQuery("input[name=subcompanyid1]").val(data.id);
		}else{
			jQuery("#subcompanyspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name=subcompanyid1]").val("");
		}
	}
	if (jQuery("input[name=subcompanyid1old]").val() != jQuery("input[name=subcompanyid1]").val()){
		jQuery("#departmentspan").html("");
		jQuery("input[name=departmentid]").val("");
	}

	jQuery("input[name=subcompanyid1old]").val(jQuery("input[name=subcompanyid1]").val());
}
 </script>
<!--
 <script language=vbs>
sub onShowDepartment()
    url=encode("/hrm/company/DepartmentBrowser2.jsp?deptlevel=10&notCompany=1&excludeid=<%=departid%>&rightStr=HrmDepartmentEdit:Edit&isedit=1&subcompanyid="&frmMain.subcompanyid1old.value&"&selectedids="&frmMain.departmentid.value)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmSubCompanyEdit:Edit&isedit=1&selectedids="&frmMain.subcompanyid1.value)
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
</script>-->
</BODY></HTML>

