<%@ page import = "weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<HTML>
<HEAD>
<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16693 , user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";
boolean CanAdd = HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user);

Calendar thedate = Calendar.getInstance() ; //

String currentdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;   // 当天

String rightlevel = HrmUserVarify.getRightLevel("HrmArrangeShiftMaintance:Maintance" , user ) ;
String sqlwherestr = "" ;

if(rightlevel.equals("0") ) {
    sqlwherestr = "?sqlwhere=where departmentid=" + user.getUserDepartment() ; 
}
else if(rightlevel.equals("1") ) {
    sqlwherestr += "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ; 
}

String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门
String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String resourceid = Util.fromScreen(request.getParameter("resourceid") , user.getLanguage()) ; //人力资源
String shiftname = Util.fromScreen(request.getParameter("shiftname") , user.getLanguage()) ; //排班类型
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15413,user.getLanguage())+",javascript:doCreate(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftMaintance.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="HrmArrangeShiftMaintanceOperation.jsp">
<input class=inputstyle type="hidden" name="operation" value=process>
<input class=inputstyle type="hidden" name="department" value="<%=department%>">

<table class=viewform>
  <colgroup>
  <col width="30%">
  <col width="70%">    
  <tbody>
    <tr class=Title>
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(16693,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:1px"> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
      
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD> 
		    <TD class=Field>
              <BUTTON class=Browser type="button" onClick="onShowResource(multresourceidspan,multresourceid)"></BUTTON> 
              <span class=inputstyle id=multresourceidspan>
               <%if(!resourceid.equals("")){%><%=ResourceComInfo.getResourcename(resourceid)%><%}else{%>
              <IMG src='/images/BacoError.gif' align=absMiddle>
               <%}%>
              </span> 
              <INPUT id=multresourceid type=hidden name=multresourceid>
            </TD>
		</TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(740 , user.getLanguage())%></td>
      <td class=field>
         <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(fromdatespan,fromdate)"></BUTTON> 
         <SPAN id=fromdatespan >
         <%if(!fromdate.equals("")){%><%=fromdate%><%}else{%>
              <IMG src="/images/BacoError.gif" align=absMiddle>
              <%}%>
         </SPAN> 
         <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>" onChange='checkinput("fromdate","fromdatespan")'>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(741 , user.getLanguage())%></td>
      <td class=field>
        <BUTTON class=Calendar type="button" id=selectendsedate onclick="getDate(enddatespan,enddate)"></BUTTON> 
         <SPAN id=enddatespan >
         <%if(!enddate.equals("")){%><%=enddate%><%}else{%>
              <IMG src="/images/BacoError.gif" align=absMiddle>
              <%}%>
         </SPAN> 
          <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>" onChange='checkinput("enddate","enddatespan")'>
      </td>  
    </tr>
 <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <tr>
      <td><%=SystemEnv.getHtmlLabelName(16255 , user.getLanguage())%></td>
      <td class=field>         

              <input class="wuiBrowser" type="hidden" id="shiftname" name="shiftname" value="<%=shiftname%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmArrangeShiftBrowser.jsp"
			  _displayText="<%=shiftname%>">
              
     </td>
    </tr>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   </tbody>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
//浏览框显示值
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a target='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

 function onShowResource(spanname , inputname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwherestr%>",inputname , spanname);
 }

 function doCreate(obj){
     if(check_form(document.frmmain,'multresourceid,fromdate,enddate')){
         if( document.frmmain.fromdate.value > document.frmmain.enddate.value ) {
             alert("错误！开始日期大于结束日期！") ;
             return ;
         }

         if( document.frmmain.fromdate.value < "<%=currentdate%>" ) {
             alert("错误！开始日期不能小于等于当前日期！") ;
             return ;
         }

         if( document.frmmain.shiftname.value=='') {
             if(confirm("排班种类没有选择,将清除选定人员选定日期的排班信息,是否继续？")) {
                 document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
                 document.frmmain.operation.value="process" ; 
                 obj.disabled = true ;
                 document.frmmain.submit();
             }
         }
         else {
             document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
             document.frmmain.operation.value="process" ; 
             obj.disabled = true ;
             document.frmmain.submit();
         }
     }
 }

</script>

<script language=vbs>
 sub onShowResource1(spanname , inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwherestr%>")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            spanname.innerHtml = Mid(id(1),2,len(id(1)))
            inputname.value=Mid(id(0),2,len(id(0)))
        else 
            spanname.innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle>"
            inputname.value=""
	end if
	end if
end sub

sub onShowArrangeShift(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmArrangeShiftBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		tdname.innerHtml = id(1)
		inputename.value=id(0)
		else
		tdname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub
</script>
</body>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>