<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<%  
    //get whereclause	
    String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;	
    DocSubscribe ds = new DocSubscribe(whereclause,user);
	String imagefilename = "/images/hdDOC.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18668,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%> 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%  

    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubscribe(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onResearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17713,user.getLanguage())+",javascript:onShowSubscribeHistory()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17714,user.getLanguage())+",javascript:onApprove()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17715,user.getLanguage())+",javascript:onBackSubscrible()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;


    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;   
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <form name="frmDocSubscribe" method="post">
    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
      <colgroup>
        <col width="10">
        <col width="">
         <col width="10">
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">                                                                                    
                          <%
                            //·ÖÒ³         
                            int perpage = UserDefaultManager.getNumperpage();
                            if(perpage <2) perpage=10;                       
                            
                            String backfields ="t1.id, t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.doclastmoddate,t1.replaydoccount,t1.docpublishtype,t1.ownerId";
                           
                            String fromSql = " from docdetail t1 left join "+ShareManager.getShareDetailTableByUser("doc",user)+" t2  on t1.id=t2.sourceid ";

                            String sqlWhere  = whereclause+" and t1.orderable = '1'  and t2.sourceid is null and not exists(select 1 from docsubscribe where docid=t1.id and state in('1','2') and hrmId="+user.getUID()+")";

                            String tableString =" <table instanceid=\"DocSubscribeTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"doccreatedate\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "        <col width=\"3%\"  text=\" \" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                                 "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"docsubject\" orderkey=\"docsubject\"/>"+
                                                 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(2094,user.getLanguage())+"\" column=\"ownerId\" orderkey=\"t1.ownerId\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getHrmname\" href =\"/hrm/resource/HrmResource.jsp\"  linkkey=\"id\" target=\"_fullwindow\"/>"+
                                                 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>"+
                                                 "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate\"/>"+
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(117,user.getLanguage())+"\" column=\"replaydoccount\" orderkey=\"replaydoccount\"/>"+
                                                 "			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>"+
                                                 "			</head>"+   			
                                                 "</table>"; 
                          %>
                          <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/>       
                          <TEXTAREA  name="subscribeDocId" style="display:none"></TEXTAREA>
                      </td>
                    </tr>
                  </TABLE>
                </td>
                <td></td>
              </tr>            
            </table>     
            </form>
            </BODY>
        </HTML>
        <SCRIPT LANGUAGE="JavaScript">
        <!--          
          function onSubscribe(obj){
                document.frmDocSubscribe.subscribeDocId.value=_xtable_CheckedCheckboxId();             
                frmDocSubscribe.action="DocSubscribeAdd.jsp"
                obj.disabled = true ;
                frmDocSubscribe.submit();               
          }

          function onResearch(){
              window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
          }

           function onBack(){
               window.history.go(-1);
          }

          function onShowSubscribeHistory(){
              window.location="/docs/docsubscribe/DocSubscribeHistory.jsp";
          }
          function onApprove() {
            window.location="/docs/docsubscribe/DocSubscribeApprove.jsp";
          }
          
          function onBackSubscrible() {
            window.location="/docs/docsubscribe/DocSubscribeBack.jsp";
          }        
        //-->
        </SCRIPT>

