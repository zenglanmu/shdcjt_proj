<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>

<%!
    /**
     * Added by Charoes Huang On May 19,
     * @param typeid
     * @return  a boolean value
     */
    private boolean canDelete(int typeid){
        boolean canDelete =true;
        String sqlStr ="Select COUNT(*) AS COUNT FROM HrmAwardInfo WHERE rptypeid ="+typeid;
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlStr);
        if(rs.next()){
            if(rs.getInt("COUNT") > 0)
                canDelete = false;
        }
        return canDelete;
    }
%>
<%
String id = request.getParameter("id");

boolean canDelete = canDelete(Integer.valueOf(id).intValue());
String name="";
String description="";
String transact="" ;
int awardtype=0;
RecordSet.executeProc("HrmAwardType_SByid",id);
RecordSet.next();
name = RecordSet.getString("name");
awardtype =RecordSet.getInt("awardtype");
description = Util.toScreenToEdit(RecordSet.getString("description"),user.getLanguage());
transact = Util.toScreenToEdit(RecordSet.getString("transact"),user.getLanguage());

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6099,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/award/HrmAwardTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
 if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
 }
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/award/HrmAwardType.jsp,_self} " ;
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

<FORM id=frmMain name=frmMain action="HrmAwardTypeOperation.jsp" method=post>
<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>

<TABLE class=ViewFORM>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%>
      </TH>
  </TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1></TD>
  </TR>
  <TR>
  <TD vAlign=top>
  <TABLE class=ViewFORM>
  <COLGROUP> <COL width="15%"><COL width="85%">
   <TBODY>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></TD>
      <TD class=Field><%if(canEdit){%>
      <input class=inputstyle maxLength=60 type=text size=30 name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
      <%}else{%><%=name%><%}%>
      <SPAN id=nameimage></SPAN></TD>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></td>
    <td class=Field>
      <select class=inputstyle name=awardtype value="0">
        <option value="0"><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
       <%if(awardtype==1){%>
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
      <%}else{%>
         <option value="1"><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
	  <%}%>
	  </select>
    </td>
    </tr>
    
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></TD>
      <TD class=Field> <%if(canEdit){%>
      <TEXTAREA class=inputstyle style="WIDTH: 50%" name="description" rows=6><%=description%></TEXTAREA><%}else{%><%=description%><%}%>
      <SPAN id=descriptionimage></SPAN></TD>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
      <TD class=Field> <%if(canEdit){%>
      <TEXTAREA class=inputstyle style="WIDTH: 50%" name="transact" rows=6><%=transact%></TEXTAREA><%}else{%><%=transact%><%}%>
      <SPAN id=transact></SPAN></TD>
    </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
 </TBODY>
 </TABLE>
 </TD>
   <input class=inputstyle type="hidden" name=operation value="edit">
   <input class=inputstyle type="hidden" name=id value="<%=id%>">
 </form>
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
 <script language=javascript>
 function onSave(){
    var maxlength = 100;
	if(check_form(frmMain,'name')&&checkTextLength(frmMain.description,maxlength)&&checkTextLength(frmMain.transact,maxlength)){

		document.frmMain.submit();
	}
 }

 function onDelete(){
		  <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.frmMain.operation.value = "delete";
      document.frmMain.submit();
    }
	<%}else{%>
			alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
}
function checkTextLength(textObj,maxlength){
    var len = trim(textObj.value).length
    if(len >  maxlength){
        alert("文本筐的文本长度不能超过"+maxlength);
        return false;
    }
    return true;
  }
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}

 </script>
</BODY>
</HTML>