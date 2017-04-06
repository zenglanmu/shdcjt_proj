<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />

<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver.css">
	</HEAD>
	<%
	%>

	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp"%>
	<BODY>
		<FORM NAME="SearchForm" action="MenusBrowser.jsp" method=post>
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
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
						<TABLE class=Shadow height="100%" width="100%">
							<tr>
								<td valign="top">
								
									<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1"
										cellpadding="0" width="100%">
										<TR class=DataHeader>
											<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>
											</TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%>
											</TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>
											</TH>
										</TR>
										<TR class=Line>
											<TH colSpan=4></TH>
										</TR>
										<%
										int index = 0;
										MenuCenterCominfo.setTofirstRow();
										while (MenuCenterCominfo.next())
										{
											
											String menuType = MenuCenterCominfo.getMenutype();
											String menuId = MenuCenterCominfo.getId();
											String menuName = MenuCenterCominfo.getMenuname();
											String menuDesc = MenuCenterCominfo.getMenuDesc();
											if(!"sys".equals(menuType)&&!"hp".equals(menuType))
											{
												index++;
											}
											else
											{
												continue;
											}
									%>
									<TR class='<%if(index%2==0) out.println("DataDark"); else out.println("DataLight");%>'>
										<TD style="display: none"><A HREF=#><%=menuId%></A></TD>
										<TD valign="middle" width="32%">
											<%=menuName%>
										</TD>
										<TD valign="middle" width="50%">
											<%=menuDesc%>
										</TD>
										<TD valign="middle" width="18%">
											<%if("1".equals(menuType)){ %>
												<%=SystemEnv.getHtmlLabelName(23021, user.getLanguage())%>
											<%}else{ %>
												<%=SystemEnv.getHtmlLabelName(23022, user.getLanguage())%>
											<%} %>
										</TD>
									</TR>
									<%
										}
									%>
									</TABLE>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="4"></td>
				</tr>
			</table>
		</FORM>
	</BODY>
</HTML>
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","£¬");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>