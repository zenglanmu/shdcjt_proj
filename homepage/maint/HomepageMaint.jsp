<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
<%
    String hpid = Util.null2String(request.getParameter("hpid")); 	
    String  hpname = hpc.getInfoname(hpid);
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
    <BODY>
    <%
    String imagefilename = "/images/hdReport.gif";

	
    String titlename = SystemEnv.getHtmlLabelName(19909,user.getLanguage())+": "+ hpname ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+",javascript:doAdd(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+",javascript:doDel(this),_top} " ;
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
								<form  name="frmAdd" method="post" action="HomepageMaintOperate.jsp">
									<input type="hidden"  name="method">
                                    <input type="hidden"  name="hpid" value="<%=hpid%>">

                                     <TABLE class="viewForm" width="100%">
											<TR>  											   
												<TD><B><%=SystemEnv.getHtmlLabelName(19909,user.getLanguage())%>:</B></TD>                 
											<TR>
											 <TR style="height:1px;"> <TD class="line1"></TD><TR>
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
														String maintainer = hpc.getMaintainer(hpid);
														String[] idList = Util.TokenizerString2(maintainer, ",");
											        	for(int i=0; i<idList.length;i++){
											        		System.out.println(idList[i]);
														%>
															<TR>
																<TD width="10"><input type=checkbox class=inputstyle value="<%=idList[i]%>" name="chkMaintId"></TD>
																<TD  width="*"><%=rc.getResourcename(idList[i])%></TD>
															</TR>
															<TR style="height:1px;"><TD CLASS=LINE COLSPAN=4 style="padding:0;"></TD></TR>
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
    window.close();
    window.parent.returnValue="1";
}
function doAdd(obj){ 
    obj.disabled = true ; 
	window.location="HomepageMaintAddBrowser.jsp?hpid=<%=hpid%>";  
}
function doDel(obj){ 
	if(jQuery("input:checkbox[checked]").length>0){
	    obj.disabled = true ; 
		frmAdd.method.value="delMaint";
		frmAdd.submit();   
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>")
	}
}
//-->
</SCRIPT>


