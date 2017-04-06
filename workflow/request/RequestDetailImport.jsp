<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*," %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%

    int requestid = Util.getIntValue(request.getParameter("requestid"));
    int workflowid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"workflowid"),0);
    String ismode="";
    int modeid=0;
    int nodeid = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "nodeid"));
    boolean hasright=RequestDetailImport.getImportRight(requestid,nodeid,user.getUID());
    if(!hasright){
        response.sendRedirect("/notice/noright.jsp");
        return ;
    }
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(648, user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(26255, user.getLanguage());
    String needfav = "";
    String needhelp = "";
    ExcelSheet es = null;
    String workflowname="";
    int formid=-1;
    int isbill=0;
    String sql="select formid,isbill,workflowname from workflow_base where isImportDetail='1' and id=" + workflowid;
    RecordSet.executeSql(sql);
    if (RecordSet.next()) {
        formid = RecordSet.getInt("formid");
        isbill = RecordSet.getInt("isbill");
        workflowname=RecordSet.getString("workflowname")+SystemEnv.getHtmlLabelName(64, user.getLanguage());
        ArrayList editfields=new ArrayList();
        int showdes=0;
        RecordSet.executeSql("select ismode,showdes,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
        if (RecordSet.next()) {
            ismode = Util.null2String(RecordSet.getString("ismode"));
            showdes = Util.getIntValue(Util.null2String(RecordSet.getString("showdes")), 0);
        }
        if (ismode.equals("1") && showdes != 1) {
            RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid=" + workflowid + " and nodeid=" + nodeid);
            if (RecordSet.next()) {
                modeid = RecordSet.getInt("id");
            } else {
                RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid=" + formid + " and isbill='" + isbill + "'");
                if (RecordSet.next()) {
                    modeid = RecordSet.getInt("id");
                }
            }
        }
        if(ismode.equals("1")&&modeid>0){
            sql="select fieldid from workflow_modeview where isedit='1' and formid=" + formid+" and isbill="+isbill+" and nodeid="+nodeid;
        }else{
            sql="select fieldid from workflow_nodeform where isedit='1' and nodeid="+nodeid;
        }
        RecordSet.executeSql(sql);
        while(RecordSet.next()){
            editfields.add("field"+RecordSet.getString("fieldid"));
        }
        ExcelFile.init() ;
        ExcelFile.setFilename(workflowname) ;
        ExcelStyle ess = ExcelFile.newExcelStyle("Header") ;
        ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
        ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
        ess.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
        ess.setAlign(ExcelStyle.WeaverHeaderAlign) ;

        FieldInfo.setRequestid(requestid);
        FieldInfo.setUser(user);
        FieldInfo.GetDetailTableField(formid, isbill, user.getLanguage());
        ArrayList detailtablefieldlables=FieldInfo.getDetailTableFieldNames();
        ArrayList detailtablefieldids=FieldInfo.getDetailTableFields();
        for(int i=0;i<detailtablefieldlables.size();i++){
            es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
            ExcelRow er = es.newExcelRow () ;  //准备新增EXCEL中的一行
            ArrayList detailfieldnames=(ArrayList)detailtablefieldlables.get(i);
            ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
            boolean hasfield=false;
            for(int j=0;j<detailfieldids.size();j++){
                if(editfields.indexOf((String)Util.TokenizerString((String)detailfieldids.get(j),"_").get(0))<0) continue;
                //以下为EXCEL添加多个列
                es.addColumnwidth(6000);
                er.addStringValue((String)detailfieldnames.get(j),"Header");
                hasfield=true;
            }
            if(hasfield){
                es.addExcelRow(er) ;   //加入一行
                ExcelFile.addSheet(SystemEnv.getHtmlLabelName(17463, user.getLanguage())+(i+1), es) ; //为EXCEL文件插入一个SHEET
            }
        }
    }

%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(26255, user.getLanguage()) + ",javascript:onSave(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:onClose(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<form name="detailimportform" method="post" action="RequestDetailImportOperation.jsp" enctype="multipart/form-data">
<input type=hidden name="requestid" value="<%=requestid%>">
<input type=hidden name="ismode" value="<%=ismode%>">
<input type=hidden name="modeid" value="<%=modeid%>">
<input type=hidden name="formid" value="<%=formid%>">
<input type=hidden name="isbill" value="<%=isbill%>">
<input type=hidden name="nodeid" value="<%=nodeid%>">
<input type="hidden" value="save" name="src">
<TABLE class=viewform cellspacing=1 id="freewfoTable" width="100%">
<colgroup>
    <col width="20%">
    <col width="80%">
<TBODY>
<TR>
    <TD>1、<%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%></TD>
    <TD class="Field"><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=workflowname%></a></TD>
</TR>
<TR class="Spacing">
    <TD class="Line" colspan="2"></TD>
</TR>
<TR>
    <TD>2、<%=SystemEnv.getHtmlLabelName(16630, user.getLanguage())%></TD>
    <TD class="Field"><input type="file" name="excelfile" size="35"></TD>
</TR>
<TR class="Spacing">
    <TD class="Line1" colspan="2"></TD>
</TR>
<TR>
    <TD colspan="2">
        <br><b><%=SystemEnv.getHtmlLabelName(27577, user.getLanguage())%>：</b><br>
        1）<%=SystemEnv.getHtmlLabelName(27578, user.getLanguage())%><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=workflowname%></a><%=SystemEnv.getHtmlLabelName(27579, user.getLanguage())%><br>
        2）<%=SystemEnv.getHtmlLabelName(27580, user.getLanguage())%>“<%=SystemEnv.getHtmlLabelName(26255, user.getLanguage())%>”。<br><br>
        <b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br>
        1）<%=SystemEnv.getHtmlLabelName(27582, user.getLanguage())%><br>
        2）<%=SystemEnv.getHtmlLabelName(27583, user.getLanguage())%><br>
        3）<%=SystemEnv.getHtmlLabelName(27584, user.getLanguage())%><br>
        4）<%=SystemEnv.getHtmlLabelName(27585, user.getLanguage())%><br>
        5）<%=SystemEnv.getHtmlLabelName(27586, user.getLanguage())%><br>
        6）<%=SystemEnv.getHtmlLabelName(27587, user.getLanguage())%><br>
        7）<%=SystemEnv.getHtmlLabelName(27588, user.getLanguage())%><br>
        8）<%=SystemEnv.getHtmlLabelName(27589, user.getLanguage())%><br>
        9）<%=SystemEnv.getHtmlLabelName(27590, user.getLanguage())%><br>
		10）<%=SystemEnv.getHtmlLabelName(27635, user.getLanguage())%>
    </TD>
</TR>
</TBODY>
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

<script language=javascript>
    function onSave(obj) {
        var fileName=$G("excelfile").value;
		if(fileName!=""&&fileName.length>4){
			if(fileName.substring(fileName.length-4).toLowerCase()!=".xls"){
				alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
				return;
			}
			$G("detailimportform").submit();//上传文件
            obj.disabled=true;
		}else{
            alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
        }
    }


    function onClose() {
        window.parent.close();
    }

</script>
</body>
</html>
