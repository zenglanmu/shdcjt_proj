<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%  
    DocSubscribe ds = new DocSubscribe("",user);
    String subscribeDocId = Util.null2String(request.getParameter("subscribeDocId"));
   
    ArrayList addDocLists = Util.TokenizerString(subscribeDocId,",");
    
    String strSearchCase = ds.getSearchCase(request,user.getLanguage());

	String imagefilename = "/images/hdDOC.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(611,user.getLanguage());
	String needfav ="1";
    String needhelp ="";
    
    //user info
    int userid = user.getUID();
    String logintype = user.getLogintype();
    String userSeclevel = user.getSeclevel();
    String userType = ""+user.getType();
    String userdepartment = ""+user.getUserDepartment();
    String usersubcomany = ""+user.getUserSubCompany1(); 
    //0:²é¿´
    boolean canReader = false;
    String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;    


%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18655,user.getLanguage())+",javascript:onResearch()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;


    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
                <form name="frmDocSubscribeAdd" method="post" action="DocSubscribeOperate.jsp">

                <input type="hidden" name="operation" value="add">
                <TEXTAREA NAME="searchCase" style="display:none"><%=strSearchCase%></TEXTAREA>
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
                        <table class="ViewForm">
                            <colgroup>
                            <col width="30%">
                            <col width="70%">
                            <tr>
                                <td><%=SystemEnv.getHtmlLabelName(20550,user.getLanguage())%></td>
                                <td class="field"><%=strSearchCase%></td>
                            </tr>
                            <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></td>
                                <td class="field">
                                    <%                                   
                                      int tempLength = addDocLists.size();
                                      for (int i=0 ;i<tempLength;i++){
                                    	  String docidtemp = (String)addDocLists.get(i);
                                    	  ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+(String)addDocLists.get(i),userInfo);
                                    	  if (((String)PdocList.get(0)).equals("true")) canReader = true ;
                                    	  
                                    	  String statetemp = "";
                                    	  rs.executeSql("select id,state from DocSubscribe where docid ="+docidtemp+" and hrmid ="+userid+" order by id desc");
                                    	  if(rs.next()) statetemp = rs.getString("state");
                                    	  if("1".equals(statetemp)) {
                                    		  out.println(DocComInfo.getDocname(docidtemp)+"<span style='color:green'>("+SystemEnv.getHtmlLabelName(23694,user.getLanguage())+")</span>");
                                    	  } else if ("2".equals(statetemp) || canReader) {
                                    		  out.println(DocComInfo.getDocname(docidtemp)+"<span style='color:red'>("+SystemEnv.getHtmlLabelName(24412,user.getLanguage())+")</span>");
                                    	  } else {
                                    		  out.println(DocComInfo.getDocname((String)addDocLists.get(i)));
                                    %>
                                             <input type="hidden" name="docids" value="<%=addDocLists.get(i)%>">
                                    <%
                                    	  }    	  
                                          out.println("<BR>");
                                    %>
                                          
                                    <% } 
                                          out.println("<BR>");
                                          out.println(SystemEnv.getHtmlLabelName(18998,user.getLanguage())+""+tempLength+SystemEnv.getHtmlLabelName(15015,user.getLanguage()));                                       
                                    %>                                  
                                   
                                </td>
                            </tr>
                            <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>
                             <tr>
                                <td><%=SystemEnv.getHtmlLabelName(18664,user.getLanguage())%></td>
                                <td class="field"><TEXTAREA class  ="inputstyle" NAME="subscribeDesc" ROWS="4" COLS="80"></TEXTAREA></td>
                            </tr>
                            <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>
                        </table>
                      </td>
                    </tr>
                  </TABLE>
                  <textarea id="txtShare" onclick="onSubmit(this)" style="visibility:hidden"></textarea>
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
         <SCRIPT LANGUAGE="JavaScript">
        <!--          
          function onSubmit(obj){        
             obj.disabled=true ;
             frmDocSubscribeAdd.submit();
          }

           function onBack(){ 
             window.history.go(-1);
          }
           function onResearch(){
              window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
          }
         
        //-->
        </SCRIPT>