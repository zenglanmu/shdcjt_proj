<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WFFreeFlowManager" class="weaver.workflow.request.WFFreeFlowManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%

    int requestid = Util.getIntValue(request.getParameter("requestid"));
    int nodeid = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "nodeid"));
    String src = Util.null2String(request.getParameter("src"));
    String checkfield="";
    boolean saveflag=true;
    if (src.equals("save")) {
        //WFFreeFlowManager.setDebug(true);
        saveflag=WFFreeFlowManager.SaveFreeFlow(request,requestid,nodeid,user.getLanguage());
    }
    RecordSet=WFFreeFlowManager.getFreeWFStep(requestid,nodeid);
%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(68, user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21787, user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:onClose(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form name="FreeWorkflowSetform" method="post" action="FreeWorkflowSet.jsp">
<input type=hidden name="requestid" value="<%=requestid%>">
<input type="hidden" value="save" name="src">
<TABLE class=ListStyle cellspacing=1 id="freewfoTable" width="100%">
<COLGROUP>
<COL width="8%">
<COL width="10%">
<COL width="35%">
<COL width="23%">
<COL width="24%">
<TBODY>
<TR>
    <TD colSpan=3><b><%=SystemEnv.getHtmlLabelName(21787, user.getLanguage())%>
    </b></TD>
    <TD colSpan=2 align="right">
        <a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='addStep()'>
            <img src="/js/swfupload/add.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21788, user.getLanguage())%>
        </a>
        &nbsp;
        <a style="color:#262626;cursor:hand;TEXT-DECORATION:none" onclick="delStep()">
            <img src="/js/swfupload/delete.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21789, user.getLanguage())%>
        </a>
    </TD>
</TR>
<TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=5 style="padding:0;margin:0;"></TD>
</TR>
<TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(1426, user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15486, user.getLanguage())%>
    </TH>
    <TH><%=SystemEnv.getHtmlLabelName(15694, user.getLanguage())%>
    </TH>
    <TH><%=SystemEnv.getHtmlLabelName(21790, user.getLanguage())%>
    </TH>
    <TH><%=SystemEnv.getHtmlLabelName(17482, user.getLanguage())%>
</TR>
<%
    int i=0;
    while (RecordSet.next()) {
        checkfield+=",nodename_"+i+",operators_"+i;
        String operators=Util.null2String(RecordSet.getString("operators"));
        String operatornames="";
        ArrayList operatorlist=Util.TokenizerString(operators,",");
        for(int j=0;j<operatorlist.size();j++){
            if(operatornames.equals("")){
                operatornames=ResourceComInfo.getLastname((String)operatorlist.get(j));
            }else{
                operatornames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
            }
        }
        int floworder=Util.getIntValue(RecordSet.getString("floworder"),0);
        String nodename=Util.null2String(RecordSet.getString("nodename"));
        int Signtype=Util.getIntValue(RecordSet.getString("Signtype"),0);
%>
<TR <%if(i%2==0){%>CLASS="DataDark" <%}else{%>class="DataLight" <%}%>>
    <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
    <TD><input type='text' class=inputstyle name='floworder_<%=i%>' value='<%=floworder%>' size="5" maxlength="3"></TD>
    <TD><input type='text' class=inputstyle name='nodename_<%=i%>' value='<%=nodename%>' onBlur="checkinput('nodename_<%=i%>','nodenamespan_<%=i%>')"><SPAN id="nodenamespan_<%=i%>"><%if(nodename.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN></TD>
    <TD><select class=inputstyle name='Signtype_<%=i%>'>
        <option value="0" <%if(Signtype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>
        <option value="1" <%if(Signtype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>
        <option value="2" <%if(Signtype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>
    </select>
    </TD>
    <TD>
        <button type=button  class=Browser onclick="ShowMultiResource('operatorsspan_<%=i%>','operators_<%=i%>')"></button>
        <SPAN id="operatorsspan_<%=i%>"><%if (operators.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%} else {%><%=operatornames%><%}%></SPAN>
        <input type='hidden' class=inputstyle name='operators_<%=i%>' value="<%=operators%>">
    </TD>
</TR>
<%
        i++;
    }
    if(RecordSet.getCounts()<1){
        checkfield+=",nodename_"+i+",operators_"+i;
%>
<TR <%if(i%2==0){%>CLASS="DataDark" <%}else{%>class="DataLight" <%}%>>
    <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
    <TD><input type='text' class=inputstyle name='floworder_<%=i%>' size="5" maxlength="3" value="1"></TD>
    <TD><input type='text' class=inputstyle name='nodename_<%=i%>' value="<%=SystemEnv.getHtmlLabelName(18731, user.getLanguage())%><%=i+1%>" onBlur="checkinput('nodename_<%=i%>','nodenamespan_<%=i%>')"><SPAN id="nodenamespan_<%=i%>"></SPAN></TD>
    <TD><select class=inputstyle name='Signtype_<%=i%>'>
        <option value="0"><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>
    </select>
    </TD>
    <TD>
        <button type=button  class=Browser onclick="ShowMultiResource('operatorsspan_<%=i%>','operators_<%=i%>')"></button>
        <SPAN id="operatorsspan_<%=i%>"><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
        <input type='hidden' class=inputstyle name='operators_<%=i%>' value="">
    </TD>
</TR>
<%
        i++;
    }
%>
</TBODY>
</TABLE>
<input type='hidden' id="rownum" name="rownum" value="<%=i%>">
<input type='hidden' id="indexnum" name="indexnum" value="<%=i%>">
<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">
</form>

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


</body>
</html>

<script language=javascript>
    function menuhidden(){
        rightMenu.style.visibility="hidden";
    }
    function onSave(obj) {
        if (check_form(document.FreeWorkflowSetform,document.FreeWorkflowSetform.checkfield.value)){
            document.FreeWorkflowSetform.submit();
            obj.disabled=true;
        }
    }


    function onClose() {
        window.parent.close();
    }

    function addStep(){
        var oTable=document.all('freewfoTable');
    var curindex=parseInt(document.all('rownum').value);
    var rowindex=parseInt(document.all('indexnum').value);
    var ncol = 5;
    var oRow = oTable.insertRow(-1);
    for(j=0; j<ncol; j++) {
        var oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		oCell.style.background= "rgb(245, 250, 250)";
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.style.width = "8%";
                oCell.appendChild(oDiv);
                break;
            }
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='text' class='inputstyle input styled' name='floworder_"+rowindex+"' size='5' maxlength='3' value='"+(rowindex+1)+"'>";
                oDiv.innerHTML = sHtml;
                oCell.style.width = "10%";
                oCell.appendChild(oDiv);
                break;
            }
            case 2:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='text' class='inputstyle input styled' name='nodename_"+rowindex+"' value='<%=SystemEnv.getHtmlLabelName(18731, user.getLanguage())%>"+(rowindex+1)+"' onBlur=checkinput('nodename_"+rowindex+"','nodenamespan_"+rowindex+"')>";
                sHtml+="<span id='nodenamespan_"+rowindex+"'></span>";
                oDiv.innerHTML = sHtml;
                oCell.style.width = "35%";
                oCell.appendChild(oDiv);
                break;
            }
            case 3:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='Signtype_"+rowindex+"'>";
                sHtml+="<option value='0'><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>";
                sHtml+="<option value='1'><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>";
                sHtml+="<option value='2'><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>";
                sHtml+="</select>";
                oDiv.innerHTML = sHtml;
                oCell.style.width = "23%";
                oCell.appendChild(oDiv);
                break;
            }
            case 4:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<button type=button  class=Browser onclick=\"ShowMultiResource('operatorsspan_"+rowindex+"','operators_"+
                            rowindex+"')\"></button><SPAN id='operatorsspan_"+rowindex+
                            "'><IMG src='/images/BacoError.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='operators_"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.style.width = "24%";
                oCell.appendChild(oDiv);
                break;
            }
        }
    }
    document.all('checkfield').value = document.all('checkfield').value+"nodename_"+rowindex+",operators_"+rowindex+",";
    document.all("rownum").value = curindex+1 ;
    document.all('indexnum').value = rowindex+1;
    }

    function delStep(){
        var oTable=document.all('freewfoTable');
        curindex=parseInt(document.all("rownum").value);
        len = document.FreeWorkflowSetform.elements.length;
        var i=0;
        var rowsum1 = 0;
        var checknum=0;
        for(i=len-1; i >= 0;i--) {
            if (document.FreeWorkflowSetform.elements[i].name=='check_node'){
                rowsum1 += 1;
                if(document.FreeWorkflowSetform.elements[i].checked==true) checknum+=1;
            }
        }
        if(checknum>0){
            if(isdel()){
                for(i=len-1; i >= 0;i--) {
                    if (document.FreeWorkflowSetform.elements[i].name=='check_node'){
                        if(document.FreeWorkflowSetform.elements[i].checked==true) {
                            document.all('checkfield').value = (document.all('checkfield').value).replace("nodename_"+document.FreeWorkflowSetform.elements[i].value+",","");
                            document.all('checkfield').value = (document.all('checkfield').value).replace("operators_"+document.FreeWorkflowSetform.elements[i].value+",","");
                            oTable.deleteRow(rowsum1+2);
                            curindex--;
                        }
                        rowsum1 -=1;
                    }
                }
                document.all("rownum").value=curindex;
            }
        }else{
            alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
        }
    }

    function picreload(){
    	/*新的流程图的id：piciframe；老的流程图的id：picInnerFrame；流程图iframe的上层节点的id：divWfPic*/
    	/*
    	try{
    		dialogArguments.parent.document.frames("piciframe").location.reload(true);
    	}catch(ex){
    		try{
    			var _divWfPic=dialogArguments.parent.document.getElementById("divWfPic");
    			_divWfPic.innerHTML="<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>";
    		}catch(ex){
    			alert("ex2="+ex.message);
    		}
    	}
    	*/
        //dialogArguments.document.all("picframe").src=dialogArguments.document.all("picframe").src;
       
        var piciframe=jQuery("#piciframe",top.dialogArguments.parent.document);
        if(piciframe.length==0){
    	    var _divWfPic=top.dialogArguments.parent.document.getElementById("divWfPic");
    	    _divWfPic.innerHTML="<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>";
    	}else{
    	    piciframe.attr("src",piciframe.attr("src"));
    	}
    	
        onClose();
        dialogArguments.alert("<%=SystemEnv.getHtmlLabelName(22527,user.getLanguage())%>");
    }

    <%
    if(src.equals("save")){
    if(saveflag){
    %>
    picreload();
    <%
    }else{
    %>
    alert("<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>");
    <%
    }
    }
    %>
    menuhidden();
    
    
function ShowMultiResource(spanname,hiddenidname) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G(hiddenidname).value);
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);

		if (rid != "" && rid != "0") {
            $G(spanname).innerHTML = rname.substr(1);
            $G(hiddenidname).value= rid.substr(1);
	    } else {
            $G(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            $G(hiddenidname).value="";
        }
	}
}
</script>
<!-- 
<script language="VBScript">
sub ShowMultiResource(spanname,hiddenidname)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+hiddenidname.value)
	if (Not IsEmpty(id)) then
        If id(0) <> "" and id(0) <> "0" Then
            spanname.innerHtml = Mid(id(1),2,len(id(1)))
            hiddenidname.value= Mid(id(0),2,len(id(0)))
	    else
            spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
            hiddenidname.value=""
        end if
    end if
end sub
</script>
 -->