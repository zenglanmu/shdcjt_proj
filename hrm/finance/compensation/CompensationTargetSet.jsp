<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Setting", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Setting",subcompanyid);
    if(operatelevel<1){
        hasright=false;
        if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
    }
    }else{
       hasright=false;
    }
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(19427,user.getLanguage())+":"+subcompanyname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location.href=\"CompensationTargetSetEdit.jsp?subCompanyId="+subcompanyid+"\",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=ListStyle>
  <COLGROUP>
  <COL width="30%">
  <COL width="20%">
  <COL width="20%">
  <COL width="30%">
  <TBODY>
  <TR class=Header >
  <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
  </TR>
  <%
  RecordSet.executeSql("select * from HRM_CompensationTargetSet where subcompanyid="+subcompanyid+" order by showorder asc,id asc");
  int i=0;
  while(RecordSet.next()){
      i++;
      int AreaType=RecordSet.getInt("AreaType");
      String Areatypename="";
      //总部 0
      if(AreaType==0){
          Areatypename=SystemEnv.getHtmlLabelName(140,user.getLanguage());
      }
      //分部 1
      if(AreaType==1){
          Areatypename=SystemEnv.getHtmlLabelName(141,user.getLanguage());
      }
      //本分部及下级分部 2
      if(AreaType==2){
          Areatypename=SystemEnv.getHtmlLabelName(19436,user.getLanguage());
      }
      //指定分部  3
      if(AreaType==3){
          Areatypename=SystemEnv.getHtmlLabelName(19437,user.getLanguage());
      }
      //指定部门  4
      if(AreaType==4){
          Areatypename=SystemEnv.getHtmlLabelName(19438,user.getLanguage());
      }
  if(i%2==0){
  %>
  <TR class="DataDark">
  <%}else{%>
  <TR class="DataLight">
  <%}%>
      <TD><%if(hasright){%><a href="CompensationTargetSetEdit.jsp?id=<%=RecordSet.getString("id")%>&subCompanyId=<%=subcompanyid%>"><%}%><%=RecordSet.getString("TargetName")%><%if(hasright){%></a><%}%></TD>
      <TD><%=Areatypename%></TD>
      <TD><%=subcompanyname%></TD>
      <TD><%=RecordSet.getString("Explain")%></TD>
  </TR>
  <%}%>
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
</BODY>
</HTML>