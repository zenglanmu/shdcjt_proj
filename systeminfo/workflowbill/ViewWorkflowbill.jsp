<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil" %>
<html>
<%
    //处理顺序
    String doAction = Util.null2String(request.getParameter("doAction"));
    String[] srcOrder = request.getParameterValues("editorder");
    int id = Util.getIntValue(request.getParameter("id"),0);
    RecordSet rs2 = new RecordSet();
    if(doAction.equals("doFieldOrder")){
        rs.executeSql("select id,dsporder from workflow_billfield where billid="+id+" order by dsporder,id");
        int orderIndex = 0;
        while(rs.next()){
            rs2.executeSql("update workflow_billfield set dsporder="+orderIndex+" where id="+rs.getString("id"));
            orderIndex++;
        }
    }else if(doAction.equals("moveUpField")&&srcOrder!=null){
        for(int i=0; i<srcOrder.length;i++){
            String sql = "select id,dsporder from workflow_billfield where billid="+id+" and dsporder<="+srcOrder[i]+" order by dsporder desc";
            String idone = null;
            String idtwo = null;
            String dspone = null;
            String dsptwo = null;

            rs.executeSql(sql);
            if(rs.next()){
                idone = rs.getString("id");
                dspone = rs.getString("dsporder");
            }
            if(rs.next()){
                idtwo = rs.getString("id");
                dsptwo = rs.getString("dsporder");
            }

            if(idone!=null&&idtwo!=null){
                rs.executeSql("update workflow_billfield set dsporder="+dsptwo+" where id="+idone);
                rs.executeSql("update workflow_billfield set dsporder="+dspone+" where id="+idtwo);
            }
        }
    }else if(doAction.equals("moveDownField")&&srcOrder!=null){
        for(int i=srcOrder.length-1; i>=0;i--){
            String sql = "select id,dsporder from workflow_billfield where billid="+id+" and dsporder>="+srcOrder[i]+" order by dsporder";
            String idone = null;
            String idtwo = null;
            String dspone = null;
            String dsptwo = null;

            rs.executeSql(sql);
            if(rs.next()){
                idone = rs.getString("id");
                dspone = rs.getString("dsporder");
            }
            if(rs.next()){
                idtwo = rs.getString("id");
                dsptwo = rs.getString("dsporder");
            }

            if(idone!=null&&idtwo!=null){
                rs.executeSql("update workflow_billfield set dsporder="+dsptwo+" where id="+idone);
                rs.executeSql("update workflow_billfield set dsporder="+dspone+" where id="+idtwo);
            }
        }
    }

%>
<%
        WorkFlowBillUtil wf = new WorkFlowBillUtil();
	String indexdesc="";
	indexdesc = Util.toScreen(request.getParameter("indexdesc"),user.getLanguage(),"0");
	String sql = "select * from workflow_bill where id = "+id;
	rs.executeSql(sql);
	String insertSql = "";
	String insertFieldSql="";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<script language="javascript">
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 工作流单据</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=workflowbillViewform method=post action="WorkflowbillOperation.jsp">
  <input type="hidden" name="doAction">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editworkflowbill()"><U>E</U>-编辑</BUTTON>
<%if(Util.getIntValue(user.getSeclevel(),0)>=20){%>
	<BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteworkflowbill()"><U>D</U>-删除</BUTTON>
	<BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="back()"><U>D</U>-返回</BUTTON>
        <input type=hidden name=operation>
        <input type=hidden name=id value="<%= id %>">
<%}%>
       <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewSQL()"><U>E</U>-导出SQL</BUTTON>
       <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewCreateSQL()"><U>E</U>-导出创建表SQL</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
          <TR class=Section>
            <TH colSpan=5>单据信息</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep1 colSpan=5></TD>
          </TR>
<%
while(rs.next()){
int namelabel =Util.getIntValue(rs.getString("namelabel"),0);
indexdesc = Util.null2String(wf.getLabelByLabelId(namelabel));
String tablename = Util.null2String(rs.getString("tablename"));
String createpageUrl = Util.null2String(rs.getString("createpage"));
String managepageUrl = Util.null2String(rs.getString("managepage"));
String viewpageUrl = Util.null2String(rs.getString("viewpage"));
String operationpage = Util.null2String(rs.getString("operationpage"));
String detailtablename = Util.null2String(rs.getString("detailtablename"));
String detailkeyfield = Util.null2String(rs.getString("detailkeyfield"));

insertSql = "INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield)  VALUES("+id+","+namelabel+",'"+tablename+"','"+createpageUrl+"','"+managepageUrl+"','"+viewpageUrl+"','"+detailtablename+"','"+detailkeyfield+"') <br>";

%>
          <TR>
            <TD>单据</TD>
            <TD Class=Field><%=id%></TD>
            <input type=hidden name=id value="<%=id%>">
          </TR>
          <TR>
            <TD>描叙</TD>
            <TD Class=Field><%=indexdesc%></TD>
          </TR>
          <TR>
            <TD>主数据库表名</TD>
            <TD Class=Field><%=tablename%></TD>
          </TR>
          <TR>
            <TD>新建页面</TD>
            <TD Class=Field><%=createpageUrl%></TD>
          </TR>
          <TR>
            <TD>查看页面</TD>
            <TD Class=Field><%=viewpageUrl%></TD>
          </TR>
          <TR>
            <TD>编辑页面</TD>
            <TD Class=Field><%=managepageUrl%></TD>
          </TR>
          <TR>
            <TD>后台处理页面</TD>
            <TD Class=Field><%=operationpage%></TD>
          </TR>
          <TR>
            <TD>附表名</TD>
            <TD Class=Field><%=detailtablename%></TD>
          </TR>
          <TR>
            <TD>主附表关联字段</TD>
            <TD Class=Field><%=detailkeyfield%></TD>
          </TR>
<%
}
%>
          </TBODY>
        </TABLE>
        <br>
        <TABLE class=Form>
          <COLGROUP>
            <COL width="3%">
            <COL width="8%">
            <COL width="20%">
            <COL width="18%">
            <COL width="15%">
            <COL width="12%">
            <COL width="7%">
            <COL width="7%">
            <COL width="11%">
          <TBODY>
          <TR class=Section>
            <TH colSpan=5>单据名称</TH>
          </TR>
          <TR>
            <BUTTON class=btn id=btnAddfield accessKey=A name=btnAddfield onclick="addworkflowbillfield()">添加字段</BUTTON>
            <BUTTON class=btn id=btnMoveUp accessKey=U name=btnMoveUp onclick="moveUpField()">上移字段</BUTTON>
            <BUTTON class=btn id=btnMoveDown accessKey=D name=btnMoveDown onclick="moveDownField()">下移字段</BUTTON>
            <BUTTON class=btn id=btnDoOrder accessKey=D name=btnDoOrder onclick="doFieldOrder()">重整顺序</BUTTON>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=9></TD>
          </TR>
          <TR>
            <td Class=Field></td>
            <Td Class=Field>字段编号</Td>
            <Td Class=Field>字段名称</Td>
            <Td Class=Field>字段显示</Td>
            <Td Class=Field>字段数据库类型</Td>
            <Td Class=Field>字段显示类型</Td>
            <Td Class=Field>字段类型</Td>
            <Td Class=Field>字段顺序</Td>
            <Td Class=Field>字段所属表类型</Td>
          </TR>

<%
  sql = "select distinct workflow_billfield.*,HtmlLabelIndex.id as indexid,HtmlLabelIndex.indexdesc as indexdesc from workflow_billfield left join HtmlLabelIndex on HtmlLabelIndex.id = fieldlabel where billid = "+id+"order by workflow_billfield.dsporder";
  rs.executeSql(sql);
  String viewtype = "";
  int orderIndex = 0;
  while(rs.next()){
  String name = Util.null2String(rs.getString("fieldname"));
  int fieldlabel = Util.getIntValue(rs.getString("indexid"),0);
  String dbtype = Util.null2String(rs.getString("fielddbtype"));
  int htmltype_int = Util.getIntValue(rs.getString("fieldhtmltype"),0);
  int htmltype = wf.getHtmlType(htmltype_int);
  int type_int = Util.getIntValue(rs.getString("type"),0);
  int type = wf.getType(htmltype_int,type_int);
  int dsporder = Util.getIntValue(rs.getString("dsporder"),0);
  int viewtype_int = Util.getIntValue(rs.getString("viewtype"),0);
  if(viewtype_int==0){
    viewtype = "main table";
  }else{
    viewtype = "detailtable";
  }
  insertFieldSql += "INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype,  fieldhtmltype, type, dsporder, viewtype) VALUES ("+id+",'"+name+"',"+fieldlabel+",'"+dbtype+"',"+htmltype_int+","+type_int+","+dsporder+","+viewtype_int+")<br>";
%>
	<TR>
        <td>
            <input type="checkbox" name="editorder" value=<%=Util.getIntValue(rs.getString("dsporder"),0)%>>
        </td>
	   <Td><a href="ViewWorkflowbillfield.jsp?id=<%=Util.getIntValue(rs.getString("id"),0)%>"><%= Util.getIntValue(rs.getString("id"),0)%></a></Td>
	   <Td><%= name%></Td>
	   <Td><a href="ViewWorkflowbillfield.jsp?id=<%=Util.getIntValue(rs.getString("id"),0)%>"><%= Util.null2String(rs.getString("indexdesc"))%></a></Td>
	   <Td><%=dbtype%></Td>
	   <Td><%=Util.null2String(SystemEnv.getHtmlLabelName(htmltype,user.getLanguage()))%></Td>
	   <Td><%=Util.null2String(SystemEnv.getHtmlLabelName(type,user.getLanguage()))%></Td>
	   <Td><%= dsporder%></Td>
	   <Td><%=viewtype%></Td>
	</TR>
<%
      orderIndex++;
   }
%>
        <input type=hidden name=insertFieldSql value="<%=insertFieldSql%>">
        <input type=hidden name=insertSql value="<%=insertSql%>">
</tbody>
</FORM>
<script>
    function editworkflowbill(){
        location = "EditWorkflowbill.jsp?id=<%=id%>&indexdesc=<%= indexdesc%>";
    }
    function deleteworkflowbill(){
      if(confirm("do you sure to delete the workflow_bill?")){
        document.workflowbillViewform.operation.value = "delete";
        document.workflowbillViewform.submit();
      }
    }
    function back(){
        location = "ManageWorkflowbill.jsp";
    }
    function viewCreateSQL(){
    	location = "ViewCreateSql.jsp?id=<%=id%>&indexdesc=<%= indexdesc%>";
    }
    function viewSQL(){
    	location = "ViewSql.jsp?id=<%=id%>&indexdesc=<%= indexdesc%>";
    }
    function addworkflowbillfield(){
        location = "AddWorkflowbillfield.jsp?id=<%=id%>";
    }
    function moveUpField(){
        if(!isCheck()){
            return;
        }
        workflowbillViewform.action="";
        workflowbillViewform.doAction.value="moveUpField";
        workflowbillViewform.submit();
    }
    function moveDownField(){
        if(!isCheck()){
            return;
        }
        workflowbillViewform.action="";
        workflowbillViewform.doAction.value="moveDownField";
        workflowbillViewform.submit();
    }
    function doFieldOrder(){
        workflowbillViewform.action="";
        workflowbillViewform.doAction.value="doFieldOrder";
        workflowbillViewform.submit();
    }
    function isCheck(){
        var checkFlag = false;
        for(i=0;i<workflowbillViewform.editorder.length;i++){
            if(workflowbillViewform.editorder[i].status){
                checkFlag = true;
                break;
            }
        }
        if(!checkFlag){
            alert("必须选择一个或多个需要移动的字段");
            return false;
        }
        return true;
    }

</script>
</BODY>
</HTML>
