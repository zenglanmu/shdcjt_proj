<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%	
   	String imagefilename = "/images/hdDOC.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17714,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    //以下得搜索时的变量值
    String docTxt = Util.null2String(request.getParameter("docTxt"));
    String SubscriberTxt = Util.null2String(request.getParameter("SubscriberTxt"));    
    String subscribeDateFrom = Util.null2String(request.getParameter("subscribeDateFrom"));
    String subscribeDateTo = Util.null2String(request.getParameter("subscribeDateTo"));   

    //构建where语句
    String andSql="";
    if (!"".equals(docTxt)) andSql+=" and docid="+docTxt;
    if (!"".equals(SubscriberTxt)) andSql+=" and hrmid="+SubscriberTxt;
    if (!"".equals(subscribeDateFrom)) andSql+=" and subscribedate>= '"+subscribeDateFrom+"'";
    if (!"".equals(subscribeDateTo)) andSql+=" and subscribedate<= '"+subscribeDateTo+"'";      
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%   

    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:onAgree(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:onReject(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onSubscribeSearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17713,user.getLanguage())+",javascript:onGoSubsHistory()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17715,user.getLanguage())+",javascript:onBackSubscrible()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onCleanAll()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <TABLE width=100% height=100% border="0" cellspacing="0">
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
                <form name="frmSubscribleApprove" method="post">
                  <input type="hidden" name="operation">
                  <input type="hidden" name="nextUrl">
                  <input type="hidden" name="lastNumPage"> 
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
                         <!--搜索部分-->
                            <TABLE  class ="ViewForm">
                              
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">
                                </colgroup>
                                  <TBODY>
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></TD>
                                    <TD class="field">
                                         <input type="hidden" id="docTxt" name="docTxt" class="wuiBrowser" value="<%=docTxt%>"  _displayText="<%=DocComInfo.getDocname(docTxt)%>" 
                                        	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" 
                                        />
                                        
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18665,user.getLanguage())%></TD>
                                    <TD class="field">
                                       
                                        <input type="hidden" id="SubscriberTxt" name="SubscriberTxt" class="wuiBrowser" value="<%=SubscriberTxt%>"  _displayText="<%=ResourceComInfo.getResourcename(SubscriberTxt)%>" 
                                        	_url="/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
                                        />
                                    </TD>
                                </TR>
                                 <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                 <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18657,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button" class=calendar  onclick="gettheDate(subscribeDateFrom,subscribeDateFromSpan)"></BUTTON>
                                         <SPAN id=subscribeDateFromSpan ><%=subscribeDateFrom%></SPAN>
                                          -
                                         <button type="button" class=calendar onclick="gettheDate(subscribeDateTo,subscribeDateToSpan)"></BUTTON>
                                         <SPAN id=subscribeDateToSpan ><%=subscribeDateTo%></SPAN>

                                         <input type="hidden" name="subscribeDateFrom" value="<%=subscribeDateFrom%>">
                                         <input type="hidden" name="subscribeDateTo" value="<%=subscribeDateTo%>">
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD>&nbsp;</TD>
                                    <TD class="field">&nbsp;
                                    </TD>
                                </TR>      
                                 <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                </TBODY>
                            </TABLE>  
                             <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=10;
                                
                                //设置好搜索条件
                                String backFields ="id,docid,subscribedate,approvedate,searchcase,othersubscribe,subscribedesc,hrmid, subscribetype";
                                String fromSql = " docsubscribe";
                                String sqlWhere = " where ownertype="+user.getLogintype()+" and ownerId ="+user.getUID()+" and state=1 "+andSql;
                                String orderBy="subscribedate";
                                
                                String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
                                       "<browser returncolumn=\"docid\"/>"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col width=\"27%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"  target=\"_fullwindow\"   column=\"docid\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" column=\"subscribedate\" orderkey=\"subscribedate\"/>"+                                            
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+"\" column=\"searchcase\" orderkey=\"searchcase\"/>"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18665,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:subscribetype\"/>"+
                                             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.showOtherSubscribe\"/>"+
                                             "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" column=\"subscribedesc\" orderkey=\"subscribedesc\"/>"+
                                       "</head>"+
                                       "</table>";                                             
                              %>
                                <TABLE width="100%">		
                                    <TR>
                                        <TD valign="top">                
                                            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/> 
                                        </TD>  
                                    </TR>      
                                </TABLE> 
                      </td>
                    </tr>
                  </TABLE>  
                      <input type="hidden" name="subscribeIds">
                      <input type="hidden" name="docIds">
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
          </BODY>
        </HTML>
		  <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
           <SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
		   
<script>
	function onShowDoc(inputname,spanname){
		id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogHeight=535px;dialogWidth=505px;")

		if (id){
			inputname.value=id[0];
			jQuery(spanname).html(id[1]) ;
		}
	}

	function onShowSubscriber(inputname,spanname){
		id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");

	   if(id) {
			inputname.value=id[0];
			jQuery(spanname).html(id[1]); 	
			
		}
	}
</script>
      
          

           

         <SCRIPT LANGUAGE="JavaScript">
        <!--         
	        function onShowMDocidForOwner(spanId, inputeId, checkboxId, para) {
	            // alert("/systeminfo/BrowserMain.jsp?url=/docs/docsubscribe/MutiDocByOwenerBrowser.jsp?subscribePara="+para+"+documentids="+inputeId.value);
	            // para is owenerid +ownertype + subscribeDocId;
	            id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docsubscribe/MutiDocByOwenerBrowser.jsp?documentids=" + inputeId.value + "&subscribePara=" + para);
	            if (id1!=null) {
	                if (id1.id != "") {
	                    selectCheckbox(checkboxId);
	                    DocIds = id1.id;
	                    DocName = id1.name;
	         
	                    sHtml = "";
	                    DocIds = DocIds.substring(1, DocIds.length);
	                    inputeId.value = DocIds;
	                    DocName = DocName.substring(1, DocName.length);
	                    while (DocIds.indexOf(",")>-1){
		                    curid = DocIds.substring(0, DocIds.indexOf(",") - 1);
		                    curname = DocName.substring(0, DocName.indexOf(",") - 1);
		                    DocIds = DocIds.substring(DocIds.indexOf(",") + 1, DocIds.length);
		                    DocName = DocName.substring(DocName.indexOf(",") + 1, DocName.length);
		                    sHtml = sHtml + curname + "&nbsp";
		                    
	                    }
	                    sHtml = sHtml + DocName + "&nbsp";
	                    jQuery(spanId).html(sHtml);
	                    
	                } else {
	                    spanId.innerHTML = "";
	                    inputeId.value = "";
	                };
	                //alert(inputeId.id +" "+inputeId.value);
	            }
	        }
              function selectCheckbox(obj){
                  obj.checked = true ;
                  _xtalbe_chkCheck(obj) ;
              }
              function onSearch() {
                frmSubscribleApprove.submit();
              }
              function onAgree(obj) {                 
                frmSubscribleApprove.operation.value="approve";
                frmSubscribleApprove.action="DocSubscribeOperate.jsp" ;                
                frmSubscribleApprove.subscribeIds.value=_xtable_CheckedCheckboxId();
                frmSubscribleApprove.docIds.value=_xtable_CheckedCheckboxValue();
                obj.disabled = true ;
                frmSubscribleApprove.submit();
              }
              function onReject(obj){
                frmSubscribleApprove.operation.value="reject";       
                frmSubscribleApprove.action="DocSubscribeOperate.jsp" ;                
                frmSubscribleApprove.subscribeIds.value=_xtable_CheckedCheckboxId();
                frmSubscribleApprove.docIds.value=_xtable_CheckedCheckboxValue();
                obj.disabled = true ;
                frmSubscribleApprove.submit();
              }
              
              function onSubscribeSearch(){
                  window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
              }

              function onGoSubsHistory() {
                window.location="/docs/docsubscribe/DocSubscribeHistory.jsp";
              }
              
              function onBackSubscrible() {
                window.location="/docs/docsubscribe/DocSubscribeBack.jsp";
              }
               function onBack(){
                   window.history.go(-1);
              }           
        
            function onCleanAll(){
               _xtable_CleanCheckedCheckbox();
            }         
        //-->
        </SCRIPT>