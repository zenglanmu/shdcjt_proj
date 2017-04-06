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
	</HEAD>
<%
	int msgID = Util.getIntValue(request.getParameter("msgid"), 0);
	String planID = Util.null2String(request.getParameter("planID"));
	
	if (planID.equals(""))
	{
		return;
	}

	String[] creater = workPlanHandler.getCreater(planID);
	
	String createrID = "";
	if (creater != null)
	{
		createrID = creater[0];
	}

	String userID = String.valueOf(user.getUID());
			
	boolean canEdit = false;
	
	if (createrID.equals(userID))
	{
	    canEdit = true;
	}
%>

<%	
	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+":&nbsp;"
					 + SystemEnv.getHtmlLabelName(16652,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<% 
	if (canEdit) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
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
						<DIV>
						<%
							if (msgID == -1) 
							{
						%>
							<FONT color="red" size="2">
								<%=SystemEnv.getErrorMsgName(35,user.getLanguage())%>
							</FONT>
						<%
							}
						%>
						</DIV>
						
						<FORM name="frmmain" action="WorkPlanShareHandler.jsp">												
							<INPUT type="hidden" name="method" value="add">
							<INPUT type="hidden" name="planID" value="<%=planID%>">
							<INPUT type="hidden" name="workid" value="<%=planID%>">
							<INPUT type="hidden" name="delid">
			 			<TABLE class="ViewForm">
							<COLGROUP>
								<COL width="20%">
								<COL width="80%">
							<TBODY>
							<TR class="Title">
								<TH colSpan="2"></TH>
					  		</TR>
					  		
							<TR class="Spacing" style="heigth:1px;">
							  	<TD class="Line1" colSpan="2"></TD>
							</TR>
							
							<!--================== 共享类型选择 ==================-->
							<TR>					  
					  			<TD>
									<SELECT name=sharetype onchange="onChangeShareType()" class=InputStyle>
										<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
										<OPTION value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
										<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
										<OPTION value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
										<OPTION value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
									</SELECT>
					  			</TD>
					  			<TD class=field>
									<button type="button" class=Browser style="display:none" onclick="onShowMultiHumanResource('relatedshareid','showrelatedsharename')" name=showresource></BUTTON> 
									<button type="button" class=Browser style="display:none" onclick="onShowMultiSubcompany('relatedshareid','showrelatedsharename')" name=showSubCompany></BUTTON>
									<button type="button" class=Browser style="display:''" onclick="onShowMultiDepartment('relatedshareid','showrelatedsharename')" name=showdepartment></BUTTON> 
									<button type="button" class=Browser style="display:none" onclick="onShowSingleRole('relatedshareid','showrelatedsharename')" name=showrole></BUTTON>
									<INPUT type=hidden name=relatedshareid value="">
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
							<TR style="height:1px;">
								<TD class=Line colSpan=2></TD>
							</TR>
					
							<!--================== 共享级别 ==================-->
							<TR>
					  			<TD >
									<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
					  			</TD>
					  			<TD class=field>
									<SELECT name=sharelevel class=InputStyle>
										<OPTION value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>									  
										<OPTION value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>						
									</SELECT>
					  			</TD>		
							</TR>
							
							<TR style="height:1px;">
								<TD class=Line colSpan=2></TD>
							</TR>
							</TBODY>
					  	</TABLE>
						</FORM>

						<BR>
						
						<!--================== 共享列表 ==================-->
						<TABLE class="ViewForm">
							<COLGROUP> 
								<COL width="30%"> 
								<COL width="60%"> 
								<COL width="10%"> 
							<TBODY> 
							<TR class=Title> 
								<TH><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></TH>
								<TD align="right" colspan="2">&nbsp;</TD>
							</TR>
							<TR class="Spacing" style="height:1px;"> 
								<TD class="Line1" colspan="3"></TD>
						 	</TR>
							<%
								String recId = "";		
								rs.executeSql("SELECT * FROM WorkPlanShare WHERE isdefault is null and workPlanID = " + planID);
								while (rs.next()) 
								{
						   			if (rs.getInt("shareType") == 1)
						   			//人力资源
						   			{
							%>
							<TR> 
						  		<TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
								<TD class="Field">
								<%
										String shareUserId = rs.getString("userID");
										List shareUserIdList = Util.TokenizerString(shareUserId, ",");
										for(int i = 0; i < shareUserIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(resourceComInfo.getResourcename((String)shareUserIdList.get(i)),user.getLanguage()));
										}
										out.print("/");

										if (rs.getInt("shareLevel") == 1) 
										{
								%>
											<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<%
										}
								%>
								<% 
										if (rs.getInt("shareLevel") == 2) 
										{
								%>
											<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
								<%
										}
								%>
								</TD>
								<TD class="Field"> 
								<%
										if (canEdit) 
										{
								%>
											<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>
								<%
										}
								%>
						  		</TD>
							</TR>
							
							<TR style="height:1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
								<%
									} 
						   			else if (rs.getInt("shareType") == 2)
						   			//部门
						   			{
						   		%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										String shareDepartmentId = rs.getString("deptId");
										List shareDepartmentIdList = Util.TokenizerString(shareDepartmentId, ",");
										for(int i = 0; i < shareDepartmentIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(departmentComInfo.getDepartmentname((String)shareDepartmentIdList.get(i)),user.getLanguage()));
										}
										out.print("/");
										out.print(SystemEnv.getHtmlLabelName(683,user.getLanguage()));
										out.print(":");
										out.print(Util.toScreen(rs.getString("securityLevel"),user.getLanguage()));
										out.print("/");

										if (rs.getInt("shareLevel") == 1) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
									<%
										}
									%>
									<% 
										if (rs.getInt("shareLevel") == 2) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
									<%
										}
									%>
								</TD>
								<TD class="Field"> 
									<%
										if (canEdit) 
										{
									%>
										<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
									<%
										}
									%>
						  		</TD>
							</TR>
							<TR style="height:1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							<%
									}
						   			else if (rs.getInt("shareType") == 3)
						   			//角色
						   			{
						   	%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										String shareRoleId = rs.getString("roleId");
										out.print(Util.toScreen(rolesComInfo.getRolesname(shareRoleId), user.getLanguage()));
										out.print("/");

										if (rs.getInt("roleLevel") == 0) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> 
									<%
										} 
										else if (rs.getInt("roleLevel") == 1) 										
										{
									%>
										<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> 
									<%
										} 
										else if (rs.getInt("roleLevel") == 2) 
										{
									%>					
										<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
									<%
										}
									%>
										/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(rs.getString("securityLevel"),user.getLanguage())%>/
									<% 
										if (rs.getInt("shareLevel") == 1) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
									<%
										}
									%>
									<% 
										if (rs.getInt("shareLevel") == 2) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%> 
									<%
										}
									%>
								</TD>
								<TD class="Field"> 
									<%
										if (canEdit) 
										{
									%>
										<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
									<%
										}
									%>
						  		</TD>
							</TR>
							<TR style="height:1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							
							<%
									} 
						   			else if (rs.getInt("shareType") == 4)
						   			//所有人
						   			{
						   	%>
							<TR> 
						  		<TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
								<TD class=Field> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(rs.getString("securityLevel"),user.getLanguage())%>/
							<% 
										if (rs.getInt("shareLevel") == 1) 
										{
							%>
										<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
							<%
										}
							%>
							<% 
										if (rs.getInt("shareLevel") == 2) 
										{
							%>
										<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							<%
										}
							%>
								</TD>
								<TD class="Field"> 
							<%
										if (canEdit) 
										{
							%>
										<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
							<%
										}
							%>
						  		</TD>
							</TR>
							<TR style="height:1px;">
								<TD class="Line" colSpan="3"></TD>
							</TR>
							<%
									}
						   			else if (rs.getInt("shareType") == 5)
						   			//分部
						   			{
						   		%>
							<TR> 
						    	<TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
								<TD class="Field">
									<%
										String shareSubCompanyId = rs.getString("subCompanyId");
										List shareSubCompanyIdList = Util.TokenizerString(shareSubCompanyId, ",");
										for(int i = 0; i < shareSubCompanyIdList.size(); i++)
										{
										    out.print(" ");
										    out.print(Util.toScreen(subCompanyComInfo.getSubCompanyname((String)shareSubCompanyIdList.get(i)),user.getLanguage()));
										}
									
										out.print("/");
										out.print(SystemEnv.getHtmlLabelName(683,user.getLanguage()));
										out.print(":");
										out.print(Util.toScreen(rs.getString("securityLevel"),user.getLanguage()));
										out.print("/");
									
										if (rs.getInt("shareLevel") == 1) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
									<%
										}
									%>
									<% 
										if (rs.getInt("shareLevel") == 2) 
										{
									%>
										<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
									<%
										}
									%>
								</TD>
								<TD class="Field"> 
									<%
										if (canEdit) 
										{
									%>
										<A href="#" onclick="doDelete(<%=rs.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A> 
									<%
										}
									%>
						  		</TD>
							</TR>
							<TR style="height:1px;">
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
	if(thisValue==3){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
    }
	if(thisValue==4){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value="-1"
	}
	
	if(5 == thisValue)
	{
 		document.all("showSubCompany").style.display='';
		document.all("showSubCompany").style.visibility='visible';
	}
	else
	{
		document.all("showSubCompany").style.display='none';
		document.all("showSubCompany").style.visibility='hidden';
    }
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
function onShowMultiHumanResource(inputname, spanname)
{
	 linkurl="javaScript:openhrm(";
	 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
</SCRIPT>

<SCRIPT language="VBS">
sub onShowMultiHumanResource(inputname, spanname)
	tmpids = document.all(inputname).value
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
    	if id(0)<> "" then
        	resourceids = id(0)
        	resourcename = id(1)
        	sHtml = ""
	        resourceids = Mid(resourceids,2,len(resourceids))
	        resourcename = Mid(resourcename,2,len(resourcename))
    	    document.all(inputname).value= ","&resourceids&","
        	while InStr(resourceids,",") <> 0
            	curid = Mid(resourceids,1,InStr(resourceids,",")-1)
	            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
    	        resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
        	    resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            	sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
	        wend
    	    sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        	document.all(spanname).innerHtml = sHtml
	    else    
    	    document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
        	document.all(inputname).value=""
	    end if
    end if
end sub

sub onShowMultiSubcompany(inputname, tdname)
	tmpids = document.all(inputname).value
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputname).value)
    if NOT isempty(id) then
        if id(0)<> "" then        
        	resourceids = id(0)
        	resourcename = id(1)
        	sHtml = ""
        	resourceids = Mid(resourceids,2,len(resourceids))
        	resourcename = Mid(resourcename,2,len(resourcename))
        	document.all(inputname).value = ","&resourceids&","
        	while InStr(resourceids,",") <> 0
	            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
	            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
    	        resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
        	    resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            	sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
	        wend
    	    sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        	document.all(tdname).innerHtml = sHtml
        else
	        document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	    document.all(inputname).value=""
        end if
    end if
end sub

sub onShowMultiDepartment(inputname, spanname)
	tmpids = document.all(inputname).value
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&document.all(inputname).value)
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        document.all(inputname).value= ","&resourceids&","
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        document.all(spanname).innerHtml = sHtml
    else    
        document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
        document.all(inputname).value=""
    end if
    end if
end sub

sub onShowSingleRole(inputename,tdname)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
    if NOT isempty(id) then
    	if id(0)<> "" then
        	document.all(tdname).innerHtml = id(1)
        	document.all(inputename).value=id(0)
        else
        	document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
        	document.all(inputename).value=""
        end if
    end if
end sub

</SCRIPT>
</BODY>
</HTML>