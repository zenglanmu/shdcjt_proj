<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%
String strKeyword=Util.null2String(request.getParameter("strKeyword"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));

int uid=user.getUID();
    String resourcemulti = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {

        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }

    String tabid="0";
if(resourcemulti!=null&&resourcemulti.length()>0){
String[] atts=Util.TokenizerString2(resourcemulti,"|");
tabid=atts[0];

}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>


</HEAD>
<body>



<TABLE class=form width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  </colgroup>
  <TBODY>
  <tr>
  <td  height=30 colspan=3 background="/images/tab/bg1.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1.gif" width=15px height=100% align=center></td> 
  
  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight.gif" width=70px height=95% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0)" ><b><%=SystemEnv.getHtmlLabelName(381,user.getLanguage())%></b></td>
  
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab/bglight.gif" width=70px height=95% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>
  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=35%>

<IFRAME name=frame1 id=frame1  width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=65%>

<IFRAME name=frame2 id=frame2 src="/docs/sendDoc/WorkflowKeywordBrowserMultiSelect.jsp?tabid=<%=tabid%>&strKeyword=<%=strKeyword%>&sqlwhere=<%=sqlwhere%>" width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
function resetbanner(objid){
		
	//$G("oTDtype_0").background="/images/tab/bgdark.gif";
	//$G("oTDtype_2").background="/images/tab/bgdark.gif";
	//$G("oTDtype_"+objid).background="/images/tab/bglight.gif";
	
	//2012-08-17 ypc 修改 start 由于以上的写法导致样式显示异常
	for(i=0;i<=2;i++){ //把 此循环 i<=2 就可以啦！ypc 2012-08-20 修改
	  $("#oTDtype_"+i).attr("background","/images/tab/bgdark.gif");
	}
	$("#oTDtype_"+objid).attr("background","/images/tab/bglight.gif");
	//2012-08-17 ypc 修改 end
	
	if(objid == 0 ){		        
        window.frame1.location="/docs/sendDoc/WorkflowKeywordBrowserMultiSearchByOrgan.jsp?sqlwhere=<%=sqlwhere%>";
        try{
        	$G("btnsub", $G("frame2").contentWindow.document).style.display="none";
        }catch(err){}
	}else if(objid == 2){
		window.frame1.location="/docs/sendDoc/WorkflowKeywordBrowserMultiSearch.jsp?sqlwhere=<%=sqlwhere%>";
		try{
			$G("btnsub", $G("frame2").contentWindow.document).style.display="inline";
		}catch(err){}
	}
}

resetbanner(<%=tabid%>);
</script>

</body>
</html>