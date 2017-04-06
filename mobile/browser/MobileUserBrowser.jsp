<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String flag = request.getParameter("flag");

RecordSet rs = new RecordSet() ;

User user = null;//HrmUserVarify.checkUser (request , response) ;
if(user == null){

	int logintype = 0;
	rs.execute("select * from mobileconfig where mc_type = 7");
	if(rs.next()) {
		logintype = Util.getIntValue(rs.getString("mc_value"),0);
	}
	
	MobileService ms = new MobileServiceImpl();
	if(ms.checkUserLogin(username, password, logintype)==1) {
		user = new User() ;
		rs.execute("SELECT id,firstname,lastname,systemlanguage,seclevel FROM HrmResourceManager WHERE loginid='"+username+"'");
		if(rs.next()){
			user.setUid(rs.getInt("id"));
			user.setLoginid(username);
			user.setFirstname(rs.getString("firstname"));
			user.setLastname(rs.getString("lastname"));
			user.setLanguage(Util.getIntValue(rs.getString("systemlanguage"),0));
			user.setSeclevel(rs.getString("seclevel"));
			user.setLogintype("1");
			request.getSession(true).setAttribute("weaver_user@bean",user) ;
		}
	} else {
		out.println("Login Error !");
		return;
	}
}
%>
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>

<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray.css'/>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />
<SCRIPT language="javascript" src="/js/init.js"></SCRIPT>
<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/jquery.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/ext-jquery-adapter.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all.js'></script>
</head>
<%
	if (!HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<script type="text/javascript">
	$(document).ready(function() {
		showUserFrom();
	});
	
	function showUserFrom(){
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"userwin",
		           x: 0,
		           y: 0,
		           width:500,
		           height:400,
		           modal:true,
		           closable:false,
		           resizable:false,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onUserOk();win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onUserCancel();win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(18454,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onUserOk(){
		
	 	var sharetype = document.all("sharetype").value;
	 	var seclevel = document.all("seclevel").value;
	 	var rolelevel = document.all("rolelevel").value;
	 	var relatedshareids = document.all("relatedshareid").value;

	 	if(sharetype=="5") relatedshareids = "0";
	 	
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddUser"+
		"&flag=<%=flag%>"+
		"&sharetype="+sharetype+
		"&seclevel="+seclevel+
		"&rolelevel="+rolelevel+
		"&relatedshareids="+relatedshareids+
		"&click=ok"+
		"&callback=doClear()";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});
	}

	function onUserCancel() {
		var geturl="MobileCrossFrameProxy.jsp?method=returnAddUser"+
		"&flag=<%=flag%>"+
		"&click=cancel"+
		"&callback=doClear()";
		
		$.getScript(geturl,function(data){
			eval(data);
			window.close();
		});
	}
	
	function doClear() {
	 	document.all("sharetype").value = "1";
	 	document.all("seclevel").value = "";
	 	document.all("rolelevel").value = "";
	 	document.all("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	 	onChangeSharetype();
	}

	function onChangeSharetype(){
		var thisvalue=document.all("sharetype").value;
		document.all("relatedshareid").value="";
		document.all("showseclevel").style.display='';
		document.all("showseclevel_line").style.display='';
		if(thisvalue==1){
			document.all("showresource").style.display='';
			document.all("showseclevel").style.display='none';
		    document.all("showseclevel_line").style.display='none';
		    document.all("seclevel").value=0;
		} else {
			document.all("showresource").style.display='none';
		}
		if(thisvalue==2){
	 		document.all("showsubcompany").style.display='';
	 		document.all("seclevel").value=10;
		} else {
			document.all("showsubcompany").style.display='none';
			document.all("seclevel").value=10;
		}
		if(thisvalue==3){
		 	document.all("showdepartment").style.display='';
		 	document.all("seclevel").value=10;
		} else {
			document.all("showdepartment").style.display='none';
			document.all("seclevel").value=10;
		}
		if(thisvalue==4){
		 	document.all("showrole").style.display='';
			document.all("showrolelevel").style.display='';
		    document.all("showrolelevel_line").style.display='';
		    document.all("rolelevel").style.display='';
			document.all("seclevel").value=10;
		} else {
			document.all("showrole").style.display='none';
			document.all("showrolelevel").style.display='none';
		    document.all("showrolelevel_line").style.display='none';
		    document.all("rolelevel").style.display='none';
			document.all("seclevel").value=10;
	    }
		if(thisvalue==5){
		 	document.all("seclevel").value=0;
		} else {
			document.all("seclevel").value=0;
		}
	}

	function onShowResource(input,span) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
		
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+" "+dummynames[k]+"";
				}
				document.getElementById(input).value=dummyidArray;
				document.getElementById(span).innerHTML=sHtml;
				
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
		
		
	}

	function onShowSubcompany(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+document.getElementById(input).value);
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+" "+dummynames[k]+"";
				}
				document.getElementById(input).value=dummyidArray;
				document.getElementById(span).innerHTML=sHtml;
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
		
	}

	function onShowDepartment(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.getElementById(input).value);
	    if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+" "+dummynames[k]+"";
			}
			document.getElementById(input).value=dummyidArray;
			document.getElementById(span).innerHTML=sHtml;
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowRole(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				document.getElementById(input).value=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				document.getElementById(span).innerHTML=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
	}
	
</script>

<body>

<div id="userwin" class="x-hidden">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">    
        <tr>
            <td valign="top">
                <TABLE width=100% height=100%>
                    <tr>
                        <td valign="top">  
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>            
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            <SELECT class=InputStyle name="sharetype" id="sharetype" onChange="onChangeSharetype()" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>    
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>    
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename');" name=showsubcompany></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename name=showrelatedsharename></span>                                            
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT id="rolelevel" name="rolelevel">
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                             </SELECT>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2  id=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR id=showseclevel style="display:none">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name="seclevel" class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2 id=showseclevel_line style="display:none"></TD>
                                     </TR>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
            </td>
        </tr>
        </table>
</div>


</body>
</html>