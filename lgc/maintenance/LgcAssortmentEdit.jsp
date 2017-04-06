<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSet.next();

String assortmentmark = RecordSet.getString("assortmentmark");
String assortmentname = RecordSet.getString("assortmentname");
String seclevel = RecordSet.getString("seclevel");
String resourceid = RecordSet.getString("resourceid");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String assortmentimageid = Util.getFileidOut(RecordSet.getString("assortmentimageid")) ;				 
String subassortmentcount= RecordSet.getString("subassortmentcount");
String assetcount= RecordSet.getString("assetcount");
String tff01name = RecordSet.getString("tff01name");
String tff02name = RecordSet.getString("tff02name");
String tff03name = RecordSet.getString("tff03name");
String tff04name = RecordSet.getString("tff04name");
String tff05name = RecordSet.getString("tff05name");
String nff01name = RecordSet.getString("nff01name");
String nff02name = RecordSet.getString("nff02name");
String nff03name = RecordSet.getString("nff03name");
String nff04name = RecordSet.getString("nff04name");
String nff05name = RecordSet.getString("nff05name");
String dff01name = RecordSet.getString("dff01name");
String dff02name = RecordSet.getString("dff02name");
String dff03name = RecordSet.getString("dff03name");
String dff04name = RecordSet.getString("dff04name");
String dff05name = RecordSet.getString("dff05name");
String bff01name = RecordSet.getString("bff01name");
String bff02name = RecordSet.getString("bff02name");
String bff03name = RecordSet.getString("bff03name");
String bff04name = RecordSet.getString("bff04name");
String bff05name = RecordSet.getString("bff05name");

boolean canedit = HrmUserVarify.checkUserRight("CrmProduct:Add", user) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM name=frmMain action=LgcAssortmentOperation.jsp method=post enctype="multipart/form-data">

<div>
<% if(canedit) {%>
<BUTTON class=btn type="button" id=btnSave accessKey=S name=btnSave onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<BUTTON class=btn  id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<% } 
if(HrmUserVarify.checkUserRight("CrmProduct:Add", user)){
%>
<BUTTON class=btnDelete type="button" id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<% } %>
<!--
<% 
 if(HrmUserVarify.checkUserRight("LgcAssortment:Log", user)){
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid=<%=assortmentid%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
-->
</div>  
<input type="hidden" name="assortmentid" value="<%=assortmentid%>">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
    <TD vAlign=top><!-- General -->
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=130> <TBODY> 

           <TR class=Spacing style='height:1px'> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
<!--
          <TR> 
            <TD>标识</TD>
            <td class=FIELD> 
			 <input accesskey=Z name=assortmentmark size="15" onChange='checkinput("assortmentmark","assortmentmarkimage")' value="<%=Util.toScreenToEdit(assortmentmark,user.getLanguage())%>">
			 <span id=assortmentmarkimage></span> </td>
          </TR>
-->
          <TR> 
		    <td>名称</td>
            <td class=FIELD>
			<input accesskey=Z name=assortmentname size="30" onChange='checkinput("assortmentname","assortmentnameimage")' value="<%=Util.toScreenToEdit(assortmentname,user.getLanguage())%>">
			<span id=assortmentnameimage></span> </td>
          </TR>
<!--
          <tr> 
            <td>安全级别</td>
            <td class=Field> 
             <input accesskey=Z name=seclevel size="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="<%=Util.toScreenToEdit(seclevel,user.getLanguage())%>">
			<span id=seclevelimage></span>
            </td>
          </tr>
          <tr> 
            <td>人力资源</td>
            <td class=Field>
			<BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> <span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=resourceid></TD>
            </td>
          </tr>
-->
          <!--<TR><TD>Group</TD><TD class=Field></TD></TR> -->
          </TBODY> 
        </TABLE>
      </TD>
    <TD></TD>
      <TD vAlign=top>
        <table class=ViewForm>
          <colgroup> <col width=130> <tbody> 
           <TR class=Spacing style='height:1px'> 
            <td class=Line1 colspan=2></td>
          </tr>
          <tr> 
            <TD class=Field>
			  <% if(assortmentimageid.equals("") || assortmentimageid.equals("0")) {%> 
              <input type="file" name="assortmentimage">
			  <%} else {%>
              <img border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assortmentimageid%>"> 
              <BUTTON type="button" class=btnDelete id=Delete accessKey=P onclick="onDelPic()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></BUTTON> 
              <% } %>
              <input type="hidden" name="oldassortmentimage" value="<%=assortmentimageid%>">
            </TD>
          </tr>
          </tbody> 
        </table>
      </TD>
    </TR></TBODY></TABLE>
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR class=Title> 
      <TH>备注</TH>
    </TR>
     <TR class=Spacing style='height:1px'> 
      <TD class=Line1></TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TEXTAREA class=InputStyle style="WIDTH: 100%" name="Remark"  rows=8 ><%=Util.toScreenToEdit(assortmentremark,user.getLanguage())%></TEXTAREA>
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
<!--
<TABLE class=ViewForm>
  <COLGROUP>
  <COL span=2 width="50%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2>空闲字段</TH></TR>
   <TR class=Spacing style='height:1px'>
    <TD class=Sep3 colSpan=2></TD></TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD>文本 1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=tff01 value="<%=Util.toScreenToEdit(tff01name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>文本 2</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=tff02 value="<%=Util.toScreenToEdit(tff02name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>文本 3</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=tff03 value="<%=Util.toScreenToEdit(tff03name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>文本 4</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=tff04 value="<%=Util.toScreenToEdit(tff04name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>文本 5</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=tff05 value="<%=Util.toScreenToEdit(tff05name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>数字 1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=nff01 value="<%=Util.toScreenToEdit(nff01name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>数字 2</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=nff02 value="<%=Util.toScreenToEdit(nff02name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>数字 3</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=nff03 value="<%=Util.toScreenToEdit(nff03name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>数字 4</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=nff04 value="<%=Util.toScreenToEdit(nff04name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>数字 5</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=nff05 value="<%=Util.toScreenToEdit(nff05name,user.getLanguage())%>"></TD></TR></TBODY></TABLE></TD>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD>日期 1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=dff01 value="<%=Util.toScreenToEdit(dff01name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>日期 2</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=dff02 value="<%=Util.toScreenToEdit(dff02name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>日期 3</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=dff03 value="<%=Util.toScreenToEdit(dff03name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>日期 4</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=dff04 value="<%=Util.toScreenToEdit(dff04name,user.getLanguage())%>"></TD></TR>
        <TR>
          <TD>日期 5</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=dff05 value="<%=Util.toScreenToEdit(dff05name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>判断 1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=bff01 value="<%=Util.toScreenToEdit(bff01name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>判断 2</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=bf02 value="<%=Util.toScreenToEdit(bff02name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>判断 3</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=bff03 value="<%=Util.toScreenToEdit(bff03name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>判断 4</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=bff04 value="<%=Util.toScreenToEdit(bff04name,user.getLanguage())%>"></TD></TR>
        <TR>
            <TD>判断 5</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=60 size=25 
            name=bff05 value="<%=Util.toScreenToEdit(bff05name,user.getLanguage())%>"></TD></TR></TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
-->	
	</FORM>

<script language=vbs>

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmMain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmMain.resourceid.value=""
	end if
	end if
end sub

</script>
<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'assortmentname')){
 		document.frmMain.operation.value="editassortment";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deleteassortment";
			document.frmMain.submit();
		}
}

function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.frmMain.operation.value="delpic";
		document.frmMain.submit();
	}
}
 </script>
</BODY></HTML>
