<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %>


<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page"/>

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/docs/sendDoc/DocReceiveUnitAdd.jsp?superiorUnitId="+DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID+"&subcompanyid="+subcompanyid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3"  style="padding: 0!important;"></TD></TR> 
<%
    String isLight= "false";
	String id="";
	String receiveUnitName="";
	String superiorUnitId="";
	String receiverIds="";
	String canceled="";


	List allReceiveUnitList=new ArrayList();
	Map allReceiveUnitMap=null;
	DocReceiveUnitManager.setSubcompanyid(subcompanyid);
	DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(), rightStr);
    DocReceiveUnitManager.getAllReceiveUnitList(allReceiveUnitList,DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID);

    
    for(int i=0;i<allReceiveUnitList.size();i++){

        allReceiveUnitMap=(Map)allReceiveUnitList.get(i);
		id = (String)allReceiveUnitMap.get("id"); 
		receiveUnitName =(String)allReceiveUnitMap.get("receiveUnitName"); 
		superiorUnitId = (String)allReceiveUnitMap.get("superiorUnitId"); 
		receiverIds = (String)allReceiveUnitMap.get("receiverIds"); 
		canceled = (String)allReceiveUnitMap.get("canceled");

		if(isLight.equals("false")){
			isLight = "true";
%>
	    <TR class=datalight>
<%
  	    }else{
			isLight = "false";
%>
	    <TR class=datadark>
<%  	
	    }
%>    
    <TD><a href="/docs/sendDoc/DocReceiveUnitDsp.jsp?id=<%=id%>"><%=receiveUnitName%></a>
<%
        if("1".equals(canceled)){
%>
      	   <span><font color="red">(<%=SystemEnv.getHtmlLabelName(22205,user.getLanguage())%>)</font></span>
<%
        }
%>
	   </TD>
    <TD><a href="/docs/sendDoc/DocReceiveUnitDsp.jsp?id=<%=superiorUnitId%>"><%=DocReceiveUnitComInfo.getReceiveUnitName(superiorUnitId+"")%></a></TD>
    <TD><%=ResourceComInfo.getMulResourcename1(receiverIds)%></TD>
  </TR>
<% 
    }
%>  
 </TBODY></TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</BODY></HTML>
