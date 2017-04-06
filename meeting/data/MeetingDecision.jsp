<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
String submit = Util.null2String(request.getParameter("submit"));
String edit = Util.null2String(request.getParameter("edit"));


char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));

RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();

String meetingtype=RecordSet.getString("meetingtype");
String meetingname=RecordSet.getString("name");
String caller=RecordSet.getString("caller");
String contacter=RecordSet.getString("contacter");

String address=RecordSet.getString("address");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");

String endtime=RecordSet.getString("endtime");
String desc=RecordSet.getString("desc_n");
String creater=RecordSet.getString("creater");
String createdate=RecordSet.getString("createdate");

String createtime=RecordSet.getString("createtime");
String approver=RecordSet.getString("approver");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");

String isapproved=RecordSet.getString("isapproved");
String isdecision=RecordSet.getString("isdecision");
String decision=RecordSet.getString("decision");
String decisiondocid=RecordSet.getString("decisiondocid");

String projectid=RecordSet.getString("projectid");//获得项目id
String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String othersremark=RecordSet.getString("othersremark");

boolean ismanager=false;
boolean ismember=false;

if(userid.equals(caller)){
	ismanager=true;
}

String Sql="";
if ("oracle".equals(RecordSet.getDBType()) || "db2".equals(RecordSet.getDBType()))
{
    Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager="+userid+" or ','||othermember||',' like '%,"+userid+",%' )";
}
else
{
    Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager="+userid+" or ','+othermember+',' like '%,"+userid+",%' )";
}
RecordSet.executeSql(Sql);
if(RecordSet.next()) {
	ismember=true;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int decisionrows=0;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(ismanager){
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(2),_self} " ;
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
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=weaver action="/meeting/data/MeetingDecisionOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="edit">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" name="decisionrows" value="0">
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2170,user.getLanguage())%></TD>
          <TD class=Field>
			<TEXTAREA class=inputStyle NAME=decision ROWS=15 STYLE="width:100%"><%=Util.toScreenToEdit(decision,user.getLanguage())%></TEXTAREA>		  
		  </TD>
        </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD class=Field>
			<BUTTON class=Browser type="button" onclick='onShowDoc("DecisionDocidname","decisiondocid")'></BUTTON>      
			<SPAN ID=DecisionDocidname><a href="/docs/docs/DocDsp.jsp?id=<%=decisiondocid%>"><%=Util.toScreen(DocComInfo.getDocname(decisiondocid),user.getLanguage())%></a></SPAN>
			<INPUT class=inputStyle type=hidden name="decisiondocid" value=<%=decisiondocid%>>		  
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2171,user.getLanguage())%></TH>
            <Td align=right>
				<A href="#" onclick=javascript:addRow();><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="#" onclick=javascript:if(isdel()){deleteRow1();}><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
        <TR class=spacing>
          <TD class=Sep1 colspan=2></TD></TR>
        <TR>
          <TD colspan=2> 
		  
	  <TABLE class=ListStyle cellspacing=1 cellpadding=1  cols=7 id="oTable">

        <TBODY>
		<tr class=Header>
			<th width=4%>&nbsp</th>
			<th width=6%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></th>
			<th width=40%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
			<th width=10%><%=SystemEnv.getHtmlLabelName(2172,user.getLanguage())%></th>
			<th width=10%><%=SystemEnv.getHtmlLabelName(2173,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></th>
		</tr>
 
<%
RecordSet.executeProc("Meeting_Decision_SelectAll",meetingid);
while(RecordSet.next()){
%>
		<tr>
			<td class=Field><input class=inputstyle type='checkbox' name='check_node' value='0'></td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='coding_<%=decisionrows%>' value="<%=RecordSet.getString("coding")%>">
			</td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='subject_<%=decisionrows%>' value="<%=RecordSet.getString("subject")%>">
			</td>
			<td class=Field>
				<button class=Browser type="button" onClick=onShowMHrm('hrmid01_<%=decisionrows%>span','hrmid01_<%=decisionrows%>')></button> <span class=inputStyle id=hrmid01_<%=decisionrows%>span>
                         <%
			ArrayList hrms = Util.TokenizerString(RecordSet.getString("hrmid01"),",");
			for(int i=0;i<hrms.size();i++){			
			%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=hrms.get(i)%>'><%=ResourceComInfo.getResourcename(String.valueOf(hrms.get(i)))%></a>
			
			<%}%>

				</span>
				<input class=inputstyle type='hidden' name='hrmid01_<%=decisionrows%>' id='hrmid01_<%=decisionrows%>' value="<%=RecordSet.getString("hrmid01")%>">
			</td>
			<td class=Field>
				<button class=Browser type="button" onClick=onShowHrm('hrmid02_<%=decisionrows%>span','hrmid02_<%=decisionrows%>','0')></button> <span class=inputStyle id=hrmid02_<%=decisionrows%>span><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid02")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid02"))%></a></span><input class=inputstyle type='hidden' name='hrmid02_<%=decisionrows%>' id='hrmid02_<%=decisionrows%>' value="<%=RecordSet.getString("hrmid02")%>">
			</td>
			<td class=Field>
				<BUTTON class=Calendar  type="button" onclick="getDate(BeginDate_<%=decisionrows%>span,begindate_<%=decisionrows%>)"></BUTTON> <SPAN id=BeginDate_<%=decisionrows%>span ><%=RecordSet.getString("begindate")%></SPAN> <input class=inputstyle type="hidden" name="begindate_<%=decisionrows%>" value="<%=RecordSet.getString("begindate")%>">-<button class=Clock  type="button" onclick="onShowTime(BeginTime_<%=decisionrows%>span,begintime_<%=decisionrows%>)"></button><span id="BeginTime_<%=decisionrows%>span"><%=RecordSet.getString("begintime")%></span><input class=inputstyle type=hidden name="begintime_<%=decisionrows%>" value="<%=RecordSet.getString("begintime")%>">
			</td>
			<td class=Field>
				<BUTTON class=Calendar  type="button" onclick="getDate(EndDate_<%=decisionrows%>span,enddate_<%=decisionrows%>)"></BUTTON> <SPAN id=EndDate_<%=decisionrows%>span ><%=RecordSet.getString("enddate")%></SPAN> <input class=inputstyle type="hidden" name="enddate_<%=decisionrows%>" value="<%=RecordSet.getString("enddate")%>">-<button class=Clock  type="button" onclick="onShowTime(EndTime_<%=decisionrows%>span,endtime_<%=decisionrows%>)"></button><span id="EndTime_<%=decisionrows%>span"><%=RecordSet.getString("endtime")%></span><input class=inputstyle type=hidden name="endtime_<%=decisionrows%>" value="<%=RecordSet.getString("endtime")%>">
			</td>
		</tr>
<%
decisionrows = decisionrows +1;
}
%>
        </TBODY>
	  </TABLE>		  
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr  type="button">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>  
function submitData() {
 window.parent.close();
}
rowindex = "<%=decisionrows%>";
var rowColor="" ;
function addRow()
{
	ncol = jQuery(oTable).find("TR:first").find("TH").length;
	rowColor = getRowBg();
	oRow = oTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value="+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='coding_"+rowindex+"' value='"+(rowindex*1+1)+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='subject_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Browser type='button'  onClick=onShowMHrm('hrmid01_"+rowindex+"span','hrmid01_"+rowindex+"')></button> <span class=inputStyle id=hrmid01_"+rowindex+"span></span><input class=inputstyle type='hidden' name='hrmid01_"+rowindex+"' id='hrmid01_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Browser  type='button' onClick=onShowHrm('hrmid02_"+rowindex+"span','hrmid02_"+rowindex+"','0')></button> <span class=inputStyle id=hrmid02_"+rowindex+"span></span><input class=inputstyle type='hidden' name='hrmid02_"+rowindex+"' id='hrmid02_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar  type='button' onclick=getDate(BeginDate_"+rowindex+"span,begindate_"+rowindex+")></BUTTON> <SPAN id=BeginDate_"+rowindex+"span ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> <input class=inputstyle type='hidden' name='begindate_"+rowindex+"'>-<button class=Clock  type='button' onclick=onShowTime(BeginTime_"+rowindex+"span,begintime_"+rowindex+")></button><span id='BeginTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begintime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar  type='button' onclick=getDate(EndDate_"+rowindex+"span,enddate_"+rowindex+")></BUTTON> <SPAN id=EndDate_"+rowindex+"span ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> <input class=inputstyle type='hidden' name='enddate_"+rowindex+"'>-<button class=Clock  type='button' onclick=onShowTime(EndTime_"+rowindex+"span,endtime_"+rowindex+")></button><span id='EndTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='endtime_"+rowindex+"'>";
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
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}

function doSave(savemethod){
    if (savemethod==1) savemethod = "submit" ;
    if (savemethod==2) savemethod = "edit" ;
    var parastr = "<%=needcheck%>" ;
    len = document.forms[0].elements.length;
	var i=0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			parastr+=",begindate_"+document.forms[0].elements[i].value;
			parastr+=",enddate_"+document.forms[0].elements[i].value;
	}
	if(parastr!="") parastr=parastr.substring(1);
	if(check_form(document.weaver,parastr)){
	    enableAllmenu(); 
		document.weaver.method.value=savemethod;
		document.weaver.decisionrows.value=rowindex;
		document.weaver.submit();
	}
}



function onShowHrm(spanname,inputename,needinput){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (data!=null){
		if (data.id != ""){
			jQuery("#"+spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			if (needinput == "1"){
				jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				jQuery("#"+spanname).html("");
			}
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowMHrm(spanname,inputename){
		tmpids = jQuery("input[name="+inputename+"]").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
		if (data!=null){
				if (data.id != ""){
					ids = data.id.split(",");
					names =data.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp;";
						}
					}
					jQuery("input[name="+inputename+"]").val(data.id.substr(1));
					jQuery("#"+spanname).html(sHtml);
					
				}else{
					jQuery("#"+spanname).html("");
					jQuery("input[name="+inputename+"]").val("");
				}
		}
}

function onShowMCrm(spanname,inputename){
		tmpids = jQuery("input[name="+inputename+"]").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpids);
				if (data.id != ""){
					ids = data.id.split(",");
					names =data.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
						sHtml = sHtml+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+ids[i]+">"+names[i]+"</a>&nbsp;";
						}
					}
					jQuery("input[name="+inputename+"]").val(data.id.substr(1));
					jQuery("#"+spanname).html(sHtml);
					
				}else{
					jQuery("#"+spanname).html("");
					jQuery("input[name="+inputename+"]").val("");
				}
}

function onShowDoc(spanname,inputename){
	data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	if (data!=null){
		jQuery("#"+spanname).html("<a href='/docs/docs/DocDsp.jsp?id="+data.id+"'>"+data.name+"</a>");
		jQuery("input[name="+inputename+"]").val(data.id+"");
	}	
}
</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
