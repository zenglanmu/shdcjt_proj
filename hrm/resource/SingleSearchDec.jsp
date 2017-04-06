<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SelectByDec.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	if(userightmenu_self == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<button type="button"  class=btnSearch accessKey=S style="display:none" id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<button type="button"  class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<button type="button"  class=btnok accessKey=1 style="display:none" onclick="window.parent.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button"  class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=lastname ></TD>
   
<TD width=15%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=status name=status >
          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value="" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        </select>   
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR> 

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectSubcompany onclick="onShowSubcompany()"></BUTTON>
        <SPAN id=subcompanyspan></SPAN>
        <INPUT id=subcompanyid type=hidden name=subcompanyid >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
        <SPAN id=departmentspan></SPAN>
        <input class=inputstyle type=hidden name=departmentid>
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>    
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 >
      </td>
<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<TD width=35% class=field>
        
        <input class=wuiBrowser type=hidden name=roleid _url="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp">
      </TD>

</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD> 
</table>
<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
<input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
<input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function btnsub_onclick(){
    $("input[name=tabid]").val(2);
    document.SearchForm.submit();
}
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}
function onShowSubcompany(){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+$("input[name=subcompanyid]").val()
			,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px");
	if(datas){
		//alert(datas.id);
		if (datas.id!=""){
			$("#subcompanyspan").html ( datas.name);
			$("input[name=subcompanyid]").val(datas.id);

			$("#departmentspan").html("");
			$("input[name=departmentid]").val("");
		}
		else{
			$("#subcompanyspan").html ( "");
			$("input[name=subcompanyid]").val("");
		}
	}
}
function onShowDepartment(){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name=departmentid]").val()
			,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px");
	if (datas){
		if (datas.id!="") {
				$("#departmentspan").html(datas.name);
				$("input[name=departmentid]").val(datas.id);
				$("#subcompanyspan").html("");
				$("input[name=subcompanyid]").val("");
			}
            else{
            	$("#departmentspan").html("");
				$("input[name=departmentid]").val("");
			}
	}
}

</script>
</BODY>
</HTML>