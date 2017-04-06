<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
    int doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0);
    String usertype = Util.null2String(request.getParameter("usertype"));
    if(doccreaterid==0){
        doccreaterid = user.getUID();
        usertype = "1";
    }

    String sql = "";
    int shareToCount = 0;
    int shareFromCount = 0;
    int replySubjectCount = 0;
    int replyCount = 0;

    sql = "select count(distinct id) from DocDetail  t1, "+tables+"  t2  where t1.docstatus in ('1','2','5')  and t1.id=t2.sourceid and t1.ownerid="+doccreaterid+" and t1.usertype='"+usertype+"'";
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        shareToCount = RecordSet.getInt(1);
    }

    sql = "select count(distinct id) from DocDetail  t1, "+tables+"   t2  where t1.docstatus in ('1','2','5')  and t1.id=t2.sourceid  and t1.doccreaterid!="+doccreaterid;
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        shareFromCount = RecordSet.getInt(1);
    }

    sql = "select COUNT(replydocid) from DocDetail d1 where docstatus in ('1','2','5') and ownerid="+doccreaterid+" and usertype="+usertype+" and isreply='1' and not exists (select * from docdetail where id=d1.replydocid and ownerid=d1.ownerid and usertype=d1.usertype)";
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        replySubjectCount = RecordSet.getInt(1);
    }

    sql = "select COUNT(*) from DocDetail where docstatus in ('1','2','5') and ownerid="+doccreaterid+" and usertype="+usertype+" and isreply='1'";
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        replyCount = RecordSet.getInt(1);
    }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdDOC.gif";
    String titlename = SystemEnv.getHtmlLabelName(16396,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

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

<form name=docshare action="" method="post">
<TABLE class=viewform width="100%">
  <TBODY>
  <TR class=title>
    <TH width="20%">
    <%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:
    <button type="button" class=Browser onClick="onShowResource('doccreateridspan','doccreaterid')"></button>
    <span id=doccreateridspan>
    <%if(doccreaterid!=0 && !usertype.equals("2") ){%>
    <%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>
    <%}%>
    </span>
    </TH>
    <TH width="80%">

    </TH>
  </TR>
<input type="hidden" name="doccreaterid" value="<%=doccreaterid%>">
<input type="hidden" name="usertype" value="<%=usertype%>">
 </TBODY></TABLE>
<TABLE class=liststyle cellspacing=1  width="100%">
  <COLGROUP>
  <COL align=left width="70%">
  <COL align=left width="30%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
  </TR>
<TR class=line ><Th colspan=2></TR>
  <TR class=datadark>
    <TD><%=SystemEnv.getHtmlLabelName(18478,user.getLanguage())%></TD>
    <TD>
    <a href="DocShareList.jsp?sharetype=1&doccreaterid=<%=doccreaterid%>&usertype=<%=usertype%>"><%=shareToCount%></a>
    </TD>
  </TR>

  <TR class=datalight>
    <TD><%=SystemEnv.getHtmlLabelName(18479,user.getLanguage())%></TD>
    <TD>
    <a href="DocShareList.jsp?sharetype=2&doccreaterid=<%=doccreaterid%>&usertype=<%=usertype%>"><%=shareFromCount%></a>
    </TD>
  </TR>

  <TR class=datadark>
    <TD><%=SystemEnv.getHtmlLabelName(18490,user.getLanguage())%></TD>
    <TD>
    <a href="DocShareList.jsp?sharetype=3&doccreaterid=<%=doccreaterid%>&usertype=<%=usertype%>"><%=replySubjectCount%></a>
    </TD>
  </TR>

  <TR class=datalight>
    <TD><%=SystemEnv.getHtmlLabelName(18491,user.getLanguage())%></TD>
    <TD>
    <a href="DocShareList.jsp?sharetype=4&doccreaterid=<%=doccreaterid%>&usertype=<%=usertype%>"><%=replyCount%></a>
    </TD>
  </TR>

  <TR class=line ><Th colspan=2></TR>

  </TBODY></TABLE>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language="javascript">

function onShowResource(tdname,inputename){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(id){
        clearData();
	    if (id.id!= ""){
            $("#"+tdname).text(id.name);
            $("input[name="+inputename+"]").val(id.id);
            $("input[name=usertype").val("1");
		}else{
              $("#"+tdname).text("");
            $("input[name="+inputename+"]").val("");
            $("input[name=usertype").val("");
		}
         document.all["docshare"].submit();
	}
}

function clearData(){
	$("#doccreateridspan").text("");
	$("input[name=doccreaterid]").val("");
	$("input[name=usertype").val("0");
}
function onShowParent(tdname,inputename){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if(id){
        clearData();
	    if (id.id!= ""){
            $("#"+tdname).text(id.name);
            $("input[name="+inputename+"]").val(id.id);
            $("input[name=usertype").val("1");
		}else{
              $("#"+tdname).text("");
            $("input[name="+inputename+"]").val("");
            $("input[name=usertype").val("");
		}
        document.all["docshare"].submit();
	}
}

</script>
</body>
</html>