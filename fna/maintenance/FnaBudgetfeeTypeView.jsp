<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<% 
boolean canedit = HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1011,user.getLanguage());
String needfav ="1";
String needhelp ="";

    //以下得搜索时的变量值
    //科目级别
    String subjectLevel = Util.null2String(request.getParameter("subjectLevel"));
    //科目名称
    String subjectName = Util.null2String(request.getParameter("subjectName"));
    //上级科目
    String parent = Util.null2String(request.getParameter("parent"));
    //展开层
    int level = new Integer(Util.null2o(request.getParameter("level"))).intValue();

    //构建where语句
    String andSql="";
    if (!"".equals(subjectLevel)) andSql+=" and feelevel="+subjectLevel;
    if (!"".equals(subjectName)) andSql+=" and name like '%"+subjectName+"%'";
    if(!"".equals(parent)) andSql+= "and supsubject = " + parent;


%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("FnaLedgerAdd:Add", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaBudgetfeeTypeAdd.jsp?feelevel="+(level+1)+"&supsubject="+parent+",_parent} " ;
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

<FORM id=weaver name=frmmain action=FnaBudgetfeeTypeOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="add">

                         <!--搜索部分-->
                            <TABLE  class ="ViewForm">
                                <TBODY>
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <Input type="text" class="inputstyle" name="subjectName" value="<%=subjectName%>"/>
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18427,user.getLanguage())%></TD>
                                    <TD class="field">
			                            <SELECT class=InputStyle name=subjectLevel>
                                          <OPTION value=""  <%if(subjectLevel.equals("")){ %> selected<%}%>>&nbsp;</OPTION>
			                              <option value="1" <%if(subjectLevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></option>
			                              <option value="2" <%if(subjectLevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></option>
			                              <option value="3" <%if(subjectLevel.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></option>
			                            </SELECT>
                                    </TD>
                                </TR>
                                 <TR style="height: 1px"><TD class=Line colSpan=5></TD></TR>
                                </TBODY>
                            </TABLE>



                             <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=15;

                                //设置好搜索条件
                                String backFields =" id,name,description,agreegap,feeperiod,feetype,feelevel,supsubject,alertvalue ";
                                String fromSql = " FnaBudgetfeeType ";
                                String sqlWhere = " where 1=1 "+andSql;
                                String orderBy=" feelevel,name ";

                                String tableString=""+
                                       "<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
                                       "<head>"+
                                             "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15409,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" href=\"FnaBudgetfeeTypeEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"mainFrame\"/>"+
                                             "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18427,user.getLanguage())+"\" column=\"feelevel\" orderkey=\"feelevel\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getSubjectLevel\" />"+
                                             "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\" orderkey=\"description\" />"+
                                       "</head>"+
                                       "</table>";
                              %>
                                <TABLE width="100%" height="100%">
                                    <TR>
                                        <TD valign="top">
                                            <wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>"  mode="run"/>
                                        </TD>
                                    </TR>
                                </TABLE>
                  </form>



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
</body>
<SCRIPT language="javascript">
function onSearch(){
        document.frmmain.action="FnaBudgetfeeTypeView.jsp";
        document.frmmain.operation.value="search";
		document.frmmain.submit();
}
</script>
</html>