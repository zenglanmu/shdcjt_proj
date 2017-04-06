<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("HrmCheckInfo:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(7014,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sql="" ;
String id = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="25%">
  <COL width="25%">
  <TBODY>
  <TR>
   <b><%=SystemEnv.getHtmlLabelName(15652,user.getLanguage())%></b>
  </TR>
  <br>
   <TR class=Header>
    <TD><b><%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%></b></TD>
    <TD><b><%=SystemEnv.getHtmlLabelName(15654,user.getLanguage())%></b></TD>
    <TD><b><%=SystemEnv.getHtmlLabelName(15655,user.getLanguage())%></b></TD>
  </TR>
<%  
    Calendar todaycal = Calendar.getInstance ();
    String nowdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
    String countresourceid ="" ;
    String countcheckercount = "" ;
    int temp=0;
    boolean isLight = false;
    sql = "select checkname,id from HrmCheckList where enddate>='"+nowdate+"'" ;
    rs.executeSql(sql);
    while(rs.next()){
        id = Util.null2String(rs.getString("id"));
        sql = "select count(distinct resourceid),count(checkercount) from HrmByCheckPeople where checkid="+id ;
        rs2.executeSql(sql);
        if(rs2.next()) {
            countresourceid = rs2.getString(1);
            countcheckercount = rs2.getString(2);   
        }
        
        isLight = !isLight ;   
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <a href = "/hrm/actualize/HrmCheckBasicInfo.jsp?id=<%=id%>">
    <%=Util.toScreen(rs.getString("checkname"),user.getLanguage())%></a></TD>
    <TD><%=countresourceid%>人</TD> 
    <TD><%=countcheckercount%>人</TD> 
    </TR>
<%      
       
    }  
%>  
  </TBODY>
</TABLE>
<br>
<br>
<br>
<!--TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="25%">
  <COL width="25%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15656,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15654,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15655,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%  
    sql = "select checkname,id from HrmCheckList where enddate<'"+nowdate+"'"  ;
    rs.executeSql(sql);
    while(rs.next()) {
        id = Util.null2String(rs.getString("id"));  
        sql = "select count(distinct resourceid),count(checkercount) from HrmByCheckPeople where checkid="+id;
        rs2.executeSql(sql);
        if(rs2.next()) {
            countresourceid = rs2.getString(1);
            countcheckercount = rs2.getString(2);
        }
        
        isLight = !isLight ;  
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <a href = "/hrm/actualize/HrmCheckBasicInfo.jsp?id=<%=id%>">
    <%=Util.toScreen(rs.getString("checkname"),user.getLanguage())%></a></TD>
    <TD><%=countresourceid%>人</TD> 
    <TD><%=countcheckercount%>人</TD> 
    </TR>
<%       
 }   
%>  
 </TBODY>
 </TABLE-->
<TABLE class=ListStyle cellspacing=1 >
<TBODY>
  <TR>
<b><%=SystemEnv.getHtmlLabelName(15656,user.getLanguage())%></b>
  </TR>
    <!--TR class=Spacing>
        <TD class=Line1 colSpan=2></TD-->
<%
	                     //得到pageNum 与 perpage
	                     int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
	                     int perpage = UserDefaultManager.getNumperpage();
	                     if(perpage <2) perpage=15;
	                     
	                     //设置好搜索条件
	                     String backFields =" t1.checkname,t1.id,t2.cc,t2.ff  ";
	                     String fromSql = " HrmCheckList t1 left join(select checkid ,count(distinct resourceid) cc,count(checkercount) ff from HrmByCheckPeople group by checkid)  t2 on t1.id=t2.checkid";
	                     String sqlWhere = " where enddate<'"+nowdate+"'  " ;
						 String orderBy="";
						 //orderBy = " enddate  ";
						 String linkstr = "";
						 linkstr = "HrmCheckBasicInfo.jsp";
	                     String tableString=""+
	                            "<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
	                            "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
	                            "<head>"+
	                                  "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15653,user.getLanguage())+"\" column=\"checkname\" orderkey=\"id\" href=\""+linkstr+"\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"mainFrame\"/>"+
									  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15654,user.getLanguage())+"\" column=\"cc\" orderkey=\"cc\" transmethod=\"weaver.general.Util.null2o\"/>"+	    
									  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15655,user.getLanguage())+"\" column=\"ff\" orderkey=\"ff\" transmethod=\"weaver.general.Util.null2o\"/>"+
	                            "</head>"+
	                            "</table>";
	                   %>
					   <TABLE width="100%" height="100%">
	                         <TR>
	                             <TD valign="top">
	                                 <wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>"   mode="run"/>
	                             </TD>
	                         </TR>
							 </TBODY>
	                     </TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>