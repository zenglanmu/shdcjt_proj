<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
int uid=user.getUID();
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0);
String workflowsingle=(String)session.getAttribute("workflowsingle");
        if(workflowsingle==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("workflowsingle"+uid)){
        workflowsingle=cks[i].getValue();
        break;
        }
        }
        }
String tabid="1";
if(workflowsingle!=null&&workflowsingle.length()>0){
String[] atts=Util.TokenizerString2(workflowsingle,"|");
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
  <td  height=30 colspan=2 background="/images/tab/bg1.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1.gif" width=15px height=100% align=center></td> 
  
  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1)" ><b><%=SystemEnv.getHtmlLabelName(18413,user.getLanguage())%></b></td>
 
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>
  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=40%>

<IFRAME name=frame1 id=frame1   width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=60%>

<IFRAME name=frame2 id=frame2 src="/workflow/workflow/WorkflowSelect.jsp?tabid=1&isTemplate=<%=isTemplate%>" width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){

		for(i=1;i<=2;i++){
			document.all("oTDtype_"+i).background="/images/tab/bgdark.gif";
		}
		document.all("oTDtype_"+objid).background="/images/tab/bglight.gif";
		if(objid == 1 ){
		        window.frame1.location="/workflow/workflow/WorkflowBrowser1.jsp?isTemplate=<%=isTemplate%>";	
		        try{
			window.frame2.btnsub.style.display="none"
			}catch(err){}
		        }		
		else if(objid == 2){
			window.frame1.location="/workflow/workflow/WorkflowSearch.jsp?isTemplate=<%=isTemplate%>";
			try{
			window.frame2.btnsub.style.display="inline"
			}catch(err){}
			}
	}

resetbanner(<%=tabid%>);
</script>

</body>
</html>