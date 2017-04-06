<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"
	scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo"
	scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo"
	scope="page" />

<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<html>
	<head>
		<link href="/css/Weaver.css" type=text/css rel=stylesheet>
	</head>
	<%
		//菜单样式浏览页面，可以不用进行权限验证
		/*
		if (!HrmUserVarify.checkUserRight("homepage:styleMaint", user))
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}*/

		String type = Util.null2String(request.getParameter("type"));
		ArrayList idList = new ArrayList();
		ArrayList nameList = new ArrayList();
		ArrayList descList = new ArrayList();
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = "";
		String pageEdit = "";
		if ("element".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22913, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "ElementStyleEdit.jsp";

			esc.setTofirstRow();
			while (esc.next())
			{
				idList.add(esc.getId());
				nameList.add(esc.getTitle());
				descList.add(esc.getDesc());
			}
		}
		else if ("menuh".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22914, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditH.jsp";

			mhsc.setTofirstRow();
			while (mhsc.next())
			{
				idList.add(mhsc.getId());
				nameList.add(mhsc.getTitle());
				descList.add(mhsc.getDesc());
			}
		}
		else if ("menuv".equals(type))
		{
			titlename = SystemEnv.getHtmlLabelName(22915, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditV.jsp";

			mvsc.setTofirstRow();
			while (mvsc.next())
			{
				idList.add(mvsc.getId());
				nameList.add(mvsc.getTitle());
				descList.add(mvsc.getDesc());
			}
		}
		String needfav = "1";
		String needhelp = "";
	%>

<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver.css">
	</HEAD>

	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp"%>
	<BODY>
		<FORM NAME="SearchForm" action="javascript:void(0);" method=post>
			<input type="hidden" name="pagenum" value=''>

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
									
									<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" style="width:100%"
										cellpadding="0">
										<TR class=DataHeader>
											<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TH>
										</TR>
										<TR class=Line>
											<TH colSpan=3></TH>
										</TR>
										<%
											ArrayList cloneNameList = (ArrayList) nameList.clone();
											Collections.sort(cloneNameList);
											
											for (int i = 0; i < cloneNameList.size(); i++)
											{
												String stylename = (String) cloneNameList.get(i);
												int pos = nameList.indexOf(stylename);

												String styleid = (String) idList.get(pos);
												String styledesc = (String) descList.get(pos);
										%>
										<TR <%if((i+1)%2==0) out.println(" class='DataDark' "); else out.println(" class='DataLight' ");%>>
											<TD style="display: none"><A HREF=#><%=styleid%></A></TD>
											<TD valign="middle" width="15%">
												<%=stylename%>
											</TD>
											<TD valign="middle" width="40%"><%=styledesc%></TD>
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
					<td height="10" colspan="3"></td>
				</tr>
			</table>
		</FORM>
	</BODY>
</HTML>
<SCRIPT LANGUAGE=VBS>


</SCRIPT>
<script type="text/javascript">
function btnclear_onclick(){
    window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
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
     window.parent.parent.returnValue = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text(),
    		 a1:jQuery(curTr.cells[3]).text(),
    		 a2:jQuery(curTr.cells[4]).text()};
    

      window.parent.parent.close();
	}
}
$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	
	
	
});
</script>