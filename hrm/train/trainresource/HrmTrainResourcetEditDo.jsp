<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmTrainResourceEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = request.getParameter("id");

String name = "";
int type = 1;
String fare = "";
String time = "";
String memo = "";

String sql = "select * from HrmTrainResource where id ="+id;

/*Add by Huang Yu ,Check if train resource has been used by train plan*/
   boolean canDelete =true;
   if(!id.equals("")){
       String sqlstr ="Select count(ID) as Count FROM HrmTrainPlan WHERE planresource = "+id;
       rs.executeSql(sqlstr);
       rs.next();
       if(rs.getInt("Count") > 0 ){
           canDelete = false;
       }
   }

rs.executeSql(sql);
while(rs.next()){
  name = Util.null2String(rs.getString("name"));
  type = Util.getIntValue(rs.getString("type_n"));
  fare = Util.null2String(rs.getString("fare"));
  time = Util.null2String(rs.getString("time"));
  memo = Util.toScreenToEdit(rs.getString("memo"),user.getLanguage());
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6105,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<FORM id=weaver name=frmMain action="TrainResourceOperation.jsp" method=post >
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainResourceEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainresource/HrmTrainResourcetEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(807,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="name" value="<%=name%>" onchange="checkinput('name','nameimage')">
          <SPAN id=nameimage></SPAN>           
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
            <select class=inputstyle name=type value="<%=type%>">
              <option value=1 <%if(type == 1){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
              <option value=0 <%if(type == 0){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
            </select>
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
          <td class=Field >            
            <input class=inputstyle type="text" name="fare" value="<%=fare%>">
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
          <td class=Field>            
            <input class=inputstyle type="text" name="time" value="<%=time%>">
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=memo value="<%=memo%>"><%=memo%></textarea>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
 </form>
 <script language=javascript>
 function doedit(){
  if(check_form(document.frmMain,'name')){
   document.frmMain.operation.value="edit";
   document.frmMain.submit();
  }
 }
 function dodelete(){
   <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.frmMain.operation.value = "delete";
      document.frmMain.submit();
    }
	<%}else{%>
			alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
 }
</script>

 
</BODY></HTML>
