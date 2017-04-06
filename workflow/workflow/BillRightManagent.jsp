<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String detailno = Util.null2String(request.getParameter("detailno"));
String billid = Util.null2String(request.getParameter("billid"));
String operation = Util.null2String(request.getParameter("operation"));
if(operation.equals("submit")){
	String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
	RecordSet.executeSql("update workflow_bill set subcompanyid="+subcompanyid+" where id="+billid);
}

RecordSet.executeSql("select subcompanyid from workflow_bill where id="+billid);
RecordSet.next();
int subcompanyid=Util.getIntValue(RecordSet.getString("subcompanyid"),0);

String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(18581,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementDetail"+detailno+".jsp?billId="+billid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="BillRightManagent.jsp">
<input type="hidden" name=operation  value="">
<input type="hidden" name=billid  value="<%=billid%>">
<input type="hidden" name=detailno  value="<%=detailno%>">
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
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<tr>
				    <td><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
                    <TD class=Field>
                        <BUTTON class=Browser id=SelectSubcomany onclick="onShowSubcompany()"></BUTTON> 
                        <SPAN id=supsubcomspan>                
                            <%if(subcompanyid>0){%>     
                                <%=SubComanyComInfo.getSubCompanyname(""+subcompanyid)%>
                            <%}%>           
                        </SPAN> 
                        <input class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">  
                    </TD>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				</TBODY>
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
</BODY>

<!--<script language=vbs>
    sub onShowSubcompany()
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.subcompanyid.value)
        issame = false 
        if (Not IsEmpty(id)) then
        if id(0)<> 0 then
        if id(0) = frmMain.subcompanyid.value then
            issame = true 
        end if
        supsubcomspan.innerHtml = id(1)
        frmMain.subcompanyid.value=id(0)
        else
        supsubcomspan.innerHtml = ""
        frmMain.subcompanyid.value=""
        end if
        end if
    end sub
</script>  -->

<script language="javascript">
	function onSubmit(){
		document.all("operation").value="submit";
		frmMain.submit();
	}
	
	function onShowSubcompany(){
        datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+$GetEle("subcompanyid").value);
        issame = false ;
        if(datas){
	        if(datas.id!="0"&&datas.id!=""){
	        if(datas.id ==  $GetEle("subcompanyid").value){
	            issame = true ;
	        }
	        $GetEle("supsubcomspan").innerHTML = datas.name;
	        $GetEle("subcompanyid").value=datas.id;
	        }else{
	          //supsubcomspan.innerHtml = "";
	          //frmMain.subcompanyid.value="";
	          $GetEle("supsubcomspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		      $GetEle("subcompanyid").value="";
	        }
        }
    }
	
</script>

</HTML>
