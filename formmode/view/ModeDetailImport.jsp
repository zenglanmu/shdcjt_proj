<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*," %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page"/>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(26255, user.getLanguage());
    String needfav = "";
    String needhelp = "";
    
    int modeId = Util.getIntValue(request.getParameter("modeId"),0);
    int billid = Util.getIntValue(request.getParameter("billid"),0);
    String modename = "";
    int formId = 0;
    if(modeId > 0){
    	rs.executeSql("select * from modeinfo where Id="+modeId);
    	if(rs.next()){
    		formId = rs.getInt("formid");
    		modename = Util.null2String(rs.getString("modename"));
    		
    		ArrayList editfields=new ArrayList();//可编辑字段
    		
    		rs.executeSql("select fieldid from modeformfield where modeid="+modeId+" and type=2 and isedit=1");
    		while(rs.next()){
    			editfields.add("field"+rs.getString("fieldid"));
    		}
    		ExcelSheet es = null;
    		ExcelFile.init() ;
    		ExcelFile.setFilename(modename) ;
    		ExcelStyle ess = ExcelFile.newExcelStyle("Header") ;
    		ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
            ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
            ess.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
            ess.setAlign(ExcelStyle.WeaverHeaderAlign) ;
            
            FieldInfo.setUser(user);
            FieldInfo.GetDetailTableField(formId, 1, user.getLanguage());
            ArrayList detailtablefieldlables=FieldInfo.getDetailTableFieldNames();
            ArrayList detailtablefieldids=FieldInfo.getDetailTableFields();
            for(int i=0;i<detailtablefieldlables.size();i++){
                es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
                ExcelRow er = es.newExcelRow () ;  //准备新增EXCEL中的一行
                ArrayList detailfieldnames=(ArrayList)detailtablefieldlables.get(i);
                ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
                boolean hasfield=false;
                for(int j=0;j<detailfieldids.size();j++){
                	//System.out.println(" ="+(String)Util.TokenizerString((String)detailfieldids.get(j),"_").get(0));
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
<form name="detailimportform" method="post" action="ModeDetailImportOperation.jsp" enctype="multipart/form-data">
<input type=hidden name="modeId" value="<%=modeId%>">
<input type=hidden name="formId" value="<%=formId%>">
<input type=hidden name="billid" value="<%=billid%>">
<input type="hidden" value="save" name="src">
<TABLE class=viewform cellspacing=1 id="freewfoTable" width="100%">
<colgroup>
    <col width="20%">
    <col width="80%">
<TBODY>
<TR>
    <TD>1、<%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%></TD>
    <TD class="Field"><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=modename%></a></TD>
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
        1）<%=SystemEnv.getHtmlLabelName(27578, user.getLanguage())%><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=modename%></a><%=SystemEnv.getHtmlLabelName(27579, user.getLanguage())%><br>
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
