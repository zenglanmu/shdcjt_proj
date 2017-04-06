<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    boolean canEdit = false ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if(HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ProjTempletAdd.jsp,_self} " ;
        RCMenuHeight += RCMenuHeightStep;

        canEdit = true ;
    }
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:document.forms[0].submit();,_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep;



//added by hubo,20060228,为项目模板增加搜索功能
String strTemplateName = Util.null2String(request.getParameter("templateName"));
String strProTypeId = Util.null2String(request.getParameter("proTypeId"));
String strTemplateStatus = Util.null2String(request.getParameter("templateStatus"));
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
		  <table class="viewform">
		  <form name="myform" method="post" action="ProjTempletList.jsp">
		  <colgroup>
		  <col width="10%">
		  <col width="26%">
		  <col width="5%">
		  <col width="10%">
		  <col width="18%">
		  <col width="5%">
		  <col width="10%">
		  <col width="16%">
		  <tbody>
			<tr>
			<td><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
			<td class=field>
			<input type=text name="templateName" style="width:250px" class="Inputstyle" value="<%=strTemplateName%>">
			</td>
			<td></td>
			<td><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></td>
			<td class=field>
			<select name="proTypeId" id="proTypeId">
			<option value=''></option>
			<%
			String sql = "SELECT id,fullname FROM Prj_ProjectType";
			rs.executeSql(sql);
			while(rs.next()){
				out.println("<option value='"+rs.getInt("id")+"' ");
				if(strProTypeId.equals(String.valueOf(rs.getInt("id"))))	out.println("selected");
				out.println(">"+rs.getString("fullname")+"</option>");
			}
			%>
			</select>
			</td>
			<td></td>
			<td><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
			<td class=field>
			<select name="templateStatus" id="templateStatus">
			<option value='' <%if(strTemplateStatus.equals(""))out.println("selected");%>></option>
			<option value="1" <%if(strTemplateStatus.equals("1"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
			<option value="0" <%if(strTemplateStatus.equals("0"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
			<option value="2" <%if(strTemplateStatus.equals("2"))out.println("selected");%>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
			</select>
			</td>
			</tr>
			<TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
		  </tbody>
		  </form>
		  </table>
            <%
				String sqlWhere = "WHERE 1=1 ";
				if(!strTemplateName.equals("")){
					sqlWhere += " AND templetName LIKE '%"+strTemplateName+"%'";
				}
				if(!strProTypeId.equals("")){
					sqlWhere += " AND proTypeId="+Util.getIntValue(strProTypeId)+"";
				}
				if(!strTemplateStatus.equals("")){
					//status 3:退回草稿状态
					if(strTemplateStatus.equals("0")){
						sqlWhere += " AND (status='0' OR status='3')";
					}else{
						sqlWhere += " AND status='"+strTemplateStatus+"'";
					}
				}
            String popedomOtherpara="";
            if (canEdit) popedomOtherpara="true"; else popedomOtherpara="false";
            String tableString=""+
                       "<table  pagesize=\"10\" tabletype=\"none\">"+
                       "<sql backfields=\"id,templetName,templetDesc,proTypeId,workTypeId,isSeleCted,status\" sqlform=\"Prj_Template\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
                       "<head>"+                             
                             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"templetName\"   target=\"_self\" linkkey=\"templetId\" linkvaluecolumn=\"id\" href=\"ProjTempletView.jsp\" orderkey=\"templetName\"/>"+
                             "<col width=\"32%\"  text=\""+SystemEnv.getHtmlLabelName(18627,user.getLanguage())+"\" column=\"templetDesc\" orderkey=\"templetDesc\"/>"+
                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"proTypeId\" orderkey=\"proTypeId\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjTypeName\"/>"+
                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForProj.getTemplateStatus\" otherpara=\""+user.getLanguage()+"\"/>"+ 
									  				 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(432,user.getLanguage())+"\"  column=\"workTypeId\" orderkey=\"workTypeId\" transmethod=\"weaver.splitepage.transform.SptmForProj.getWorkTypeName\"/>"+   
                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18631,user.getLanguage())+"\"  column=\"isSeleCted\" orderkey=\"isSeleCted\" transmethod=\"weaver.splitepage.transform.SptmForProj.getIsSelect\"/>"+
                       "</head>"+
                       "<operates width=\"12%\">"+
                       "<popedom transmethod=\"weaver.splitepage.operate.SpopForProj.getProjTypePope\"  otherpara=\""+popedomOtherpara+"\"></popedom>"+
                       "    <operate href=\"javascript:doTempletEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"0\"/>"+
                       "    <operate href=\"javascript:doTempletDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>"+
                       "</operates>"+
                       "</table>"; 
            
            %>
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/> 
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

<SCRIPT LANGUAGE="JavaScript">
<!--
 function doTempletEdit(templetId){
     window.location='ProjTempletEdit.jsp?templetId='+templetId;
 }


  function doTempletDel(templetId){
	  if(confirm("<%=SystemEnv.getHtmlLabelName(20903,user.getLanguage())%>"))
     window.location='ProjTempletOperate.jsp?method=delete&templetId='+templetId;
  }
//-->
</SCRIPT>
