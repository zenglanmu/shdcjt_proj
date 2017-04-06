<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(16259 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
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
<FORM id=frmMain name=frmMain action="HrmInTimecardOperation.jsp" method=post enctype="multipart/form-data">
<DIV>
<BUTTON class=btnSave type="button" accessKey=S onClick="dosubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></BUTTON>
</DIV>
<br>
  <table class=Viewform>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <tbody> 
    <tr class=Title> 
      <td><nobr><b><%=SystemEnv.getHtmlLabelName(16698,user.getLanguage())%></b></td>
      <td align=right></td>
    </tr>
    <tr class=spacing style="height:2px"> 
      <td class=Line1 colspan=2></td>
    </tr>
    <tr class=spacing> 
      <td colspan=2 height=8></td>
    </tr>
    <tr class=spacing> 
      <td><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></td>
      <td class=Field>
        <input class=inputstyle type="file" name="excelfile">
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </tbody> 
  </table>  
</form>

  <br>
  <table class=viewform>
    <COLGROUP> <COL width="20%"> <COL width="80%"><tbody> 
    <tr > 
      <td colspan=2><nobr><b>导入模板及注意事项</b></td>
    </tr>
   <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
   <tr> 
      <td>请点击右键用'另存为'下载</td>
      <td><a href='/hrm/schedule/inputexcellfile/input.xls'>导入文件Excel模板</a>&nbsp;</td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td>注意事项</td>
      <td>
       1、打卡数据必须填入导入文件Excel模板的第一个sheet中。<br><br>
       2、模板中的第一行为标题行，不能占用。数据必须从第二行开始，中间不能有空行<br><br>
       3、导入数据的Excel中每一个数据格的格式必须为字符型<br><br>
       4、卡号必须和打卡用户接口中的卡号一致，否则将被认为无效数据，不被导入。<br><br>
       5、打卡日期的格式为excel的日期格式，如（2003-9-13、2003-12-4），打卡时间的格式为excel的时间格式，如（5:31、14:04）。<br><br>
       6、同一数据可导入多次，系统会自动排除相同的数据。
      </td>
    </tr> 
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
    </tbody> 
  </table>
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
function dosubmit() {
    if(check_form(document.frmMain,'excelfile')) {
        document.frmMain.submit() ;
    }
}
</script>
</BODY>
</HTML>