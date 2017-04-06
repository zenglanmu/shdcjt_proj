<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<html>
  <head>
  <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language=javascript>
        function mnToggleleft()
        {
            var o = window.parent.sysRemindInfoFrameSet;
            if(o.cols=="180,*")
            {
                o.cols = "10,*"; LeftHideShow.src = "/cowork/images/hide.gif"; LeftHideShow.title = '<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>';
            }
            else
            {
                o.cols = "180,*"; LeftHideShow.src = "/cowork/images/show.gif"; LeftHideShow.title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>';
            }
        }
    </SCRIPT>   
  </head>
  
  <BODY>
    <table width=100% height="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td width="100%">
          <TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <COLGROUP>
              <COL width="5">
              <COL width="">
            </COLGROUP>
            <TR bgcolor="#DFDFDF">
              <TD height="5" colspan="2"></TD>
            </TR>
            <TR>              
              <TD bgcolor="#DFDFDF"></TD>
              <TD>              
                <IFRAME name=treeFrame id=treeFrame src="SysRemindInfoTreeDetail.jsp" width="100%" height="100%" frameborder=no>
                     浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
                </IFRAME>
              </TD>
            </TR>
          </TABLE>
        </td>
        <td style="background-color:#DFDFDF" align=left valign=center >
          <IMG id=LeftHideShow name=LeftHideShow title=<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%> style="CURSOR: pointer;"  src="/cowork/images/show.gif" onclick="mnToggleleft()"/>
        </td>
      </tr>
    </table>
  </BODY>
<style type="text/css">
 body{
 	margin: 0!important;
 }
</style>
</html>