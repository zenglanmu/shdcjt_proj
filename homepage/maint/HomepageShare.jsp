<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
<%
    int hpid = Util.getIntValue(request.getParameter("hpid"),0); 	
    String  hpname = hpc.getInfoname(""+hpid);
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
    <BODY>
    <%
    String imagefilename = "/images/hdReport.gif";

	
    String titlename = SystemEnv.getHtmlLabelName(19911,user.getLanguage())+": "+ hpname ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:doAdd(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(18646,user.getLanguage())+",javascript:doDel(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
    %>
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
        <table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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
								<form  name="frmAdd" method="post" action="HomepageShareOperation.jsp">
									<input type="hidden"  name="method">
                                    <input type="hidden"  name="hpid" value="<%=hpid%>">

                                     <TABLE class="viewForm" width="100%">
											<TR>  											   
												<TD><B><%=SystemEnv.getHtmlLabelName(19910,user.getLanguage())%>:</B></TD>                 
											</TR>
											 <TR style="height:1px;"> <TD class="line1"></TD></TR>
											<TR>    
												<TD>                                                    

												  <DIV ID="divShareSetting">                                                
													<!--与创建人无关的默认共享-->
													<TABLE CLASS=VIEWFORM CELLSPACING="1" >
													<COLGROUP> 
													<COL WIDTH="20%">                               
													<COL WIDTH="40%">
													<COL WIDTH="22%">
													<COL WIDTH="18%">
														<%
														 String strSql="select id,type,content from shareinnerhp where hpid="+hpid;
														 rs.executeSql(strSql);
														 while(rs.next()){		
															 String shareid=Util.null2String(rs.getString("id"));
															 String sharetype=Util.null2String(rs.getString("type"));
															 String sharecontent=Util.null2String(rs.getString("content"));
															 String shareStr="";
															  if(sharetype.equals("1")) {
																	shareStr+=rc.getResourcename(sharecontent);
																} else if(sharetype.equals("2")) {
																	 shareStr+=scc.getSubCompanyname(sharecontent);
																}  else if(sharetype.equals("3")) {
																	 shareStr+=dci.getDepartmentname(sharecontent);
																} else if(sharetype.equals("5")) { 		
																	shareStr+=SystemEnv.getHtmlLabelName(1340,user.getLanguage());
																}
														%>
															<TR>
																<TD width="10px"><input type=checkbox class=inputstyle value="<%=shareid%>" name="chkShareId"></TD>
																<TD  width="*"><%=shareStr%></TD>
															</TR>
															<TR style="height:1px;"><TD CLASS=LINE COLSPAN=4></TD></TR>
														<%}%>
														 
													</TABLE>                              
												 </DIV>
											 
                                                </TD>
                                                </TR>
                                            </TABLE> 
											</form>
                                        </TD>
                                    </TR>                                    
                                </TABLE> 
                             </td>
                         </tr>
                    </TABLE>

    </BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit(obj){
    obj.disabled = true ;
    
    window.parent.parent.returnValue="1";
    window.parent.parent.close();
}
function doAdd(obj){ 
    obj.disabled = true ; 
	window.location="HomepageShareAddBrowser.jsp?hpid=<%=hpid%>";  
}
function doDel(obj){ 
	if(jQuery("input:checkbox[checked]").length>0){
    obj.disabled = true ; 
	$G("method").value="delMShare";
	$G("frmAdd").submit();   
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>")
	}
}
//-->
</SCRIPT>


