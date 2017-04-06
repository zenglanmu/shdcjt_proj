<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String resourceids=Util.null2String(request.getParameter("resourceids"));
    //页面传过来的自定义组id
String initgroupid=Util.null2String(request.getParameter("groupid"));
String coworkid=Util.null2String(request.getParameter("coworkid"));
String workID = Util.null2String(request.getParameter("workID"));
String cowtypeid = Util.null2String(request.getParameter("cowtypeid"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String status=Util.null2String(request.getParameter("status"));
String newmail = Util.null2String(request.getParameter("newmail"));

int uid=user.getUID();
    String resourcemulti = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("resourcemulti" + uid)) {
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
<body scroll="no">



<TABLE class=form width=100% id=oTable1 height=100%>

  <TBODY>
  <tr>
  <td  height=30 colspan=3 background="/images/tab/bg1.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1.gif" width=15px height=100% align=center></td> 
  
  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" ><b><%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%></b></td>
 
  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" ><b><%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%></b></td>
 
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(2)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>

  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=35%>

<IFRAME name=frame1 id=frame1  width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=65%>

<IFRAME name=frame2 id=frame2 src="/hrm/resource/MultiSelect.jsp?newmail=<%=newmail %>&tabid=<%=tabid%>&resourceids=<%=resourceids%>&initgroupid=<%=initgroupid%>&coworkid=<%=coworkid%>&workID=<%=workID%>&cowtypeid=<%=cowtypeid%>&sqlwhere=<%=sqlwhere%>" width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){
		for(i=0;i<=2;i++){
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
		        window.frame1.location="/hrm/resource/SearchByOrgan.jsp?sqlwhere=<%=sqlwhere%>";
		        try{
					$(curDoc).find("#btnsub").css("display","none");
		        }catch(err){}
		        }			
		else if(objid == 1){
			window.frame1.location="/hrm/resource/SearchByGroup.jsp?sqlwhere=<%=sqlwhere%>";
			try{
				$(curDoc).find("#btnsub").css("display","none");
			}catch(err){}
			}
		else if(objid == 2){
			window.frame1.location="/hrm/resource/Search.jsp?status=<%=status%>&sqlwhere=<%=sqlwhere%>";
			try{
				$(curDoc).find("#btnsub").css("display","inline");
			}catch(err){}
			}
	}
function closeWindow(){
	window.parent.close();
}
resetbanner(<%=tabid%>);
</script>

</body>
</html>