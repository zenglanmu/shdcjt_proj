<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LabelMainManager" class="weaver.systeminfo.label.LabelMainManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
<%
	String searchcon="";
	searchcon = Util.null2String(request.getParameter("searchcon"));
	//searchcon=URLDecoder.decode(searchcon);//用response.sendRedirect来传递需要转码接收方需要解码
	String labelId="";
	labelId = Util.null2String(request.getParameter("labelId"));
%>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.frmSearch.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmSearch.elements[i].name=='delete_label_id') {
document.frmSearch.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.frmSearch.checkall0.checked){
	document.frmSearch.checkall0.checked =0;
    }
}
function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/systeminfo/images_systeminfo/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 标签</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
 <%
 String temptable = "prjstemptable"+ Util.getRandom() ;
 String SearchSql;
int pageNum=Util.getIntValue(request.getParameter("pageNum"),1);
int perPage=Util.getIntValue(request.getParameter("perPage"),1);
if(perPage<=1 )	perPage=150;
%>
  <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="\systeminfo\label\LabelOperation.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchlabel()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
	<%if(Util.getIntValue(user.getSeclevel(),0)>=20){%>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addlabel()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deletelabel()"><U>D</U>-删除</BUTTON>
	<%}%>
    <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewSQL()"><U>E</U>-导出SQL</BUTTON>
	<input type=hidden name=pageNum value=<%=pageNum%>>
	<input type=hidden name=perPage value=<%=perPage%>>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="5%"> <COL width="32%"> <COL width=1> <COL width="10%"> <COL width="32%"> <TBODY>
          <TR class=Section>
            <TH colSpan=5>搜索条件</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep1 colSpan=5></TD>
          </TR>
		   <TR>
            <TD>标签ID</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=labelId accessKey=Z value="<%=labelId%>">
            </TD>
          </TR>
          <TR>
            <TD>标签描叙</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=searchcon accessKey=Z value="<%=searchcon%>">
            </TD>
          </TR>
          </TBODY>
        </TABLE>
        <br>
        <TABLE class=ListShort>
          <COLGROUP> <COL width="10%"> <COL width="30%"> <COL width="30%"> <COL width="30%"><TBODY>
          <TR class=Section>
            <TH colSpan=5>搜索结果</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=4></TD>
          </TR>
          <TR class=Header>
            <Td >选择</Td>
            <Td >标识</Td>
            <Td >描叙</Td>
            <Td >细节</Td>
          </TR>
<%
int maxNum=1;
String maxNumSql;
String whereSql =" where id !=0 ";
if (!searchcon.equalsIgnoreCase("")){
	whereSql += " and indexdesc like '%" + searchcon + "%' ";
}
if (!labelId.equalsIgnoreCase("")){
	whereSql += " and id =" + labelId + " ";
}
if(RecordSet.getDBType().equals("oracle")){
	maxNumSql = "select count(id) RecordSetCounts from HtmlLabelIndex "+whereSql ;
	SearchSql = "create table "+temptable+"  as select * from (select * from HtmlLabelIndex "+whereSql+" order by id desc) where rownum<"+ (pageNum*perPage+2);
}else{
	maxNumSql = "select count(id) RecordSetCounts from HtmlLabelIndex "+whereSql;
	SearchSql = "select top "+(pageNum*perPage+1)+" * into "+temptable+" from HtmlLabelIndex "+whereSql+" order by id desc";
}
RecordSet.executeSql(SearchSql);
RecordSet.executeSql(maxNumSql);
if(RecordSet.next()){
    maxNum = RecordSet.getInt("RecordSetCounts")/perPage;
	if ((RecordSet.getInt("RecordSetCounts") % perPage)!=0)
	maxNum = maxNum+1;
}

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pageNum*perPage){
	hasNextPage=true;
	}

	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pageNum-1)*perPage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pageNum-1)*perPage)+" * from "+temptable+"  order by id";
}

RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+temptable);
boolean isLight = false;
int totalline=1;
if(RecordSet.last()){
	do{
		if(isLight)
		{%>
	<TR CLASS="DataDark">
<%		}else{%>
	<TR CLASS="DataLight">
<%		}%>
            <TD><input type="checkbox" name="delete_label_id" value="<%=RecordSet.getInt("id")%>" onClick=unselectall()></TD>
            <TD><%=RecordSet.getInt("id")%></TD>
            <TD><%=RecordSet.getString("indexdesc")%></TD>
            <TD><a href="ViewLabel.jsp?id=<%=RecordSet.getString("id")%>&indexdesc=<%=RecordSet.getString("indexdesc")%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
          </TR>

<%
	isLight = !isLight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perPage)	break;
	}
}while(RecordSet.previous());
}
%>
<TR class=Separator>
            <TD class=sep2 colSpan=4>
            <input type="hidden" name="operation" value="search">
            </TD>
          </TR>
<tr>
          </TBODY>
        </TABLE>
        <br>
		<input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON"><%=SystemEnv.getHtmlLabelName(2241,user.getLanguage()) %><br>
		<%if(pageNum>1){%>
		<BUTTON class=btn id=btnFirst accessKey=F name=btnFirst onclick="onFirst()"><U>F</U>-<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage()) %></BUTTON>
		<BUTTON class=btn id=btnPrev accessKey=P name=btnPrev onclick="onPrev()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage()) %></BUTTON>
		<%}%>
		<%if((RecordSetCounts-(pageNum-1)*perPage)>perPage){%>
		<BUTTON class=btn id=btnNext accessKey=N name=btnNext onclick="onNext()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage()) %></BUTTON>

		<BUTTON class=btn id=btnLast accessKey=L name=btnLast onclick="onLast()"><U>L</U>-<%=SystemEnv.getHtmlLabelName(18362,user.getLanguage()) %></BUTTON>
     	<%}%>
		<br><br>

      </FORM>
<script>
function addlabel() {
	location="AddLabel.jsp";
}
function searchlabel() {
	document.frmSearch.operation.value="search";
	document.frmSearch.submit();
}
function deletelabel() {
	document.frmSearch.operation.value="deletelabel";
	if(confirmdel())
		document.frmSearch.submit();
}
function onFirst() {
	document.frmSearch.operation.value="onFirst";
	document.frmSearch.pageNum.value=1
	document.frmSearch.submit();
}
function onPrev() {
	document.frmSearch.operation.value="onPrev";
	document.frmSearch.pageNum.value=<%=pageNum-1%>
	document.frmSearch.submit();
}
function onNext() {
	document.frmSearch.operation.value="onNext";
	document.frmSearch.pageNum.value=<%=pageNum+1%>
	document.frmSearch.submit();
}
function onLast() {
	document.frmSearch.operation.value="onLast";
	document.frmSearch.pageNum.value=<%=maxNum%>
	document.frmSearch.submit();
}
function viewSQL(){
    document.frmSearch.action="ViewSql.jsp";
    document.frmSearch.submit();
}
</script>
      </BODY>
      </HTML>
