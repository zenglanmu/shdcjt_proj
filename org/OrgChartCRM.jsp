<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.org.layout.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

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

String[] crmsta = request.getParameterValues("crmstatus");
String crmstatus="";
if(crmsta!=null){
	for(int i=0;i<crmsta.length;i++){
		crmstatus +=","+crmsta[i];
	}
}

String[] crmtypes = request.getParameterValues("crmtype");
String crmtype="";
if(crmtypes!=null){
	for(int i=0;i<crmtypes.length;i++){
		crmtype +=","+crmtypes[i];
	}
}

if(charttype.equals(""))
	charttype = "C";

int topMargin = 210;
int leftMargin = 20;
DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);
dl.buildObjectRef();
dl.checkAndAutoset(10, 10, 20, 20);

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
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
			<FORM action="OrgChartCRM.jsp" id=Baco name=Baco method=post>
			<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
			<TABLE width="100%" height="100%">
				<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%>...</TD></TR>
			</TABLE>
			</DIV>

			<TABLE class=ViewForm>
				<TR>
					<TD width=100><B><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></B></TD>
					<TD width=200>
				<SELECT name=charttype onchange="changetype()">
					<OPTION value=D <%if(charttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
					<OPTION value=H <%if(charttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
			<%if(software.equals("ALL") || software.equals("CRM")){%>
					<OPTION value=C <%if(charttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
					<OPTION value=R <%if(charttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
			<%}%>
			<%if(software.equals("ALL") || software.equals("HRM")){%>
					<OPTION value=P <%if(charttype.equals("P")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
			<%}%>
			<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){
					if( fnarightlevel.equals("2") ) { %>
					<OPTION value=F <%if(charttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
			<%      }
			}%>
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
				<TR style="height:2px"><TD class=Line2 colSpan=3></TD></TR> 
			</TABLE>

				<TABLE class=ViewForm>
				<TBODY >
				<COLGROUP>
				<COL width="50">
				<COL width="">
				<COL width="">
					<TR class=Title>
					 <TH colspan="3" ><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
					</TR>					
					<TR class=Spacing style="height:2px"><TD colspan="3" class=Line1></TD></TR>
					<TR>
					<TD ><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
					<td class=Field>
						<table>
						<tr>
						<%while(CustomerTypeComInfo.next()){
							String ischecked = "";
							String tmpid1 = CustomerTypeComInfo.getCustomerTypeid ();
							if(crmtype.indexOf(tmpid1)!=-1)
								ischecked = " checked";
						%>
						<td><INPUT TYPE=checkbox VALUE="<%=tmpid1%>" name="crmtype" <%=ischecked%>>
						<%=CustomerTypeComInfo.getCustomerTypename()%></td>
						<%}%>
						</tr>
						</table>
					</td>
					<td></td>
					</tr>
					<TR  style="height:2px"><TD class=Line2 colSpan=3></TD></TR> 
					<TR>
					<TD ><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
					<td class=Field>
						<table>
						<tr>
						<%while(CustomerStatusComInfo.next()){
							String ischecked = "";
							String tmpid1 = CustomerStatusComInfo.getCustomerStatusid();
							if(crmstatus.indexOf(tmpid1)!=-1)
								ischecked = " checked";
						%>
						<td><INPUT TYPE=checkbox VALUE="<%=tmpid1%>" name="crmstatus" <%=ischecked%>>
						<%=CustomerStatusComInfo.getCustomerStatusname()%></td>
						<%}%>
						</tr>
						</table>
					</td>
					<td></td>
					</tr>
					<TR style="height:2px"><TD class=Line2 colSpan=3></TD></TR> 
					</TBODY>
				</TABLE>
				
				
				<%
			String sql = "";
			if(user.getLogintype().equals("1")){
				sql = "select count(distinct t1.id) from CRM_CustomerInfo  t1, "+leftjointable+" t2 where t1.id = t2.relateditemid";
			}else{
				sql = "select count(t1.id) from CRM_CustomerInfo  t1  where t1.agent="+user.getUID() ;
			}

				int ishead = 1;
				String status="";
				if(crmsta!=null){
					for(int i=0;i<crmsta.length;i++){
						status +=" or t1.status ="+crmsta[i]+" ";
					}
				}
				if(!status.equals("")){
					status = status.substring(3);
					if(ishead==0){
						ishead = 1;
						sql += " where (";
						sql += status;
						sql += ")";
					}else{
						sql += " and (";
						sql += status;
						sql += ")";
					}
				}
				String type = "";
				if(crmtypes!=null){
					for(int i=0;i<crmtypes.length;i++){
						type +=" or t1.type ="+crmtypes[i]+" ";
					}
				}
				if(!type.equals("")){
					type = type.substring(3);
					if(ishead==0){
						ishead = 1;
						sql += " where (";
						sql += type;
						sql += ")";
					}else{
						sql += " and (";
						sql += type;
						sql += ")";
					}
				}
				
				
			//	out.print(sql);
				%>

			<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
			<img src = "<%if(needupdate==0){%>/org/org.jpg<%}else{%>/weaver/weaver.org.layout.ShowDepLayoutToPicServlet<%}%>" border=0>
			<%
			int curnum = 0;
			for (int i=0;i<dl.departments.size();i++) {
				Department depart = (Department)dl.departments.get(i);
				String tmpnum = "";
				String sqltmp = "";
				departids +=",\"";
				departids += depart.id;
				departids +="\"";
				curnum += 1;
				String tmpdepids = ",-1";
				
				if (depart.type == Department.TYPE_ZONGBU) {
					tmpnum = "";
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuTop)" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgComapnyBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=2 align="center" id=t><%=depart.name%></TD></TR>
					<TR height=14px><TD align=right width="75%" style="padding-bottom:6px;"><%=SystemEnv.getHtmlLabelName(2016,user.getLanguage())%></TD>
					<%
					RecordSet2.execute(sql);
					if(RecordSet2.next())
						tmpnum = RecordSet2.getString(1);
					%>
					<TD align="right" width="25%" style="padding-right:15px;padding-bottom:3px;"><%=tmpnum%></TD>
					</TR>
				</TABLE>		
			<%
				} else if (depart.type == Department.TYPE_FENBU) {
					tmpnum = "";
					int subcompanyid = depart.id;
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuGroup)" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgSubCompanyBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>;"><span><%=depart.name%></span></span></TD></TR>
					<TR height=14px>
					<%
					tmpdepids = ",-1";
					sqltmp=sql;
					RecordSet2.execute("select id from HrmDepartment where subcompanyid1="+subcompanyid+" or  subcompanyid1  in (select id from hrmsubcompany where supsubcomid="+subcompanyid+") ");
					while (RecordSet2.next()) {
						tmpdepids +=","+RecordSet2.getString("id");
					}
					tmpdepids=tmpdepids.substring(1);
					if (ishead==0) {
						sqltmp += " where t1.department in ("+tmpdepids +")";
					}else{
						sqltmp += " and t1.department in ("+tmpdepids +")";
					}	
					RecordSet2.execute(sqltmp);
					if (RecordSet2.next()) {
						tmpnum = RecordSet2.getString(1);
					}
					%>
					<TD align="right" width=100% style="padding-right:5px;padding-bottom:0px;"><%=tmpnum%></TD>		
					</TR>
				</TABLE>
			<%
				} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
			%>
				<TABLE onclick="oc_ShowMenu(<%=curnum%>,oc_divMenuDivision)" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=depart.y%>;LEFT:<%=depart.x%>;height:<%=depart.getWidthHeight().y%>;width:<%=depart.getWidthHeight().x%>;background-image:url('/org/OrgDepartmentBg.png');background-repeat:no-repeat;cursor:hand;">
					<TR height=28px><TD colspan=1 TITLE="<%=depart.name%>-<%=depart.departmentMark%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>;"><span><%=depart.name%>-<%=depart.departmentMark%></span></span></TD></TR>
					<TR height=14px>
					<%
					tmpnum="";
					sqltmp=sql;
					if(ishead==0){
						sqltmp += " where ( t1.department="+depart.id+")";
					}else{
						sqltmp += " and ( t1.department="+depart.id+")";
					}
					RecordSet2.execute(sqltmp);
					if(RecordSet2.next())
						tmpnum = RecordSet2.getString(1);
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
		return window.event;// Èç¹ûÊÇie
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
				
					 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD></TR>
				
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
