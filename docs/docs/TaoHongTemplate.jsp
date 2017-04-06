<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="formFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="fieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />

<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(172,user.getLanguage()) + "£º" + SystemEnv.getHtmlLabelName(16370,user.getLanguage());
    String needfav = "";
    String needhelp = "";
	String seccategory = request.getParameter("seccategory");   
	String wordmouldid = request.getParameter("wordmouldid");
%>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver.js"></script>
    </HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_self}";
    RCMenuHeight += RCMenuHeightStep;      
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self}";
    RCMenuHeight += RCMenuHeightStep;  
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM name="" method="post" action="" >

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <COLGROUP>
            <COL width="10">
            <COL width="">
            <COL width="10">
        <TR>
            <TD height="10" colspan="3"></TD>
        </TR>
        <TR>
            <TD ></TD>
            <TD valign="top">
                <TABLE class=Shadow>
                    <TR>
                        <TD valign="top">                            
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
                                <TR class="Title">
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TH>
                                </TR>                                
                                <TR class="Spacing">
                                    <TD class="Line1" colSpan=2></TD>
                                </TR>                         
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(19369,user.getLanguage())%></TD>
                                	<TD class=Field>     
									<%
									  recordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in (3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + seccategory);
									%>
								    	<SELECT class=inputstyle name="docMouldID">
								    		<OPTION value="0"></OPTION>
                                    <%
									  while(recordSet.next()){
										  String docMouldID = recordSet.getString("ID");										            
										  String docMouldName = recordSet.getString("mouldName");
									%>
								    		<OPTION value="<%= docMouldID %>"
											 <% if(docMouldID.equals(wordmouldid)){%>
												 selected
											  <%}%>><%= docMouldName %></OPTION>	
									<%}%>		
			                            </SELECT>
                                    </TD>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>
                                
                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>                                                       
                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>           
</FORM>
</BODY>
<script language=javascript>
function onClose(){
	window.close();
}

function onSure(){
   window.returnValue = document.getElementById('docMouldID').value;
   window.close();
}
</script>
</HTML>
