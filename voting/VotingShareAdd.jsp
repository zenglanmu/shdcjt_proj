<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16140,user.getLanguage());
String needfav ="1";
String needhelp ="";

String rightStr = "";
boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
if(canmaint){
  rightStr = "Voting:Maint";
}

String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String votingname ="";
RecordSet.executeProc("Voting_SelectByID",votingid);
if(RecordSet.next()){
    votingname = RecordSet.getString("subject");
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmmain name=frmmain action="VotingShareOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="votingid" value="<%=votingid%>">
<TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="5">
          <col width="">
            <col width="5">
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
<table Class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="50%">
  <COL width="30%">
  <TR><TH colspan=3><div align="left"><%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>:<%=votingname%></div></TH></TR>
  <TR style="height: 1px!important;"><TD  class="line1" colSpan=3></TD></TR>
  <TR>
    <TD class=field>
    <SELECT name=sharetype onchange="onChangeSharetype()">
      <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
      <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
      <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
      <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
      <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
    </SELECT>
	</TD>
    <TD class=field>
        <BUTTON class=Browser type="button" style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" id="showresource" name="showresource"></BUTTON> 
        <BUTTON class=Browser type="button" style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid','<%=rightStr%>')" id="showsubcompany" name="showsubcompany"></BUTTON> 
        <BUTTON class=Browser type="button" style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" id="showdepartment" name="showdepartment"></BUTTON> 
        <BUTTON class=Browser type="button" style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" id="showrole" name="showrole"></BUTTON>
         <INPUT type=hidden name=relatedshareid id="relatedshareid" value="">
         <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span>
        <span id=showrolelevel name=showrolelevel style="visibility:hidden">
        <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
        <SELECT name=rolelevel>
          <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
        </SELECT>
        </span>
    </TD>
    <td class=field>
        <span id=showseclevel name=showseclevel><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
        <INPUT type=text class="inputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")'>
        </span>
        <SPAN id=seclevelimage></SPAN>
	</TD>		
  </TR>
  <TR style="height: 1px!important;"><TD  class="line" colSpan=3></TD></TR>
</table>
                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
            </table>
</form>
<script language=javascript>
function doSave(obj) {
	thisvalue=document.frmmain.sharetype.value;
	checkThrough = false;
	if (thisvalue==1){
	    if(check_form(document.frmmain,'relatedshareid')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==2){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==3){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==4){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else{
		document.frmmain.submit();
		checkThrough = true;
	}
	if(checkThrough) obj.disabled = true;
}
</script>
<script language=javascript>
  function onChangeSharetype(){
	 
	thisvalue=document.frmmain.sharetype.value;
	document.frmmain.relatedshareid.value="";
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
		document.all("showresource").style.display='none';
	}
	if(thisvalue==2){
 		document.all("showsubcompany").style.display='';
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
		document.all("showsubcompany").style.display='none';
		document.frmmain.seclevel.value=10;
	}
	if(thisvalue==3){
 		document.all("showdepartment").style.display='';
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
		document.all("showdepartment").style.display='none';
		document.frmmain.seclevel.value=10;
	}
	if(thisvalue==4){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
		document.frmmain.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=0;
	}
}

	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;

  function onShowDepartment(spanname,inputname){
	  
	  linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	  "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	   if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	      $("input[name="+inputname+"]").val("");
	      }
	  }
  }
  function onShowResource(spanname,inputname){
	  linkurl="javaScript:openhrm(";
	     datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	    if (datas) {
	     if (datas.id!= "") {
	         ids = datas.id.split(",");
	     names =datas.name.split(",");
	     sHtml = "";
	     for( var i=0;i<ids.length;i++){
	     if(ids[i]!=""){
	      sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
	     }
	     }
	     $("#"+spanname).html(sHtml);
	     $("input[name="+inputname+"]").val(datas.id);
	     }
	     else {
	           $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	     $("input[name="+inputname+"]").val("");
	     }
	 }
	 }
  function onShowSubcompany(spanname,inputname)  {
	  linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
	      datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	       "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	     if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	      		$("input[name="+inputname+"]").val("");
	      }
	  }
	  }

  function onShowRole(spanname,inputname)  {
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
		if(datas){
	    if (datas.id!=""){
	    	$("#"+spanname).html(datas.name);
		    $("input[name="+inputname+"]").val(datas.id);
	    }else{
	    	$("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
    		$("input[name="+inputname+"]").val("");
		}
	}
}
</script>

<SCRIPT language=VBS>


</SCRIPT>
</body>
</html>