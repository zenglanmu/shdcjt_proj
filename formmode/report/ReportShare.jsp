<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<BODY> 
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
int reportid = Util.getIntValue(request.getParameter("id"),0);

ReportShareInfo.setUser(user);
ReportShareInfo.setReportid(reportid);

Map allRightMap = ReportShareInfo.getAllRightList();			//所有权限
List addRightList = ReportShareInfo.getAddRightList();

%>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<FORM id=weaver name=weaver action="ModeCommonRightOperation.jsp" method=post>
				<input type=hidden name="method" value="addNew">
				<input type=hidden name=reportid value="<%=reportid %>">
				<input type=hidden name=mainids >
				<TABLE class=ViewForm>
					<TBODY>
						<TR>
							<TD vAlign=top>
						        <TABLE class=ViewForm >
									<COLGROUP>
										<col width="8%">
										<col width="35%">
										<col width="*">
									</COLGROUP>
									<TBODY>
										<TR class=Title>
							            	<th colspan=2 noWrap><%=SystemEnv.getHtmlLabelName(26137,user.getLanguage())%></th>
							    			<td align=right>&nbsp;
							    		  		<input type="checkbox" name="chkPermissionAll0" onclick="chkAllClick(this,0)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
							    		  		<a href="ReportShareAdd.jsp?righttype=0&reportid=<%=reportid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
							    		  		<a href="#" onclick="javaScript:doDelShare(0);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
							            	</td>
							          	</TR>
							          	<TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
							          	<%
								            Map datamap = null;
								            for(int i=0 ;i < addRightList.size();i++){
								          	  datamap = (Map)addRightList.get(i);
								          	  String rightid = (String)datamap.get("rightId");
								          	  String sharetypetext = (String)datamap.get("sharetypetext");
								          	  String detailText = (String)datamap.get("detailText");
							          	%>
							          	<tr>
							            	<td><input type="checkbox" name="rightid0" id="rightid0" value="<%=rightid %>"></td>
							            	<td class="field"><%=sharetypetext %></td>
							            	<td class="field"><%=detailText%></td>
							          	</tr>
							          	<TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
							          	<%
							          		}
							          	%>
						          	</TBODY>
								</TABLE>
						     </TD>
						</TR>
					</TBODY>
				</TABLE>
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
<script language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
})

function onSave(){
	weaver.submit();
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}

function doback(){
	location.href = "/formmode/report/ReportEdit.jsp?id=<%=reportid%>";
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids = mainids + "," + chk.value;
    }
    if(mainids == '') {
    	alert("<%=SystemEnv.getHtmlLabelName(22346,user.getLanguage())%>");
    }else if(isdel()){
    	weaver.method.value="delete";
    	weaver.mainids.value=mainids;
    	weaver.action="ReportShareOperation.jsp";
    	weaver.submit();
	    //window.location = "ReportShareOperation.jsp?method=delete&mainids="+mainids+"&reportid=<%=reportid%>";
	}
}
function onSelectChange(obj1,obj2){
     var selectValue = obj1.value;
     if (selectValue!=99) obj2.style.display="";
     else  obj2.style.display="none";           
}
</script>
</BODY></HTML>