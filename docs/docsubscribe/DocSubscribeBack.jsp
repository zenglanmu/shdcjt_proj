<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%	
	String imagefilename = "/images/hdDOC.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17715,user.getLanguage());
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
    if (!"".equals(subscribeDateFrom)) andSql+=" and subscribedate>='"+subscribeDateFrom+"'";
    if (!"".equals(subscribeDateTo)) andSql+=" and subscribedate<='"+subscribeDateTo+"'";      
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

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18666,user.getLanguage())+",javascript:onGetBack(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onSubscribeSearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(17713,user.getLanguage())+",javascript:onGoSubsHistory()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17714,user.getLanguage())+",javascript:onApprove()',_top} " ;
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
                <form name="frmSubscribleGetBack" method="post" action="" >
                <input type="hidden" name="operation">
                <input type="hidden" name="lastNumPage"> 
                <input type="hidden" name="nextUrl">                 
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
                                </TBODY>
                                 <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                            </TABLE>  
                         <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=10;
                                
                                //设置好搜索条件
                                String backFields ="a.id,a.docid,a.subscribedate,a.approvedate,a.searchcase,a.othersubscribe,a.subscribedesc,a.hrmid, a.subscribetype,b.id bid";
                                String fromSql = " docsubscribe a,DocDetail b";
                                String sqlWhere = " where a.ownertype="+user.getLogintype()+" and a.ownerId ="+user.getUID()+" and a.state=2 "+andSql+" and a.docId = b.id ";
                                String orderBy="subscribedate";

                                String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
                                       "<browser returncolumn=\"docid\"/>"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col width=\"27%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\"  href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"  target=\"_fullwindow\" column=\"docid\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" column=\"approvedate\" orderkey=\"approvedate\"/>"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18665,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:subscribetype\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" column=\"subscribedesc\" orderkey=\"subscribedesc\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+"\" column=\"searchcase\" orderkey=\"searchcase\"/>"+
                                             "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" column=\"othersubscribe\"  orderkey=\"othersubscribe\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNames\"/>"+
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
		
         <SCRIPT LANGUAGE="vbScript">
            sub onShowDoc(inputname,spanname)
                id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
                if Not isempty(id) then
                    inputname.value=id(0)&""
                    spanname.innerHtml = id(1)&""	
                end if	
            end sub

            sub onShowSubscriber(inputname,spanname)
                id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
                if Not isempty(id) then
                    inputname.value=id(0)&""
                    spanname.innerHtml = id(1)&""	
                end if	
            end sub
        </SCRIPT>

         <SCRIPT LANGUAGE="JavaScript">
        <!--        
			 
			 function onShowDoc(inputname,spanname){
				id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogHeight=535px;dialogWidth=505px;");
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
              function onSearch() {
                frmSubscribleGetBack.submit();
              }
              function onGetBack(obj) {                          
                frmSubscribleGetBack.operation.value="getback";       
                frmSubscribleGetBack.action="DocSubscribeOperate.jsp" ;                
                frmSubscribleGetBack.subscribeIds.value=_xtable_CheckedCheckboxId();
                frmSubscribleGetBack.docIds.value=_xtable_CheckedCheckboxValue();
                obj.disabled = true ;
                frmSubscribleGetBack.submit();;
              }
              
              function onSubscribeSearch(){
                  window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
              }

              function onGoSubsHistory() {
                window.location="/docs/docsubscribe/DocSubscribeHistory.jsp";
              }
              
              function onApprove() {
                window.location="/docs/docsubscribe/DocSubscribeApprove.jsp";
              }
               function onBack(){
                   window.history.go(-1);
              }           
              function onCleanAll(){
                 _xtable_CleanCheckedCheckbox();
              }
         
        //-->
        </SCRIPT>
        <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
        <SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>