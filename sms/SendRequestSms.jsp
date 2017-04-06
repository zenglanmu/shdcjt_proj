<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="MailAndMessage" class="weaver.workflow.request.MailAndMessage" scope="page"/>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid=user.getUID();
String username = user.getUsername();
int userLength = username.length()+3;
int wfid = Util.getIntValue(request.getParameter("workflowid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int reqid = Util.getIntValue(request.getParameter("reqid"), 0);
String hrmid = Util.null2String(request.getParameter("hrmid"));

	if(!HrmUserVarify.checkUserRight("CreateSMS:View", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
    }
String id_hrm="";
String recievenumber_hrm="";
String name_hrm="";
String message = "";
//获得当前节点操作人
if(reqid != 0 && wfid != 0 && nodeid != 0){
	String sql_1 = "select distinct id,lastname,mobile  from HrmResource where id in (select userid from workflow_currentoperator where requestid="+reqid + " and nodeid="+nodeid+") and id <> " + userid;
	rs_1.executeSql(sql_1);

	while(rs_1.next()){
		String mobile = Util.null2String(rs_1.getString("mobile"));
		if("".equals(mobile.trim())){
			continue;
		}
		id_hrm = id_hrm + rs_1.getString("id") + ",";
		recievenumber_hrm = recievenumber_hrm + mobile + ",";
		name_hrm = name_hrm + "<a href=\"javaScript:openFullWindowHaveBar(\'/hrm/resource/HrmResource.jsp?id=" + rs_1.getString("id") + "\')\">" + Util.toScreen(rs_1.getString("lastname"),user.getLanguage()) + "</a> ";
	}
	if(!"".equals(id_hrm)){
		id_hrm = id_hrm.substring(0, id_hrm.length()-1);
	}
	if(!"".equals(recievenumber_hrm)){
		recievenumber_hrm = recievenumber_hrm.substring(0, recievenumber_hrm.length()-1);
	}
}
if(wfid != 0 && nodeid != 0){
	message = MailAndMessage.getMessage(reqid, wfid, nodeid, user.getLanguage());
}
//将短信内容中的“&nbsp;”替换为“ ”
if(!"".equals(message)){
	message = Util.replace(message, "&nbsp;", " ", 0);
}
int messageCount = 0;
if(!"".equals(message)){
	messageCount = ((int)(message.length() / 60)) + 1;
}
String usecustomsender = "";
rs.executeSql("select * from workflow_nodecustomrcmenu where wfid="+wfid+" and nodeid="+nodeid);
if(rs.next()){
	usecustomsender = Util.null2String(rs.getString("usecustomsender"));
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=weaver action="SendRequestSmsOperation.jsp" method=post >

  <input type="hidden" name="method" value="send">
  <input type="hidden" name="userid" value="userid">
  <input type="hidden" name="currentdate" value="currentdate">
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

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <TD vAlign=top>
  <TABLE class=ViewForm>
  <COLGROUP>
  	<COL width="20%">
    <COL width="10%">
  	<COL width="70%">
        <TBODY>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18536,user.getLanguage())%></TD>
          <%if(isgoveproj==0){%>
		  <TD><%=SystemEnv.getHtmlLabelName(18537,user.getLanguage())%>:</TD>
          <%}else{%>
		  <TD><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%>:</TD>
		  <%}%>
		  <td class=Field >
            <textarea class=InputStyle  style="width:100%;display:none" name=recievenumber1 rows="4"><%=recievenumber_hrm%></textarea>

            <button type="button" class=Browser onclick="onShowMHrm('hrmids02span','hrmids02')"></button>
			<input type=hidden name="hrmids02" value="<%=id_hrm%>">
			<span id="hrmids02span"><%if(!"".equals(name_hrm.trim())){%><%=name_hrm%><%}else{%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
          </td>
         </TR>
         
		<TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>

        <tr>
         <TD colspan=2><%=SystemEnv.getHtmlLabelName(18529,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18547,user.getLanguage())%>)</TD>
         <td class=Field>
              <FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%> <B><SPAN id="wordsCount" name="wordsCount"><%=message.length()%></SPAN></B> <%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20076,user.getLanguage())%> <B><SPAN id="messagesCount" name="messagesCount"><%=messageCount%></SPAN></B> <%=SystemEnv.getHtmlLabelName(20097,user.getLanguage())%>.</FONT>
			  <TEXTAREA class=InputStyle style="width:95%;word-break:break-all" name=message rows="5" onchange='checkinput("message","messageimage");printStatistic(this)' onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this)><%=message%></TEXTAREA>
              <SPAN id=messageimage><%if("".equals(message)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN>
				<%if(!"1".equals(usecustomsender)){%>
					<input type="hidden" name="sender" >
				<%}%>
         </td>
        </TR>

		<TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>
		<%if("1".equals(usecustomsender)){%>
        <tr>
         <TD colspan=2><%=SystemEnv.getHtmlLabelName(21800,user.getLanguage())%></TD>
         <td class=Field>
			  <input class=InputStyle style="width:95%" name=sender onchange='checkinput("sender","senderimage")' onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this)>
              <SPAN id=senderimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
         </td>
        </TR>
		<TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>
		<%}%>
        </TBODY></TABLE></TD>
    </TR></TBODY>
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

</FORM>


<script language=vbs>



function trimComma(inStr)
	dim tmpArry,retStr
	tmpArry = split(inStr,",")
	for i=0 to ubound(tmpArry)
		if tmpArry(i)<>"" then
			retStr = retStr&","&tmpArry(i)
		end if
	next
	if retStr<>"" then
		trimComma = mid(retstr,2)
	else
		trimComma = ""
	end if

end function

</script>

<script language=javascript>
function myTest(){
    alert("recievenumber1"+$GetEle("recievenumber1").value);
    alert("recievenumber2"+$GetEle("recievenumber2").value);
    alert("customernumber"+$GetEle("customernumber").value);
    alert("message"+$GetEle("message").value);
}

function onShowMHrm(spanname, inputename) {
    tmpids = $GetEle(inputename).value;
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp?resourceids=" + tmpids);
    if (data) {
        if (data.id != "") {
            resourceids = data.id;
            resourcename = data.name;
            recievenumber1 = data.name

            retresourceids = "";
            retresourcename = "";
            retrecievenumber1 = ""

            var sHtml = ""

            resourceids = resourceids.substring(1);
            resourcename = resourcename.substring(1)
            recievenumber1 = recievenumber1.substring(1);
			ids = resourceids.split(",");
			names = resourcename.split(",");
			number1 = recievenumber1.split(",");
			
            for(var i=0;i<ids.length;i++){
				if(number1[i]!=""){
					 retresourceids = retresourceids + "," + ids[i];
		              retresourcename = retresourcename + "," + names[i];
		              retrecievenumber1 = retrecievenumber1 + "," + number1[i];
		              sHtml = sHtml + "<a href=javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id=" + ids[i] + "')>" + jQuery.trim(names[i]) + "</a>&nbsp;";
				}
            }
         
           

            
            $GetEle(spanname).innerHTML = sHtml;
            weaver.recievenumber1.value = jQuery.trim(retrecievenumber1)
            $GetEle(inputename).value = retresourceids;
        } else {
            $GetEle(spanname).innerHTML = "";
            $GetEle(inputename).value = "";
            weaver.recievenumber1.value = "";
        }
    }
    if ($GetEle(inputename).value == "") {
        $GetEle(spanname).innerHTML = "<IMG src=/images/BacoError.gif align=absMiddle>";
    }
}

function onKeyPressLength(objectname)
{
    objectvalue=$GetEle(objectname).value;
    if (objectvalue.length>=50)
    {
    window.event.keyCode=0;
    }
}
<%if("1".equals(usecustomsender)){%>
	function onCheckForm1(objectname0, objectname1, objectname2){

	if(!($GetEle(objectname0).value=="")){
		if ($GetEle(objectname1).value==""){
			alert ("<%=SystemEnv.getHtmlLabelName(21801,user.getLanguage())%>") ;
			return false;
		}else if ($GetEle(objectname2).value==""){
			alert ("<%=SystemEnv.getHtmlLabelName(18963,user.getLanguage())%>") ;
			return false;
		}else{
			return true;
		}
	}else{
		alert ("<%=SystemEnv.getHtmlLabelName(18962,user.getLanguage())%>");
		return false;
	}
}
<%}else{%>
function onCheckForm1(objectname0,objectname1)
{
  //alert($GetEle("objectname0").value+":"+$GetEle("objectname1").value+":"+$GetEle("objectname2").value+":"+$GetEle("objectname3").value);
  if(!($GetEle(objectname0).value=="")){
           if ($GetEle(objectname1).value==""){
               alert ("<%=SystemEnv.getHtmlLabelName(18963,user.getLanguage())%>") ;
               return false;
           }else{
               return true;
           }
  }else {
      alert ("<%=SystemEnv.getHtmlLabelName(18962,user.getLanguage())%>");
      return false;
  }
}
<%}%>
</script>
<script language="javascript">
function printStatistic(o){
	setTimeout(function()
	{
		var length2 = 0;
		if(o.tagName == "TEXTAREA"){
			length2 = $GetEle("sender").value.length;
		}else{
			length2 = $GetEle("message").value.length;
		}
		var inputLength = o.value.length + length2;
		$GetEle("wordsCount").innerHTML = inputLength;
		if((inputLength+<%=userLength%>)> 63 ){
			$GetEle("messagesCount").innerHTML = (0 == inputLength ? 0 : Math.floor((inputLength+<%=userLength%>-1) / 60) + 1);
		}else if(inputLength == 0){
			$GetEle("messagesCount").innerHTML = 0;
		}else{
			$GetEle("messagesCount").innerHTML = 1;
		}
	}
	,1)
}


function doSubmit()
{
	<%if("1".equals(usecustomsender)){%>
		if (onCheckForm1("message","sender", "recievenumber1")){
	<%}else{%>
		if (onCheckForm1("message","recievenumber1")){
	<%}%>
			//$GetEle("recievenumber2").value=$GetEle("recievenumber2").value;
			document.weaver.submit();
		}
}

function checklength(){
    if($GetEle("message").value!=""){
        //alert(getLength($GetEle("message").value));
        if($GetEle("message").value.length>60){
            alert("<%=SystemEnv.getHtmlLabelName(18964,user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

function cutString(str,goLen){
    var len = 0;
    var temStr = str;
    for(var i=0; i<temStr.length; i++){
        if(temStr.charCodeAt(i)>256){
            len++;
            len++;
        }else{
            len++;
        }
        if(i>goLen){
            return temStr.subString(0,i);
        }
    }
    return temStr;
}

function getLength(str){
    var len = 0;
    var temStr = str;
    for(var i=0; i<temStr.length; i++){
        if(temStr.charCodeAt(i)>256){
            len++;
            len++;
        }else{
            len++;
        }
    }
    return len;
}

function getName(str){
    re=new RegExp("<.*>","g")
    str1= str.replace(re,"")
    return str1
}
function getNumber(str){
    if(str.indexOf("<")<0)
    return ""
    re=new RegExp(".*<","g")
    str1=str.replace(re,"")
    re=new RegExp(">","g")
    str2=str1.replace(re,"")
    return str2
}
</script>
</BODY>
</HTML>
