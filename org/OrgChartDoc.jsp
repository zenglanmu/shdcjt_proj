<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.org.layout.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" rel="STYLESHEET" type="text/css">
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<style type="text/css">
.ellipsis {
	padding:1px;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
}
</style>

</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
RecordSet.executeSql("select needupdate from orgchartstate");
    int needupdate = 1;
    if (RecordSet.next())
        needupdate = RecordSet.getInt("needupdate");


int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String departids="\"\"";


RecordSet.executeProc("HrmSubCompany_SByCompanyID",""+companyid);

int subcompanycount = RecordSet.getCounts();
int clientwidth = 125*subcompanycount;

int top = 210;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;


String charttype = Util.null2String(request.getParameter("charttype"));

String doctype_a = Util.null2String(request.getParameter("doctype_a"));
String doctype_p = Util.null2String(request.getParameter("doctype_p"));
String doctype_o = Util.null2String(request.getParameter("doctype_o"));
String doctype_d = Util.null2String(request.getParameter("doctype_d"));
String docstatus = "6" ;

if(charttype.equals(""))
	charttype = "D";

int topMargin = 210;
int leftMargin = 20;
DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);
dl.buildObjectRef();
dl.checkAndAutoset(10, 10, 20, 20);
%>
<table width="<%=dl.getMaxPos().x+60%>" height="<%=dl.getMaxPos().y+300%>" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<FORM action="OrgChartDoc.jsp" id=Baco name=Baco method=post>
			<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
			<TABLE width="100%" height="100%">
				<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%>...</TD></TR>
			</TABLE>
			</DIV>
			<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="50">
				<COL width="200">
				<COL width="">
				<TR>
					<TD ><B><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></B></TD>
					<TD class=Field>
						<SELECT name=charttype onchange="changetype()">
							<OPTION value=D <%if(charttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
							<OPTION value=H <%if(charttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
						<%if(isgoveproj==0){%>
						<%if(software.equals("ALL") || software.equals("CRM")){%>
							<OPTION value=C <%if(charttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
							<OPTION value=R <%if(charttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
						<%}%>
						<%}%>
						<%if(software.equals("ALL") || software.equals("HRM")){%>
							<OPTION value=P <%if(charttype.equals("P")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
						<%}%>
						<%if(isgoveproj==0){%>
						<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){
							if( fnarightlevel.equals("2") ) { %>
							<OPTION value=F <%if(charttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
						<%      }
						}%>
						<%}%>
						</SELECT>
					<script language=javascript>
					function changetype(){
					if(document.all("charttype").value=="C") location = "OrgChartCRM.jsp";
					if(document.all("charttype").value=="F") location = "OrgChartFna.jsp";
					if(document.all("charttype").value=="I") location = "OrgChartLgc.jsp";
					if(document.all("charttype").value=="P") location = "OrgChartCpt.jsp";
					if(document.all("charttype").value=="H") location = "OrgChartHRM.jsp";
					if(document.all("charttype").value=="D") location = "OrgChartDoc.jsp";
					if(document.all("charttype").value=="R") location = "OrgChartProj.jsp";
					}
					</script>
				</TD>
			<!--		<TD width=100><B><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></B></TD>
					<TD width=200>
				<SELECT name=companyid>
				<%
				while(CompanyComInfo.next()){	
					String tmpcompanyid = CompanyComInfo.getCompanyid();
					String isselected="";
					if(Util.getIntValue(tmpcompanyid,0)==companyid)
						isselected=" selected";
				%>
					<OPTION value="<%=CompanyComInfo.getCompanyid()%>" <%=isselected%>><%=CompanyComInfo.getCompanyname()%></OPTION>
				<%}%>
				</SELECT></TD>-->
					<TD></TD>
				</TR>
				<TR style="height:2px"><TD class=Line2 colSpan=4></TD></TR> 
				</TABLE>
				<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="100">
				<COL width="">
					<TR class=Title>
					 <TH colspan="4" ><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
					</TR>
					<TBODY >
					<TR class=Spacing style="height:2px"><TD colspan="4" class=Line1></TD></TR>
					<TR>
						
						<TD >
						<%
						String ischecked = "";
						if(doctype_a.equals("1"))
							ischecked = " checked";
						%>
							<INPUT TYPE=checkbox VALUE=1 name=doctype_a <%=ischecked%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></td><TD width=25%>
						<%
						ischecked = "";
						if(doctype_p.equals("1"))
							ischecked = " checked";
						%>
							<INPUT TYPE=checkbox VALUE=1 name=doctype_p <%=ischecked%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></td><TD width=25%>
						 <!-- 
						<%
			//			ischecked = "";
			//			if(doctype_o.equals("1"))
			//				ischecked = " checked";
						%>	<INPUT TYPE=checkbox VALUE=1 name=doctype_o <%=ischecked%>><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></td><TD width=25%>
						<%
						ischecked = "";
						if(doctype_d.equals("1"))
							ischecked = " checked";
						%>	<INPUT TYPE=checkbox VALUE=1 name=doctype_d <%=ischecked%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%> -->
						</TD>
						<TD></TD>	
						</TR>
						<TR style="height:2px"><TD class=Line2 colSpan=4></TD></TR> 
					</TBODY>
				</TABLE>
				
				
				<%

				DocSearchComInfo.resetSearchInfo();
				if((! doctype_a.equals("1") && !doctype_p.equals("1")) || (doctype_a.equals("1") && doctype_p.equals("1")) ) {
					DocSearchComInfo.addDocstatus("1");
					DocSearchComInfo.addDocstatus("2");
					DocSearchComInfo.addDocstatus("5");
				}
				else {
					if (doctype_a.equals("1") ) {
						DocSearchComInfo.addDocstatus("1");
						DocSearchComInfo.addDocstatus("2");
						docstatus = "1" ;
					}
					if (doctype_p.equals("1") ) {
						DocSearchComInfo.addDocstatus("5");
						docstatus = "5" ;
					}
				}
				%>
				

			<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
			<img src = "<%if(needupdate==0){%>/org/org.jpg<%}else{%>/weaver/weaver.org.layout.ShowDepLayoutToPicServlet<%}%>" border=0>
			<%
			int curnum = 0;
			for (int i=0;i<dl.departments.size();i++) {
				Department depart = (Department)dl.departments.get(i);
				String tmpnum="";
				departids +=",\"";
				departids += depart.id;
				departids +="\"";
				curnum += 1;
				
				String whereclause = "";
				if (depart.type == Department.TYPE_ZONGBU) {
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuTop)" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgComapnyBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=2 align="center" id=t><%=depart.name%></TD></TR>
					<TR height=14px><TD align=right width="75%" style="padding-bottom:6px;"><%=SystemEnv.getHtmlLabelName(2021,user.getLanguage())%></TD>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+DocSearchManage.getRecordersize();
					%>
					<TD align="right" width="25%" style="padding-right:15px;padding-bottom:3px;"><%=tmpnum%></TD>
					</TR>
				</TABLE>		
			<%
				} else if (depart.type == Department.TYPE_FENBU) {
					int subcompanyid = depart.id;
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuGroup)" cellpadding=1 cellspacing=1 
					STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgSubCompanyBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>;display:inline-block;overflow:hidden;"><span><%=depart.name%></span></span></TD></TR>
					<TR height=14px>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						whereclause +=  " and docdepartmentid in ( " +
										" select id from HrmDepartment where subcompanyid1= " +
										subcompanyid + "  or  subcompanyid1  in (select id from hrmsubcompany where supsubcomid="+subcompanyid+") ) ";
						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+ DocSearchManage.getRecordersize();
					%>
					<TD align="right" width=100% style="padding-right:5px;padding-bottom:0px;"><%=tmpnum%></TD>		
					</TR>		
				</TABLE>
			<%
				} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuDivision)" cellpadding=1 cellspacing=1
					STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgDepartmentBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>-<%=depart.departmentMark%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>;display:inline-block;overflow:hidden;"><span><%=depart.name%>-<%=depart.departmentMark%></span></span></TD></TR>
					<TR height=14px>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						whereclause +=  " and docdepartmentid = " +  depart.id;

						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+DocSearchManage.getRecordersize();
					%>
					<TD align="right" width=100% style="padding-right:5px;padding-bottom:0px;"><%=tmpnum%></TD>
					</TR>
				</TABLE>
			<%  } // end of if
			} // end of for
			%>
			</div>
			<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
			<SCRIPT LANGUAGE="JavaScript">
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function getXY(event){
	var leftX;
	var topY;
	if (window.ActiveXObject) {
		leftX = document.body.scrollLeft + event.clientX;
		topY = document.body.scrollTop + event.clientY;
	}else{
		leftX = event.pageX;
		topY = event.pageY;
	}
	return {X:leftX,Y:topY};
}


			var oc_DivisionList = new Array(<%=departids%>);


			var oc_CurrentMenu;
			var oc_CurrentIndex;

			function oc_ShowMenu(Index,elMenu){
				var event = getEvent();
				var t;
				try{
				oc_CurrentMenu = elMenu;
				oc_CurrentIndex = Index;
				
				//on error resume next
				elMenu.style.visibility="hidden";
				//on error goto 0
				
				var elFrom = event.srcElement ? event.srcElement : event.target;
				elFrom = jQuery(elFrom).parent().parent().children()[0];

				if (elFrom.tagName == "TR" || elFrom.tagName == "TD" || elFrom.tagName == "SPAN") {
					jQuery(elMenu).find("td[id=t]").text(jQuery(elFrom).text());
				}
				
				xy = getXY(event);
				t = xy.Y - 2;
				l = xy.X - 10;
				h = elMenu.clientHeight;
				w = elMenu.clientWidth;

				if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth))  l = l - (w-20)
				if ((t + h) > (document.body.scrollTop + document.body.offsetHeight))  t = t - (h+2)

				elMenu.style.left = l;
				elMenu.style.top = t;
				elMenu.style.visibility = "visible";
				}catch(e){
					
				}
			}

			function oc_CurrentMenuOnMouseOut(){
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "A")   el = jQuery(el).parent();
				if (el.tagName == "IMG")   el = jQuery(el).parent();
				if (el.tagName == "TD" && jQuery(el).attr("class") != "MenuPopupSelected" && jQuery(el).attr("class") != "NoHand")  el.className = "MenuPopup";
				
			}

			function oc_CurrentMenuOnMouseOver(){
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "A")  el = jQuery(el).parent();
				if (el.tagName == "IMG")  el = jQuery(el).parent();
				if (el.tagName == "TD" && jQuery(el).attr("class") != "MenuPopupSelected" && jQuery(el).attr("class") != "NoHand")  el.className = "MenuPopupFocus";
				
			}

			function document_onmouseover(){
				//on error resume next
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "BODY"){
					oc_CurrentMenu.style.visibility = "hidden";
				}
			}

			function document_onmouseup(){
				//on error resume next
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "BODY"){
					oc_CurrentMenu.style.visibility = "hidden";
				}
			}

			function oc_getAllDivisions(isQuoted){
				oc_getAllDivisions = null;
				for(var i = 1;i<oc_getAllDivisions.length;i++){
					d = oc_DivisionList[i];
					if(isQuoted){
						d = "'" + d + "'";
						return oc_getAllDivisions + "," + d;
					}
				}
			}


			function oc_CurrentMenuOnClick(){
					var event = getEvent();
					var el = event.srcElement ? event.srcElement : event.target;
					if (el.tagName == "A")   el = jQuery(el).parent();
					var r;
					switch(jQuery(el).parent()[0].id){
					
						case "D1":
							r="/hrm/company/HrmDepartmentDsp.jsp?id=" + oc_DivisionList[oc_CurrentIndex];
						case "D2":
							r="/hrm/company/HrmCostcenterChart.jsp?id=" + oc_DivisionList[oc_CurrentIndex];
						case "D3":
							r="/hrm/search/HrmResourceSearchTmp.jsp?from=hrmorg&department=" + oc_DivisionList[oc_CurrentIndex];
					}
					oc_CurrentMenu.style.visibility = "hidden";
					if (r != "" && r!=null){
						event.returnValue = false;
						window.location.href = r;
					}
			}
</SCRIPT>


				<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
				</TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
					 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
				
					 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%></TD></TR>
					 
					 <TR id=D3><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD></TR>
				
				</TABLE>
				</DIV>

			</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
<script language="javascript">
 function onSubmit(){ 	
	document.Baco.submit();
 }

  jQuery(document).ready(function(){
	jQuery("#wait").hide();

});
</script>
</HTML>
