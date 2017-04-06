<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
    int wtid =Util.getIntValue(request.getParameter("wtid"));
    
	//System.out.println("wtid = "+wtid);

%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.reload(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
     
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow>
                    <tr>
                        <td valign="top">  
                            <form name="weaver" method="post">
								<INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">           
								<INPUT type="hidden" Name="method" value="savemonitor">
								<INPUT type="hidden" Name="delids" value="">
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
								<TR class=Title>
									<TH colSpan=2><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())+SystemEnv.getHtmlLabelName(17989,user.getLanguage())%></TH>
								</TR>
								<TR class=Spacing style="height:2px">
									<TD class=Line1 colSpan=2></TD>
								</TR>
                                    <TR>
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(21968,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                            <BUTTON class=Browser type="button" onClick="onShowResource(monitor, showmonitorspan)" name="showmonitor"></BUTTON> 
                                            <INPUT type=hidden name="monitor"  id="monitor" value="">
                                            <span id="showmonitorspan" name="showmonitorspan"><IMG src='/images/BacoError.gif' align=absMiddle></span>                                            
                                        </td>
                                    </TR>
                                     <TR style="height:1px">
                                        <TD class=Line colSpan=2 ></TD>
                                     </TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(21969,user.getLanguage())%>
                                        </TD>
                                        <TD class="field">
                                            <SELECT class=InputStyle  name="monitortype" >
												<option value="0" selected><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option> 
                                                <option value="1"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%></option>
											</SELECT>
                                        </TD>		
                                    </TR>
                                    <TR style="height:1px">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>
                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="80%"></TD>
                                                <TD>
                                                   <button class="btnNew" type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addValue()" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
                                                </td>
                                                <td>
                                                   <button class="btnDelete" type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
                                                </TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                   <TR style="height:1px">
                                        <TD class=Line colSpan=2></TD>
                                   </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="5%">
                                                <col width="50%">
                                                <col width="45%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(21968, user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(21969, user.getLanguage())%></td>
                                                </tr>
                                            </table>
                                            <table class="listStyle" id="oTable2" name="oTable2">
                                                <colgroup>
                                                <col width="5%">
                                                <col width="50%">
                                                <col width="45%">
												<%
													String classStr = "DataDark";
													boolean classFlag = true;
													rs.execute("select * from worktask_monitor where taskid="+wtid);
													while(rs.next()){
														int id = Util.getIntValue(rs.getString("id"), 0);
														int monitor = Util.getIntValue(rs.getString("monitor"), 0);
														int monitortype = Util.getIntValue(rs.getString("monitortype"), 0);
														String monitortypeStr = "";
														String monitorStr = "<a href=javaScript:openFullWindowHaveBar(\'/hrm/resource/HrmResource.jsp?id="+monitor+"\') >"+ResourceComInfo.getResourcename(""+monitor)+"</a>";
														if(monitortype == 2){
															monitortypeStr = SystemEnv.getHtmlLabelName(140,user.getLanguage());
														}else if(monitortype == 1){
															monitortypeStr = SystemEnv.getHtmlLabelName(141,user.getLanguage());
														}else{
															monitortypeStr = SystemEnv.getHtmlLabelName(124,user.getLanguage());
														}
														//String totalValue = ""+sharetype+"_"+relatedshareid+"_"+rolelevel+"_"+seclevel;
												%>
												<tr class="<%=classStr%>">
													<td><input class="inputStyle" type="checkbox" name="chkShareDetail2" value="<%=id%>"><input type="hidden" name="txtShareDetail2" value="<%=id%>"></td>
													<td><%=monitorStr%></td>
													<td><%=monitortypeStr%></td>
												</tr>
												<%
													if(classFlag == true){
														classFlag = false;
														classStr = "DataLight";
													}else{
														classFlag = true;
														classStr = "DataDark";
													}
												}%>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
                </form>
            </td>
            <td></td>
        </tr>
        <tr>
            <td height="0" colspan="3"></td>
        </tr>
        </table>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--

function removeValue(){
    
    if(jQuery("input[name='chkShareDetail2']:checked").length==0&&jQuery("input[name='chkShareDetail']:checked").length==0){
       alert("<%=SystemEnv.getHtmlLabelName(18131, user.getLanguage())%>");
       return ;
    }
    
    if(jQuery("input[name='chkShareDetail2']:checked").length>0||jQuery("input[name='chkShareDetail']:checked").length>0){
       if(!window.confirm("<%=SystemEnv.getHtmlLabelName(23069, user.getLanguage())%>?"))
          return ;
    }
	try{
		var chks = document.getElementsByName("chkShareDetail");
		for (var i=chks.length-1; i>=0; i--){
			var chk = chks[i];
			//alert(i);
			//alert(chk.value);
			//alert(chk.parentElement.parentElement.parentElement.tagName);
			if (chk.checked){
				oTable.deleteRow(jQuery(chk).parent().parent().parent().index());
			}
		}
	}catch(e){}
	try{
		var chks2 = document.getElementsByName("chkShareDetail2");
		for (var j=chks2.length-1; j>=0; j--){
			var chk2 = chks2[j];
			var delids = document.weaver.delids.value;
			//alert(j);
			//alert(chk2.value);
			//alert(chk2.parentElement.parentElement.rowIndex);
			if (chk2.checked){
				oTable2.deleteRow(jQuery(chk2).parent().parent().index());
				document.weaver.delids.value = delids + chk2.value + ",";
				delids = document.weaver.delids.value;
			}
		}
	}catch(e){}
}

function addValue(){
	thisvalue=jQuery("select[name=monitortype]").val();

	var monitortypeValue = thisvalue;
	var monitortypeText = jQuery("select[name=monitortype] option:selected").html();

	var relatedShareIds="0";
	var relatedShareNames="";
	if(!check_form(document.weaver,'monitor')) {
		return ;
	}
	monitorIds = jQuery("#monitor").val();
	monitorNames= jQuery("#showmonitorspan").html();

	var totalValue = monitorIds+"_"+monitortypeValue;

	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;

	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";

	for (var i =1; i <=3; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML = monitorNames;
		else  if (i==3) oDiv.innerHTML = monitortypeText;
		oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked = obj.checked;
    }
	try{
		var chks2 = document.getElementsByName("chkShareDetail2");
		for (var i=0;i<chks2.length;i++){
			var chk2 = chks2[i];
			chk2.checked = obj.checked;
		}
	}catch(e){}
}

function onShowResource(inputname,spanname){
linkurl="/hrm/resource/HrmResource.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
if (data) {
	if (data.id!= "") {
		ids = data.id.split(",");
		names =data.name.split(",");
		sHtml = "";
		for( var i=0;i<ids.length;i++){
			if(ids[i]!=""){
			    sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
			}
		}
			jQuery(spanname).html(sHtml);
			jQuery(inputname).val(data.id.substr(1));
		} else {
			jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
		}
	}
}

function doSave(obj){
	obj.disabled=true;
	document.weaver.action="/worktask/base/worktaskMonitorOperator.jsp";
	document.weaver.submit();
}

function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=5");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}
</SCRIPT>


