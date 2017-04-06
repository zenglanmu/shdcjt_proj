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
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid=user.getUID();
String username = user.getUsername();
int userLength = username.length()+Util.null2String(String.valueOf(userid)).length()+3;
String hrmid = Util.null2String(request.getParameter("hrmid"));
String crmid = Util.null2String(request.getParameter("crmid"));

	if(!HrmUserVarify.checkUserRight("CreateSMS:View", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
    }

//String sql = "select mobile from HrmResource where id= "+userid;
//rs.executeSql(sql);
//rs.next();
//String sendnumber=Util.toScreen(rs.getString("mobile"),user.getLanguage());
//发送者的手机号码，即登陆该系统的用户的手机号码，自动显示在发送人的是手机号一栏，可以更改
if("".equals(hrmid)){
    hrmid = "-2";
}
if("".equals(crmid)){
    crmid = "-2";
}
String sql_1 = "select id,lastname,mobile  from HrmResource where id= "+hrmid;
rs_2.executeSql(sql_1);
String id_hrm="";
String recievenumber_hrm="";
String name_hrm="";
if(rs_2.next()){
    id_hrm=Util.toScreen(rs_2.getString("id"),user.getLanguage());
    recievenumber_hrm=Util.toScreen(rs_2.getString("mobile"),user.getLanguage());
    name_hrm=Util.toScreen(rs_2.getString("lastname"),user.getLanguage());
}
//当从人力资源的卡片上进入此页面时，自动生成员工的姓名和手机号码
String id_crm = "" ;
String recievenumber_crm="" ;
String fullname_crm="" ;

String sql_2 = "select id ,fullname,mobilephone from CRM_CustomerContacter where id=" +crmid;
rs_1.executeSql(sql_2);
if(rs_1.next()) {
    id_crm=Util.toScreen(rs_1.getString("id"),user.getLanguage());
    recievenumber_crm = Util.toScreen(rs_1.getString("mobilephone"),user.getLanguage());
    fullname_crm=Util.toScreen(rs_1.getString("fullname"),user.getLanguage());
}
//当从客户卡片上的进入此界面时，自动生成客户的手机和姓名

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=weaver action="SmsMessageOperation.jsp" method=post >

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
  	<COL width="30%">
    <COL width="10%">
    <COL width="30%">

        <TBODY>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18536,user.getLanguage())%></TD>
          <%if(isgoveproj==0){%>
		  <TD><%=SystemEnv.getHtmlLabelName(18537,user.getLanguage())%>:</TD>
          <%}else{%>
		  <TD><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%>:</TD>
		  <%}%>
		  <td class=Field>
            <textarea class=InputStyle  style="width:100%;display:none" name=recievenumber1 rows="4"><%=recievenumber_hrm%></textarea>

            <button class=Browser type="button" onclick="onShowMHrm('hrmids02span','hrmids02')"></button>
            <a href="/hrm/resource/HrmResource.jsp?id=<%=id_hrm%>"><%=Util.toScreen(rs_2.getString("lastname"),user.getLanguage())%> </a>
			<input type=hidden name="hrmids02" value="<%=hrmid%>">

			<span id="hrmids02span"></span>
          </td>
		  <%if(isgoveproj==0){%>
          <TD><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%>:</TD>
		  <TD class=Field>
            <textarea class=InputStyle  style="width:100%;display:none" name=recievenumber2  rows= "4"><%=recievenumber_crm%></textarea>
            <button class=Browser type="button" onclick="onShowMCrm('crmids02span','crmids02')"></button>
            <% if(!id_crm.equals("") ) { %><a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=id_crm%>">            <%=Util.toScreen(rs_1.getString("fullname"),user.getLanguage())%> </a><%}%>
			<input type=hidden name="crmids02" value="crmid">

			<span id="crmids02span"></span>
		  </TD>
		  <%}else{%>
			<input type="hidden" name="recievenumber2" value="">
		  <%}%>
         </TR>
         <TR>
          <TD></TD>
          <TD><%=SystemEnv.getHtmlLabelName(18538,user.getLanguage())%>:</TD>
          <td class=Field colspan=3>
              <textarea class=InputStyle  style="width:100%" name=customernumber  rows= "2"></textarea>
          </td>

        </TR>
		<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>

        <tr>
         <TD colspan=2><%=SystemEnv.getHtmlLabelName(18529,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18547,user.getLanguage())%>)</TD>
         <td class=Field colspan=3>
              <FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%> <B><SPAN id="wordsCount" name="wordsCount">0</SPAN></B> <%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20076,user.getLanguage())%> <B><SPAN id="messagesCount" name="messagesCount">0</SPAN></B> <%=SystemEnv.getHtmlLabelName(20097,user.getLanguage())%>.</FONT>
			  <TEXTAREA class=InputStyle style="width:95%;word-break:break-all" name=message rows="5" onchange='checkinput("message","messageimage")' onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this)></TEXTAREA>
              <SPAN id=messageimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
         </td>
        </TR>
        <tr>
         <TD colspan=2></TD>
         <td colspan=3><br>
<%=SystemEnv.getHtmlLabelName(18539,user.getLanguage())%>：<br>
&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%> ID+R+<%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%> （<%=SystemEnv.getHtmlLabelName(18548,user.getLanguage())%>）<BR>
<%=SystemEnv.getHtmlLabelName(18541,user.getLanguage())%>：<BR>
&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18542,user.getLanguage())%>： <%=SystemEnv.getHtmlLabelName(18544,user.getLanguage())%>(86)<br>
&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18543,user.getLanguage())%>： 86R <%=SystemEnv.getHtmlLabelName(18545,user.getLanguage())%>
         </td>
        </TR>
		<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>

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

sub onShowMHrm1(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
                    recievenumber1 = id1(1)

                    retresourceids = ""
                    retresourcename = ""
                    retrecievenumber1 = ""

					sHtml = ""
                    'msgbox resourceids&"|"&resourcename&"|"&recievenumber1

					resourceids = Mid(resourceids,2,len(resourceids))
					resourcename = Mid(resourcename,2,len(resourcename))
                    recievenumber1 = Mid(recievenumber1,2,len(recievenumber1))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = getName(Mid(resourcename,1,InStr(resourcename,",")-1))
                        curnumber1 = getNumber(Mid(recievenumber1,1,InStr(recievenumber1,",")-1))

                        if curnumber1<>"" then
                            retresourceids =retresourceids& ","&curid
                            retresourcename = retresourcename&","&curname
                            retrecievenumber1 = retrecievenumber1&","&curnumber1
                            sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&trim(curname)&"</a>&nbsp"
                        end if

						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        recievenumber1 = Mid(recievenumber1,InStr(recievenumber1,",")+1,Len(recievenumber1))

                        'msgbox curid&"|"&curname&"|"&curnumber1
					wend
                    if getNumber(recievenumber1)<>"" then
    					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&trim(getName(resourcename))&"</a>&nbsp"
                        retresourceids =retresourceids& ","&resourceids
                        retresourcename = retresourcename&","&trim(getName(resourcename))
                        retrecievenumber1 = retrecievenumber1&","&getNumber(recievenumber1)
                    end if
                    //msgbox sHtml
					document.all(spanname).innerHtml = sHtml
					weaver.recievenumber1.value=trimComma(retrecievenumber1)
                    document.all(inputename).value= retresourceids

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    weaver.recievenumber1.value=""
				end if
			end if
end sub

sub onShowMCrm1(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiCustomerBrowser_sms.jsp?resourceids="&tmpids)
			if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
                    recievenumber2 = id1(2)

                    retresourceids = ""
                    retresourcename = ""
                    retrecievenumber2 = ""

					sHtml = ""
                    'msgbox resourceids&"|"&resourcename&"|"&recievenumber2

					resourceids = Mid(resourceids,2,len(resourceids))
					resourcename = Mid(resourcename,2,len(resourcename))
                    recievenumber2 = Mid(recievenumber2,2,len(recievenumber2))

					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                        curnumber2 = Mid(recievenumber2,1,InStr(recievenumber2,",")-1)

                        if curnumber2<>"" then
                            retresourceids =retresourceids& ","&curid
                            retresourcename = retresourcename&","&curname
                            retrecievenumber2 = retrecievenumber2&","&curnumber2
                            sHtml = sHtml&"<a href=/CRM/data/ViewContacter.jsp?ContacterID="&curid&">"&curname&"</a>&nbsp"
                        end if

						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        recievenumber2 = Mid(recievenumber2,InStr(recievenumber2,",")+1,Len(recievenumber2))

                        'msgbox curid&"|"&curname&"|"&curnumber2
					wend
                    if recievenumber2<>"" then
    					sHtml = sHtml&"<a href=/CRM/data/ViewContacter.jsp?ContacterID="&resourceids&">"&resourcename&"</a>&nbsp"
                        retresourceids =retresourceids& ","&resourceids
                        retresourcename = retresourcename&","&resourcename
                        retrecievenumber2 = retrecievenumber2&","&recievenumber2
                    end if
					document.all(spanname).innerHtml = sHtml
					weaver.recievenumber2.value=trimComma(retrecievenumber2)
                    document.all(inputename).value= retresourceids
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    weaver.recievenumber2.value=""
				end if
			end if
end sub
function trimComma1(inStr)
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
function trimComma(inStr){
	//dim(tmpArry,retStr);
	var retStr = "";
	tmpArry = inStr.split(",");
	for(var i=0;i<tmpArry.length;i++){
		if(tmpArry[i]!=""){
			retStr = retStr+","+tmpArry[i];
		}
	}
	if(retStr!=""){
		//trimComma = retStr.substr(1);
		return retStr.substr(1);
	}else{
		//trimComma = "";
		return "";
	}
}

function onShowMHrm(spanname,inputename){
  var tmpids = $G(inputename).value;
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp?resourceids="+tmpids);
  if(id1){
    if(id1.id!= ""){
     resourceids =id1.id;
     resourcename =id1.name;
     recievenumber1 =id1.name;
     
     retresourceids = "";
     retresourcename = "";
     retrecievenumber1 = ""

     sHtml = "";

     resourceids =resourceids.substr(1);
     resourcename =resourcename.substr(1);
     recievenumber1 =recievenumber1.substr(1);
     
     var ids=resourceids.split(",");
     var names=resourcename.split(",");
     for(var i=0;i<ids.length;i++){
        if(ids[i]!=""){
           var number=getNumber(names[i]);
           if(number!=""){
	           retresourceids =retresourceids+","+ids[i];
	           retresourcename = retresourcename+","+getName(names[i]);
	           retrecievenumber1 = retrecievenumber1+","+number;
	           sHtml = sHtml+"<a target='_blank' href=/hrm/resource/HrmResource.jsp?id="+ids[i]+">"+getName(names[i])+"</a>&nbsp;";
          }
        }   
     }
     $G(spanname).innerHTML = sHtml;
     $G("recievenumber1").value=trimComma(retrecievenumber1);
     $G(inputename).value= retresourceids;

    }else{
       $G(spanname).innerHTML ="";
       $G(inputename).value="";
       $G("recievenumber1").value="";
    }
   }
}




function onShowMCrm(spanname,inputename){
		var tmpids =$G(inputename).value;
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiCustomerBrowser_sms.jsp?resourceids="+tmpids);
			if (id1){
				if(id1.id!="") {
					resourceids =wuiUtil.getJsonValueByIndex(id1,0);
					resourcename =wuiUtil.getJsonValueByIndex(id1,1);
                    recievenumber2 =wuiUtil.getJsonValueByIndex(id1,2);
                    
                    retresourceids = "";
                    retresourcename = "";
                    retrecievenumber2 = "";

					sHtml = ""

					resourceids =resourceids.substr(1).split(",");
					resourcename =resourcename.substr(1).split(",");
                    recievenumber2 =recievenumber2.substr(1).split(",");

                    for(var i=0;i<resourceids.length;i++){
                        if(resourceids[i]!=""&&recievenumber2[i]!=""){
                        
                            retresourceids =retresourceids+","+resourceids[i];
                            retresourcename = retresourcename+","+resourcename[i];
                            retrecievenumber2 = retrecievenumber2+","+recievenumber2[i];
                            
                            sHtml = sHtml+"<a target='_blank' href=/CRM/data/ViewContacter.jsp?ContacterID="+resourceids[i]+">"+resourcename[i]+"</a>&nbsp;";
                        }
                    }
                    retrecievenumber2=retrecievenumber2.length>0?retrecievenumber2.substr(1):retrecievenumber2;
                    retresourceids=retresourceids.length>0?retresourceids.substr(1):retresourceids;
                    
					$G(spanname).innerHTML = sHtml;
					$G("recievenumber2").value=retrecievenumber2;
                    $G(inputename).value= retresourceids;
				}else{
					$G(spanname).innerHTML = "";
					$G("recievenumber2").value="";
                    $G(inputename).value="";
				}
		 }
}


function onKeyPressLength(objectname)
{
    objectvalue=document.all(objectname).value;
    if (objectvalue.length>=50)
    {
    window.event.keyCode=0;
    }
}


function checkMobileNumber(number1){
    var i;
    numberAry = number1.split(",");
    for(i=0; i<numberAry.length; i++){
        //alert(number1);
        //alert("i:"+i);
        //alert(numberAry[i]);
        var tempStr = numberAry[i].toString();
        if(tempStr==""){
            alert("号码不能为空");
            return false;
        }
        if(!checkInteger(tempStr)){
            alert("号码必须是数字");
            return false;
        }
        //if(tempStr.length!=11){
          //  alert("号码长度必须是11位");
           // return false;
        //}
    }
    return true;
}

function checkInteger(integer){
    var i;
    for( i=0; i<integer.length; i++){
        //alert(integer.charAt(i).charCodeAt(0));
        var number = parseInt(integer.charAt(i).charCodeAt(0));
        if(!(number>=48&&number<=57)){
            return false;
        }
    }
    return true;
}


function onCheckForm1(objectname0,objectname1,objectname2,objectname3)
{
  if(!($G(objectname0).value=="")){
           if (($G(objectname1).value=="")&&($G(objectname2).value=="")&&($G(objectname3).value=="")){
               alert ("<%=SystemEnv.getHtmlLabelName(18963,user.getLanguage())%>") ;
               return false;
           }else if($G(objectname3).value!=""){

                if(checkMobileNumber($G(objectname3).value)){
                    return true;
                }else{
                    return false;
                }

           }else{
               return true;
           }
  }

  else {
      alert ("<%=SystemEnv.getHtmlLabelName(18962,user.getLanguage())%>");
      return false;
  }
}
</script>
<script language="javascript">
function printStatistic(o)
{
	setTimeout(function()
	{
		var inputLength = o.value.length;
		jQuery("#wordsCount").html(inputLength);
		if((inputLength+<%=userLength%>)> 63 ){
			jQuery("#messagesCount").html((0 == inputLength ? 0 : Math.floor((inputLength+<%=userLength%>-1) / 60) + 1));
		}else{
			jQuery("#messagesCount").html(1);
		}
	}
	,1)
}


function doSubmit(obj)
{
	if (onCheckForm1("message","recievenumber1","recievenumber2","customernumber")){
        //document.all("recievenumber2").value=document.all("recievenumber2").value;
        obj.disabled=true;
		document.weaver.submit();
    }
}

function checklength(){
    if(jQuery("input[name=message]").val()!=""){
        //alert(getLength(document.all("message").value));
        if(jQuery("input[name=message]").val().length>60){
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
