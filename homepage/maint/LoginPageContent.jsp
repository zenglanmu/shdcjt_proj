<%@ page language="java" contentType="text/html; charset=GBK"%>
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />

<%@ include file="/systeminfo/init.jsp"%>
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	</head>
	<BODY>
		<%
			String imagefilename = "/images/hdMaintenance.gif";
			String titlename = SystemEnv.getHtmlLabelName(23017, user.getLanguage());
			String needfav = "1";
			String needhelp = "";
		%>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			//得到分部ID
			
			String message = Util.null2String(request.getParameter("message"));
			//页标题
			int operatelevel = 0;

			
			if (HrmUserVarify.checkUserRight("homepage:Maint", user))
				operatelevel = 2;
			boolean canEdit = false;
			if (operatelevel > 0)
				canEdit = true;
			if (canEdit)
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage())
						+ ",javascript:onNew(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())+",javascript:onSave(),_self} " ;
				//RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>

		<TABLE width=100% height=100% border="0" cellspacing="0">
			<colgroup>
				<col width="">
				<col width="5">
			<tr>
				<td height="10" colspan="2"></td>
			</tr>
			<tr>
				<td valign="top">
					<form name="frmAdd" method="post"
						action="LoginMaintOperate.jsp">
						<input name="method" type="hidden">
						<TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30"
							style="display: none"></TEXTAREA>
						<TABLE class=Shadow width=100%>
							<tr>
								<td valign="top">
									<!--列表部分-->
									<%
										//得到pageNum 与 perpage
										int perpage = 500;
										//设置好搜索条件

										String sqlWhere = "";
										if ("sqlserver".equals(rs.getDBType()))
										{
											sqlWhere = " where creatortype=0 and subcompanyid=-1 and infoname != ''";
										}
										else
										{
											sqlWhere = " where creatortype=0 and subcompanyid=-1 and infoname is not null";
										}

										String tableString = "" + "<table  pagesize=\""+ perpage+ "\" tabletype=\"none\" valign=\"top\">"
																	+ "<sql backfields=\"id,infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked\" sqlform=\" from hpinfo \"  sqlorderby=\"subcompanyid\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+ Util.toHtmlForSplitPage(sqlWhere)+ "\" sqldistinct=\"true\" />"
																	+ "<head >"
																		+ "<col width=\"40%\"   text=\""+ SystemEnv.getHtmlLabelName(195, user.getLanguage())+ "\"   column=\"infoname\" orderkey=\"infoname\" />"
																		+ "<col width=\"20%\"   text=\""+ SystemEnv.getHtmlLabelName(22913, user.getLanguage())+ "\" column=\"styleid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getStyleName\" orderkey=\"styleid\"/>"
																		+ "<col width=\"20%\"    text=\""+ SystemEnv.getHtmlLabelName(19407, user.getLanguage())+ "\" column=\"layoutid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getLayoutName\"  orderkey=\"layoutid\"/>"
																		//+ "<col width=\"12%\"    text=\""+ SystemEnv.getHtmlLabelName(19909, user.getLanguage())+ "\"   column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getMaintanceStr\"  otherpara=\""+ user.getLanguage()+ "_"+ canEdit+ "\" />"
																		//+ "<col width=\"15%\"    text=\""+ SystemEnv.getHtmlLabelName(19910, user.getLanguage())+ "\"   column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getShareStr\"  otherpara=\""+ user.getLanguage()+ "_"+ canEdit+ "\" />"
																		//+ "<col width=\"8%\"   text=\""+ SystemEnv.getHtmlLabelName(18095, user.getLanguage())+ "\" column=\"isUse\" orderkey=\"isUse\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsUseStr\" otherpara=\"column:id\"/>"
																		//+ "<col width=\"8%\"   text=\""+ SystemEnv.getHtmlLabelName(16213, user.getLanguage())+ "\" column=\"islocked\" orderkey=\"islocked\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsLockedStr\" otherpara=\"column:id\"/>"
																	+ "</head>" 
																	+ "<operates width=\"20%\" >";
										if (operatelevel > 0)
										{
											tableString += " <popedom transmethod=\"weaver.splitepage.operate.SpopForHomepage.getModiDefaultPope\"    otherpara=\""+ user.getUID() + "\" otherpara2=\"column:subcompanyid\"></popedom>" 
														 + " <operate  href=\"javascript:doEdit()\" text=\""+ SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\" index=\"0\"/>" 
														 + " <operate  href=\"javascript:doDel()\" text=\"" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\" index=\"1\"/>"
														 + " <operate  href=\"javascript:doSetElement()\" text=\"" + SystemEnv.getHtmlLabelName(19650, user.getLanguage())+ "\" index=\"3\"/>" 
														 + " <operate  href=\"javascript:doPrivew()\" text=\""+ SystemEnv.getHtmlLabelName(221, user.getLanguage()) + "\" index=\"2\"/>";
										}
										else
										{
											tableString += "  <operate  text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\" />" 
													+ "  <operate   text=\""+ SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\" />" 
													+ "  <operate  text=\""+ SystemEnv.getHtmlLabelName(19650, user.getLanguage()) + "\" />" 
													+ "  <operate   text=\""+ SystemEnv.getHtmlLabelName(221, user.getLanguage()) + "\"/>";
										}

										tableString += "</operates></table>";
									%>
									<TABLE width="100%">
										<TR>
											<TD valign="top">
												<wea:SplitPageTag tableString="<%=tableString%>" mode="run"
													isShowTopInfo="false" isShowBottomInfo="false" />
											</TD>
										</TR>
									</TABLE>
								</td>
							</tr>
						</TABLE>
					</form>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="2"></td>
			</tr>
		</table>
	</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
    if("<%=message%>"=="noDel")  alert('<%=SystemEnv.getHtmlLabelName(19660, user.getLanguage())%>');
	function clearAppoint(){
		var rdoObjs = document.getElementsByName("rdiInfoAppoint");
		for(var i=0;i<rdoObjs.length;i++) {
			var rdoObj = rdoObjs[i];
			rdoObj.checked = false ;
		}
    }

	function onNew(){
		window.location="LoginTempletSele.jsp";
	}

	function doPrivew(hpid){
		window.open("/homepage/LoginHomepage.jsp?hpid="+hpid+"&opt=privew","") ;
    }

	function doEdit(hpid){
		window.location="/homepage/base/LoginBase.jsp?opt=edit&hpid="+hpid;
    }

	function doDel(hpid){
		 if (isdel()){
			window.location="/homepage/maint/LoginMaintOperate.jsp?method=delhp&hpid="+hpid;
		 }
	}
    function doSetElement(hpid)
    {
       window.location="/homepage/Homepage.jsp?isSetting=true&hpid="+hpid+"&from=setElement&pagetype=loginview&opt=edit";
    }
    function onUse(obj)
    {
		if(!obj.checked)
		{
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkLocked_"+tempid).checked=false;			
		}

	}

	function onLock(obj)
	{
		if(obj.checked)
		{
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkUse_"+tempid).checked=true;			
		}
	}	
	function onSave(){
		//得到所设置的结果    hpid_isuse_ischecked||hpid_isuse_ischecked||...
		var chkUses=document.getElementsByName("chkUse");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++) 
		{
			var tmepChkUse=chkUses[i];
			var hpid=tmepChkUse.hpid;
			var tempIsLocked=document.getElementById("chkLocked_"+hpid);

			var isuse=tmepChkUse.checked?1:0;
			var ischecked=tempIsLocked.checked?1:0;

			returnStr+=hpid+"_"+isuse+"_"+ischecked+"||"
		}		
		if (returnStr!="") returnStr=returnStr.substr(0,returnStr.length-2);
		//alert(returnStr)
		frmAdd.areaResult.value=returnStr;

		frmAdd.method.value="save";
		frmAdd.submit()
	}
//-->
</SCRIPT>
<SCRIPT LANGUAGE="VBSCRIPT">
	sub onTran2(subid,hpid)
		 onTran hpid,subid
	end sub
	
	sub onTran(hpid,subid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				'msgbox(id(0)+"_"+id(1))
				targetSubid=id(0)
				url="/homepage/maint/HomepageMaintOperate.jsp?method=tran&srcSubid="&subid&"&tranHpid="&hpid&"&targetSubid="&targetSubid
				window.location.replace(url)		
			end if
		end if
	end sub
</SCRIPT>