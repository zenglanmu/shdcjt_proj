<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT> 
   </HEAD>
<%  
    int chkNeedAppr=0;
	 int wfid = 0;
    rs.executeSql("SELECT * FROM ProjTemplateMaint WHERE id=1");
    if (rs.next()){
      chkNeedAppr=Util.getIntValue(rs.getString("isNeedAppr"),0);
		wfid = rs.getInt("wfid");
    }

    if (!HrmUserVarify.checkUserRight("projTemplateSetting:Maint", user)) {
        response.sendRedirect("/notice/noright.jsp") ; 
        return;
    }
    

    String imagefilename = "/images/sales.gif";
    String titlename = SystemEnv.getHtmlLabelName(18371,user.getLanguage());
    String needfav ="1";
    String needhelp ="";//取得相应设置的值
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;  

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
    <TD height="10" colspan="3"></TD>
</TR> 
<TR>
    <TD></TD>
    <TD valign="top">
        <Form name="frmAdd" method="post" action="TempletSettingOperation.jsp">
        <input type="hidden" name="method" value="add">          
         <TABLE class=Shadow >
            <TR>
                <TD valign="top">                    
                    <TABLE  CLASS="viewForm"  valign="top">
                    <colgroup>
                        <col width="30%">
                        <col width="70%">
                       </colgroup>
                        <!--基本信息-->
                        <TR align="left"> <TH  colspan=2 ><%=SystemEnv.getHtmlLabelName(18371,user.getLanguage())%></TH></TR>
                        <TR style="height:1px;"><Td class=line1  colspan=2></Td></TR>
                        <TR>
                          <Td><%=SystemEnv.getHtmlLabelName(18393,user.getLanguage())%></Td>
                          <Td class=field><input type="checkbox" name="chkNeedAppr" id="chkNeedAppr" class="inputStyle" value="1" <%if(chkNeedAppr==1) out.println("checked");%> onclick="checkWorkFlow()"></Td>
                        </TR>
                        <TR style="height:1px;"><Td class=line  colspan=2></Td></TR>
								<TR>
                          <Td><%=SystemEnv.getHtmlLabelName(18043,user.getLanguage())%></Td>
                          <Td class=field>
								  <button type="button" class=Browser id=SelectFlowID onClick="onShowFlowID(),checkWorkFlow()"></BUTTON> 
								  <span id=flowidspan><%=wfComInfo.getWorkflowname(String.valueOf(wfid))%></span> 
								  <INPUT class=inputStyle id=relatingFlow type=hidden name=relatingFlow value="<%=wfid%>">
								  </Td>
                        </TR>
                        <TR style="height:1px;"><Td class=line  colspan=2></Td></TR>
                    </TABLE>
                </TD>
            </TR>            
         </TABLE>
         </FORM>
    </TD>
    <TD></TD>
</TR>                    
<TR>
    <TD height="10" colspan="3"></TD>
</TR>

</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
var oWF,oWFID,o;
window.onload = function(){
	oWF = document.getElementById("flowidspan");
	oWFID = document.getElementById("relatingFlow");
	o = document.getElementById("chkNeedAppr");
	checkWorkFlow();
};

function doSave(obj){
	if(o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return false;
	}else{
		obj.disabled=true;
		frmAdd.submit();
	}
}
function checkWorkFlow(){
	if(o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){	
		oWF.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
	if(!o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){
		oWF.innerHTML = "";
	}
}
//-->
</SCRIPT>
<SCRIPT type="text/javascript">

function onShowFlowID(){ 
	   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=152");
		if(datas){
			if(datas.id!=""){
				$("#flowidspan").html(datas.name);
				$("input[name=relatingFlow]").val(datas.id);
			}else
				if ($("input[name=chkNeedAppr]")[0].checked){
					$("#flowidspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
					$("input[name=relatingFlow]").val("");
				}else{
					$("#flowidspan").html("");
					$("input[name=relatingFlow]").val("");
				}
	}
}
</script>