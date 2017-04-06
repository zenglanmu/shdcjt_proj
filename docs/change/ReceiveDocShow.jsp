<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SptmForDoc" class="weaver.splitepage.transform.SptmForDoc" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Receive", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String id = Util.null2String(request.getParameter("id"));
String docid = "";
String attid = "";
rs.executeSql("select docid,fileids from DocChangeReceive where id="+id);
if(rs.next()) {
	docid = rs.getString("docid");
	attid = rs.getString("fileids");
}
%>
<iframe src="/docs/docs/DocDsp.jsp?id=<%=docid%>" height="80%" width="100%"></iframe>

<TABLE class=ListStyle cellspacing=1>
<COLGROUP>
<COL width="30">
<COL width="150">
<COL width="200">
<COL>
<COL width="100">
	<TR class=Title>
	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH>
	</TR>
	<TR class=Spacing>
	  <TD class=Line1 colSpan=3></TD>
	</TR>
<!--TR class=Header>
<TH colspan="2">&nbsp;<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH>
</TR>
<TR class=Line>
<TD colSpan=3></TD>
</TR-->
<%
if(!attid.equals("")) {
%>
	<tr>
      <td >&nbsp;<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
      <td class=field style="TEXT-VALIGN: center">
          <table cols=3 id="field444_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
<%
	//attid = attid.substring(0, attid.length()-1);
	String sql = "select t1.id,t3.imagefileid,t3.filesize ";
	sql += "from docdetail t1, docimagefile t2, imagefile t3 ";
	sql += "where t1.id=t2.docid and t2.imagefileid=t3.imagefileid ";
	sql += "and t3.imagefileid in("+attid+")";
	rs.executeSql(sql);
	while(rs.next()) {
		String attdocid = rs.getString("id");
		String attimagefileid = rs.getString("imagefileid");
		int attfilesize = rs.getInt("filesize")/1024;
%>
    <tr>
    <td colspan=3>
    <%=SptmForDoc.getDocIcon(rs.getString("id")) %>
      <a href="/docs/docs/DocDsp.jsp?id=<%=attdocid%>"><%=DocComInfo.getDocname(attdocid)%></a>&nbsp
      <span id = "selectDownload">
        <button type="button" class=btnFlowd accessKey=1  onclick="downloads('<%=attimagefileid%>')">
        <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=attfilesize%>KB)
        </button>
      </span>
    </td>
    </tr>
<%
	}
}
%>
         </tbody>
         </table>
      </td>
    </tr>
    <tr><td class=Line2 colSpan=2></td></tr>
</TABLE>
<script>
function downloads(id){
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+id+"&download=1";
}
</script>