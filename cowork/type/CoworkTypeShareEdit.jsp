<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
		<script type="text/javascript" src="/cowork/js/cowork.js"></script>
	</HEAD>
<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String settype = Util.null2String(request.getParameter("settype"));
String cotypeid = Util.null2String(request.getParameter("cotypeid"));
	
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17718,user.getLanguage())+"：";
String headname = "";
if(settype.equals("manager")){
    titlename += SystemEnv.getHtmlLabelName(2097,user.getLanguage());
    headname = SystemEnv.getHtmlLabelName(2097,user.getLanguage());
}else if(settype.equals("members")){
    titlename +=SystemEnv.getHtmlLabelName(271,user.getLanguage());
    headname =SystemEnv.getHtmlLabelName(271,user.getLanguage());
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CoworkType.jsp,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
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
			<TABLE class="Shadow">
				<TR>
					<TD valign="top">
						<FORM name="frmmain" action="CoworkTypeShareOption.jsp">												
							<INPUT type="hidden" name="method" value="add">
							<INPUT type="hidden" name="delid">
							<INPUT type="hidden" name="cotypeid" value="<%=cotypeid%>">		
							<INPUT type="hidden" name="settype" value="<%=settype%>">
			 			<TABLE class="ViewForm">
							<COLGROUP>
								<COL width="20%">
								<COL width="80%">
							<TBODY>
							<TR class="Title">
								<TH colSpan="2"></TH>
					  		</TR>
					  		
							<TR class="Spacing" style="height: 1px;">
							  	<TD class="Line1" colSpan="2"></TD>
							</TR>
							
							<!--================== 类型选择 ==================-->
							<TR>					  
					  			<TD>
									<SELECT name=sharetype onchange="onChangeShareType()" class=InputStyle>
										<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
										<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
										<OPTION value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
										<OPTION value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
										<OPTION value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
									</SELECT>
					  			</TD>
					  			<TD class=field>
									<BUTTON type="button" class=Browser style="display:none" onclick="onShowResource('relatedshareid','showrelatedsharename')" name=showresource id="showresource"></BUTTON> 
									<BUTTON type="button" class=Browser style="display:none" onclick="onShowSubcompany('relatedshareid','showrelatedsharename')" name=showSubCompany id="showSubCompany"></BUTTON>
									<BUTTON type="button" class=Browser  onclick="onShowDepartment('relatedshareid','showrelatedsharename')" name=showdepartment id="showdepartment"></BUTTON> 
									<BUTTON type="button" class=Browser style="display:none" onclick="onShowRole('relatedshareid','showrelatedsharename')" name=showrole id="showrole"></BUTTON>
									<INPUT type=hidden name=relatedshareid id="relatedshareid" value="">
			 						<SPAN id=showrelatedsharename name=showrelatedsharename ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
									<SPAN id=showrolelevel name=showrolelevel style="visibility:hidden">
										&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
										<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
										<SELECT name=rolelevel class=InputStyle>
											<OPTION value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
											<OPTION value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
											<OPTION value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
										</SELECT>
									</SPAN>
									&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
									<SPAN id=showseclevel name=showseclevel>
										<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
										<INPUT class=InputStyle maxLength=3 size=5 name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
									</SPAN>
									<SPAN id=seclevelimage></SPAN>
					  			</TD>		
							</TR>		
							
							<TR style="height: 1px;">
								<TD class=Line colSpan=2></TD>
							</TR>
							</TBODY>
					  	</TABLE>
						</FORM>

						<BR>
						
						<!--================== 列表 ==================-->
						<TABLE class="ViewForm">
							<COLGROUP> 
								<COL width="30%"> 
								<COL width="60%"> 
								<COL width="10%"> 
							<TBODY> 
							<TR class=Title> 
								<TH><%=headname%></TH>
								<TD align="right" colspan="2">&nbsp;</TD>
							</TR>
							<TR class="Spacing" style="height: 1px;"> 
								<TD class="Line1" colspan="3"></TD>
						 	</TR>
							<%
								String sql = "";
								if(settype.equals("manager")) sql = "select * from cotype_sharemanager where cotypeid="+cotypeid+" order by sharetype";
								else if(settype.equals("members")) sql = "select * from cotype_sharemembers where cotypeid="+cotypeid+" order by sharetype";
								rs.executeSql(sql);
								while (rs.next()) 
								{
						   			String typeid = rs.getString("id");
						   			String sharetype = Util.null2String(rs.getString("sharetype"));
						   			String sharevalue = Util.null2String(rs.getString("sharevalue"));
						   			if(sharevalue.equals("")) continue;
						   			String seclevel = Util.null2String(rs.getString("seclevel"));
						   			String rolelevel = Util.null2String(rs.getString("rolelevel"));
						   			if (sharetype.equals("1"))
						   			//人力资源
						   			{
							%>
							<TR> 
						  		<TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
								<TD class="Field">
								<%
										List shareUserIdList = Util.TokenizerString(sharevalue, ",");
										for(int i = 0; i < shareUserIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(resourceComInfo.getResourcename((String)shareUserIdList.get(i)),user.getLanguage()));
										}
								%>
								</TD>
								<TD class="Field">
									<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>
								</TD>
							</TR>
							
							<TR style="height: 1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
								<%
									} 
						   			else if (sharetype.equals("2"))
						   			//部门
						   			{
						   		%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										List shareDepartmentIdList = Util.TokenizerString(sharevalue, ",");
										for(int i = 0; i < shareDepartmentIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(departmentComInfo.getDepartmentname((String)shareDepartmentIdList.get(i)),user.getLanguage()));
										}
										out.print("/");
										out.print(SystemEnv.getHtmlLabelName(683,user.getLanguage()));
										out.print(":");
										out.print(seclevel);
									%>
								</TD>
								<TD class="Field"> 
									<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
								</TD>
							</TR>
							<TR style="height: 1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							<%
									}
						   			else if (sharetype.equals("4"))
						   			//角色
						   			{
						   	%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										out.print(Util.toScreen(rolesComInfo.getRolesRemark(sharevalue), user.getLanguage()));
										out.print("/");

										if (rolelevel.equals("0")) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> 
									<%
										} 
										else if (rolelevel.equals("1")) 										
										{
									%>
										<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> 
									<%
										} 
										else if (rolelevel.equals("2")) 
										{
									%>					
										<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
									<%
										}
									%>
										/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=seclevel%>
								</TD>
								<TD class="Field"> 
									<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
								</TD>
							</TR>
							<TR style="height: 1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							
							<%
									} 
						   			else if (sharetype.equals("5"))
						   			//所有人
						   			{
						   	%>
							<TR> 
						  		<TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
								<TD class=Field> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=seclevel%></TD>
								<TD class="Field"> 
									<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
								</TD>
							</TR>
							<TR style="height: 1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							<%
									}
						   			else if (sharetype.equals("3"))
						   			//分部
						   			{
						   		%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										List shareSubCompanyIdList = Util.TokenizerString(sharevalue, ",");
										for(int i = 0; i < shareSubCompanyIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(subCompanyComInfo.getSubCompanyname((String)shareSubCompanyIdList.get(i)),user.getLanguage()));
										}
									
										out.print("/");
										out.print(SystemEnv.getHtmlLabelName(683,user.getLanguage()));
										out.print(":");
										out.print(seclevel);
									%>
								</TD>
								<TD class="Field"> 
									<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
								</TD>
							</TR>
							<TR style="height: 1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							<%
									}
								}
							%>
					  		</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>

<SCRIPT language="JavaScript">
function onChangeShareType() {
	thisValue=document.frmmain.sharetype.value
	document.frmmain.relatedshareid.value=""
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	if(thisValue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if(document.all("seclevel").value==""){
			document.all("seclevel").value=10;
		}
		//End TD33012		
	}
	else{
		document.all("showresource").style.display='none';
	}
	if(thisValue==2){
 		document.all("showdepartment").style.display='';
	}
	else{
		document.all("showdepartment").style.display='none';
	}
	if(thisValue==4){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
    }
	if(thisValue==5){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value="-1"
	}
	
	if(3 == thisValue)
	{
 		document.all("showSubCompany").style.display='';
		document.all("showSubCompany").style.visibility='visible';
	}
	else
	{
		document.all("showSubCompany").style.display='none';
		document.all("showSubCompany").style.visibility='hidden';
    }
	//TD33012 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if(document.all("seclevel").value==""&&thisvalue!=1){
		seclevelimage.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	}
	//End TD33012
}

function doSubmit(obj) 
{
    if (check_form(frmmain,"itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel"))
    {
    	obj.disabled = true;
	    document.frmmain.submit();
	}
}

function goBack() {
	document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	document.frmmain.submit();
}

function doDelete(recId) {
	if (isdel()) {
		document.all("delid").value = recId;
		document.frmmain.method.value = "delete";
		document.frmmain.submit();
	}

}
</SCRIPT>
</BODY>
</HTML>