<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%
int uid=user.getUID();
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String jobtitlesingle=(String)session.getAttribute("jobtitlesingle");
String fromPage= Util.null2String(request.getParameter("fromPage")); //来自于那个页面的请求
        if(jobtitlesingle==null){
        Cookie[] cks= request.getCookies();

        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        jobtitlesingle=cks[i].getValue();
        break;
        }
        }
        }
String tabid="0";
if(fromPage.equals("add"))
	tabid="1";
if(jobtitlesingle!=null&&jobtitlesingle.length()>0){
String[] atts=Util.TokenizerString2(jobtitlesingle,"|");
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
<body scroll="no">



<TABLE class=form width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  </colgroup>
  <TBODY>
<%
  if(!fromPage.equals("add")){
%>  
  <tr>
  <td  height=30 colspan=3 background="/images/tab/bg1.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1.gif" width=15px height=100% align=center></td>

  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" ><b><%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%></b></td>

  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>

  <td nowrap name="oTDtype_2"  id="oTDtype_2" height="100%" >&nbsp;</td>
  </tr>
  </table>
  </td>
  </tr>
<%} %>  
<tr>
<td  id=oTd1 name=oTd1 width=100% height=40%>

<IFRAME name=frame1 id=frame1   width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=60%>

<IFRAME name=frame2 id=frame2 src="/hrm/jobtitles/Select.jsp?tabid=<%=tabid%>&sqlwhere=<%=sqlwhere%>&fromPage=<%=fromPage%>" width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){
		for(i=0;i<=1;i++){
			$("#oTDtype_"+i).attr("background","/images/tab/bgdark.gif");
		}
		$("#oTDtype_"+objid).attr("background","/images/tab/bglight.gif");
		
		 var curDoc;
			if(document.all){
				curDoc=window.frames["frame2"].document
			}
			else{
				curDoc=document.getElementById("frame2").contentDocument	
			}
		if(objid == 0 ){
		        window.frame1.location="/hrm/jobtitles/SingleSearchByOrgan.jsp?sqlwhere=<%=sqlwhere%>";
		        try{
			    $(curDoc).find("#btnsub").css("display","none");
		        //2012-08-10 ypc 修改
			    //window.frame2.btnsub.style.display="none"  这种写法 导致在页面切换的时候搜索按钮不会 随页面的切换隐藏
			}catch(err){}
		        }
		else if(objid == 1){
			window.frame1.location="/hrm/jobtitles/SingleSearch.jsp?sqlwhere=<%=sqlwhere%>&fromPage=<%=fromPage%>";
			try{
			 $(curDoc).find("#btnsub").css("display","inline");
		        //2012-08-10 ypc 修改
			   //window.frame2.btnsub.style.display="inline"  这种写法 导致在页面切换的时候搜索按钮不会 随页面的切换隐藏
			}catch(err){}
			}
	}
	<%if(fromPage.equals("add")){%>
	     resetbanner(1);
	<%}else {%>
	     resetbanner(<%=tabid%>);
	<%}%>

</script>

</body>
</html>