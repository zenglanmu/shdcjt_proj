<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
 

<%
	if(!HrmUserVarify.checkUserRight("hporder:maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
    <BODY>
    <%
    String imagefilename = "/images/hdReport.gif";

	
    String titlename = SystemEnv.getHtmlLabelName(20071,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

    %>
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
        <table width=100%  height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        </colgroup>
            <tr>
                <td height="10" colspan="3"></td>
            </tr>  
             <tr>
                <td ></td>
                <td>
                    <TABLE class=Shadow width="100%">
                        <tr>
                            <td valign="top" width="100%">  
							    <%
								String msg = Util.null2String(request.getParameter("msg"));
								String code = Util.null2String(request.getParameter("code"));
								
								if("seterror".equals(msg)) out.println("<font color=#FF0000>œ‘ æÀ≥–Ú:&nbsp;"+code+"&nbsp;…Ë÷√¥ÌŒÛ!</font>");
								%>
								<form  name="frmAdd" method="post" action="HomepageLocationOperation.jsp">
									<input type="hidden"  name="method">
                                     <TABLE class="viewForm" width="100%">	
											<TR>    
												<TD width="10%" valign="top">
												 <%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%>
                                                </TD>
												<TD width="60%" valign="top">
												 <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
												</TD>

												<TD width="30%" valign="top">
												 <%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>
                                                </TD>
											</TR>
											<tr style="height:1px;"><td colspan=3 class=line1></td></tr>
											<%
												String strSql="select id,infoname,subcompanyid,ordernum from hpinfo where isuse='1' order by cast(ordernum as float),id";
												rs.executeSql(strSql);
												String hpid="";
												String infoname="";
												String subcompanyid="";
												String ordernum="";
												int row=0;
												while (rs.next()){	
												   hpid=Util.null2String(rs.getString("id"));
												   infoname=Util.null2String(rs.getString("infoname"));
												   subcompanyid=Util.null2String(rs.getString("subcompanyid"));
												   ordernum=Util.null2String(rs.getString("ordernum"));
												   
												   boolean is2Level=false;
												   int piontLoc=ordernum.indexOf(".");
												   if(piontLoc!=-1){
													if(ordernum.length()-piontLoc>=3) is2Level=true;
												   }

												   String url="/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subcompanyid;
												   row++;
												
											%>
											<TR>    
												<TD  valign="top">
												<input type="hidden" class="inputstyle" value="<%=hpid%>" name="hpid">	
												 <%=row%>
                                                </TD>
												<TD valign="middle">
												 <%
													if(!is2Level) {
														out.println("<img src='/images/homepage/g.gif'>") ;
													} else {
														out.println("&nbsp;&nbsp;&nbsp;<img src='/images/homepage/n.gif'>") ;
													}
												 %>
												 <a href="javascript:openFullWindowForXtable('<%=url%>')"><%=infoname%></a>
												</TD>

												<TD  valign="top">
												<input type="text" class="inputstyle" value="<%=ordernum%>" name="orderNum" size=8 onkeypress="onlyNumber(event)" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="ime-mode:Disabled" maxlength=50>
                                                </TD>
											</TR>
											<tr  style="height:1px;"><td colspan=3 class=line></td></tr>
											<%}%>
									</TABLE> 
									</form>
								</TD>
							</TR>                                    
						</TABLE> 
					 </td>
					 <td></td>
				 </tr>
			</TABLE>

    </BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit(obj){
	obj.disabled = true ;
    frmAdd.method.value="edit";
	frmAdd.submit();
}

function onlyNumber(e)
{	
    if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))|| window.event.keyCode==46))
	{
		window.event.keyCode=0;
	}
}
//-->
</SCRIPT>




