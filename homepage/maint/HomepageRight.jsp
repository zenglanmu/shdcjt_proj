<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>


<% 	
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	ArrayList shareList = hpu.getShareMaintListByUser(user.getUID()+"");
	if(shareList.size()!=0){
		response.sendRedirect("HomepageShareMaintList.jsp");
		 return;
	}else{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
}
	
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>




<BODY>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23018,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
//得到分部ID
boolean isDetachable=hpu.isDetachable(request);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);

String message = Util.null2String(request.getParameter("message"));
//System.out.println("subCompanyId: "+subCompanyId);
//页标题
int operatelevel=0;

if(isDetachable){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
}else{
    if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
}

//System.out.println("operatelevel: "+operatelevel);
//System.out.println("subCompanyId: "+subCompanyId);
boolean canEdit=false;
if(operatelevel>0&&subCompanyId!=0) canEdit=true;
if(canEdit){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(18633,user.getLanguage())+",javascript:clearAppoint(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:onNew(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0">
<colgroup>
<col width="">
<col width="5">
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	  <tr>
		<td valign="top">
		<form name="frmAdd" method="post" action="HomepageMaintOperate.jsp?subCompanyId=<%=subCompanyId%>">
		  <input name="method" type="hidden">
		  <TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30" style="display:none"></TEXTAREA>
		  <TABLE class=Shadow width=100%>
			<tr>
			  <td valign="top">
					 <!--列表部分-->
				  <%
						//得到pageNum 与 perpage
						int pagenum = Util.getIntValue(request.getParameter("pagenum"),1) ;
						int perpage =10;
						//设置好搜索条件
						String 	sqlWhere="";
						if ("sqlserver".equals(rs.getDBType())){
							if (user.getUID()==1){  //sysadmin
								sqlWhere = " where  (creatortype=4  or creatortype=3 and creatorid="+subCompanyId+"  ) and subcompanyid!=-1 and  infoname != ''";
							} else {
								sqlWhere = " where   (creatortype=3 and creatorid="+subCompanyId+"  ) and subcompanyid!=-1 and  infoname != ''";
							}
						} else {
							if (user.getUID()==1){  //sysadmin
								sqlWhere = " where  (creatortype=4  or creatortype=3 and creatorid="+subCompanyId+"  ) and subcompanyid!=-1 and  infoname is not null";
							} else {
								sqlWhere = " where   (creatortype=3 and creatorid="+subCompanyId+"  )  and subcompanyid!=-1 and  infoname is not null";
							}
						}

						String tableString=""+
								 "<table  pagesize=\""+perpage+"\" tabletype=\"none\" valign=\"top\">"+
							   "<sql backfields=\"id,infoname,infodesc,styleid,layoutid,subcompanyid,isuse,islocked,menustyleid\" sqlform=\" from hpinfo \"  sqlorderby=\"subcompanyid\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
							   "<head >"+
									 "<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"   column=\"infoname\" orderkey=\"infoname\" />"+
									 "<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22916,user.getLanguage())+"\" column=\"menustyleid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getMenuStyleName\" orderkey=\"menustyleid\"/>"+
									 "<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22913,user.getLanguage())+"\" column=\"styleid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getStyleName\" orderkey=\"styleid\"/>"+
									 "<col width=\"11%\"    text=\""+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+"\" column=\"layoutid\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getLayoutName\"  orderkey=\"layoutid\"/>"+
									 "<col width=\"12%\"    text=\""+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+"\"   column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getMaintanceStr\"  otherpara=\""+user.getLanguage()+"_"+canEdit+"\" />"+
									 "<col width=\"12%\"    text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\"   column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getShareStr\"  otherpara=\""+user.getLanguage()+"_"+canEdit+"\" />"+									  
								  	 "<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" column=\"isUse\" orderkey=\"isUse\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsUseStr\" otherpara=\"column:id\"/>"+
									 "<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(16213,user.getLanguage())+"\" column=\"islocked\" orderkey=\"islocked\" transmethod=\"weaver.splitepage.transform.SptmForHomepage.getIsLockedStr\" otherpara=\"column:id\"/>"+
							   "</head>"+
							   "<operates width=\"20%\" >";
                       if(operatelevel>0&&subCompanyId!=-1){
                            tableString+=
                                " <popedom transmethod=\"weaver.splitepage.operate.SpopForHomepage.getModiDefaultPope\"    otherpara=\""+user.getUID()+"\" otherpara2=\"column:subcompanyid\"></popedom>"+
								" <operate  href=\"javascript:doEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>"+
								" <operate  href=\"javascript:onTran2("+subCompanyId+")\" text=\""+SystemEnv.getHtmlLabelName(80,user.getLanguage())+"\" index=\"0\"/>"+
								" <operate  href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>"+
                                " <operate  href=\"javascript:doSetElement()\" text=\""+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+"\" index=\"3\"/>"+
                                " <operate  href=\"javascript:doPrivew()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" index=\"2\"/>";
                       }   else {
                            tableString+=
								"  <operate  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" />"+
								"  <operate   text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" />"+
                                "  <operate  text=\""+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+"\" />"+
                                "  <operate   text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\"/>";
                       }

                            tableString+=  "</operates></table>";
                      %>

					<%

					   String 	sqlWhere2="";
						if ("sqlserver".equals(rs.getDBType())){
							sqlWhere2=" and subcompanyid!=-1 and h1.infoname != ''";
						} else {
							sqlWhere2=" and subcompanyid!=-1 and h1.infoname is not null";
						}

					  if(subCompanyId==0 && user.getUID()==1&&isDetachable||subCompanyId==0&&!isDetachable){//表总部 显示所有被删除掉分部的首页
							//sqlWhere=" where subcompanyid="+subCompanyId;
							out.println("&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(21162,user.getLanguage()));
							
							tableString="<table  pagesize=\""+perpage+"\" tabletype=\"none\" valign=\"top\">"+
							"<sql backfields=\"h1.id,h1.infoname,h1.infodesc,h1.styleid,h1.layoutid,h1.subcompanyid,h1.isuse,h1.islocked\" sqlform=\" from hpinfo h1 left join hrmsubcompany h2 on  h1.subcompanyid=h2.id \"  sqlorderby=\"h1.subcompanyid\"  sqlprimarykey=\"h1.id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage("where h2.id is null "+sqlWhere2)+"\" sqldistinct=\"true\" />"+
							"<head >"+
									 "<col width=\"60%\"   text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"   column=\"infoname\" orderkey=\"infoname\" />"+
									"<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"\"   column=\"id\"  transmethod=\"weaver.splitepage.transform.SptmForHomepage.getCompanyOper\" otherpara=\"column:subcompanyid+"+user.getLanguage()+"\"/>"+
							   "</head></table>";
						}
						%>
					<TABLE width="100%">
						<TR>
							<TD valign="top">
								<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"   />
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
    if("<%=message%>"=="noDel")  alert('<%=SystemEnv.getHtmlLabelName(19660,user.getLanguage())%>');
	function clearAppoint(){
		var rdoObjs = document.getElementsByName("rdiInfoAppoint");
		for(var i=0;i<rdoObjs.length;i++) {
			var rdoObj = rdoObjs[i];
			rdoObj.checked = false ;
		}
    }

	function onNew(){
		window.location="HomepageTempletSele.jsp?subCompanyId=<%=subCompanyId%>";
	}


	function onSave(){
		//得到所设置的结果    hpid_isuse_ischecked||hpid_isuse_ischecked||...
		var chkUses=document.getElementsByName("chkUse");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++) {
			var tmepChkUse=chkUses[i];
			var hpid=jQuery(tmepChkUse).attr("hpid");
			
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

	function doPrivew(hpid){
		window.open("/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId=<%=subCompanyId%>&opt=privew","") ;
    }

	function doEdit(hpid){
		window.location="/homepage/base/HomepageBase.jsp?subCompanyId=<%=subCompanyId%>&opt=edit&hpid="+hpid;
    }

	function doDel(hpid){
		 if (isdel()){
			window.location="/homepage/maint/HomepageMaintOperate.jsp?method=delhp&subCompanyId=<%=subCompanyId%>&hpid="+hpid;
		 }
	}
	function doSubOperDel(hpid,subid){
		 if (isdel()){
			window.location="/homepage/maint/HomepageMaintOperate.jsp?method=suboperdelhp&subCompanyId="+subid+"&hpid="+hpid
		 }
	}


    function doSetElement(hpid){
       window.location="/homepage/Homepage.jsp?isSetting=true&hpid="+hpid+"&subCompanyId=<%=subCompanyId%>&from=setElement";
    }
    function doShare(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageShare.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	function doMaint(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageMaint.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	function doLocation(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageLocation.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	
	function onUse(obj){
		if(!obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkLocked_"+tempid).checked=false;			
		}

	}

	function onLock(obj){
		if(obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkUse_"+tempid).checked=true;			
		}
	}	
	function onTran2(subid,hpid){
	 	onTran(hpid,subid);
	}

	function onTran(hpid,subid){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?subid=<%=subCompanyId%>")
		
		if (datas){
			if(datas.id){
				targetSubid=datas.id;
				url="/homepage/maint/HomepageMaintOperate.jsp?method=tran&srcSubid="+subid+"&tranHpid="+hpid+"&targetSubid="+targetSubid+"&fromSubid=<%=subCompanyId%>&subCompanyId=<%=subCompanyId%>"
				window.location.replace(url);
			}
		}
	}

//-->
</SCRIPT>
