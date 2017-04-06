<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename =SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18599,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
if(!canmaint){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checksubmit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

         RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>



<form name=frmmain action="VotingMaintOperation.jsp" method=post>
<input type=hidden name=method value="add">
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
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="20%">
  <COL width="30%">
  <TBODY>
  <TR>
  <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
  <td class=field>
  <button class=browser type="button" onclick='onShowResource(createrid,createrspan)'></button><input type=hidden name='createrid' value=''>
  <span id='createrspan'><IMG src="/images/BacoError.gif" align=absMiddle></span>
  </td>
  <td><%=SystemEnv.getHtmlLabelName(2153,user.getLanguage())%></td>
  <td class=field>
  <button class=browser type="button" onclick='onShowResource1(approverid,approverspan)'></button><input type=hidden name='approverid' value=''>
  <span id='approverspan'><IMG src="/images/BacoError.gif" align=absMiddle></span>
  </td>
  </tr>
   <TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>
  </tbody>
</table>  
</form>
<table class=listStyle>
<col width=40%><col width=40%>
  <TR class=Section>
    <TH colSpan=3><div align="left"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%><div></TH></TR>
  <TR>
    <TD colSpan=3><hr></TD></TR>
  <tr class=header> 
    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%> </td>
    <td><%=SystemEnv.getHtmlLabelName(2153,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr> 
<%
boolean islight=true ;
RecordSet.executeSql("select * from votingmaintdetail");
    
while(RecordSet.next()){
	String id=RecordSet.getString("id");
	String createrid=RecordSet.getString("createrid");
    String approverid=RecordSet.getString("approverid");
%> 
  <TR <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>>
  <td><%=ResourceComInfo.getResourcename(createrid)%></td>
  <td><%=ResourceComInfo.getResourcename(approverid)%></td>
  <td><a href="VotingMaintOperation.jsp?method=delete&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>
  </tr>
<%
    islight=!islight ;
}
%>
</table>

                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
 <script LANGUAGE="JavaScript">        
 function checksubmit(){
 	if(check_form(frmmain,'createrid,approverid')){	
 		frmmain.submit();	
 	}
 }    
 function onShowResource(inputname,spanname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
		if (data.id!=""){
			inputname.value= data.id
			spanname.innerHTML = "<a href='/hrm/resource/HrmResource.jsp?id="+data.id+"' target='_blank'>"+data.name+"</a>"
		}else{	
		 	spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		 	inputname.value=""
		}
	}
 }   
 function onShowResource1(inputname,spanname){
	 data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
		if (data.id!=""){
			inputname.value= data.id
			spanname.innerHTML = "<a href='/hrm/resource/HrmResource.jsp?id="+data.id+"' target='_blank'>"+data.name+"</a>"
		}else{	
		 	spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		 	inputname.value=""
		}
	}
 }
  </script> 
</BODY></HTML>