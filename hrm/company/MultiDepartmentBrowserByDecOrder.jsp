<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String resourceids=Util.null2String(request.getParameter("resourceids"));
if(resourceids.equals("")) resourceids=selectedDepartmentIds;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter,"Departments:decentralization",fieldid,isdetail,isbill);
    String departments=CheckSubCompanyRight.getDepartmentids();
    String subcompanyids=CheckSubCompanyRight.getSubcompanyids();
    boolean isall=CheckSubCompanyRight.getIsall();
    if(!isall){
        if(onlyselfdept){
            sqlwhere=" where id in("+CheckSubCompanyRight.getDepartmentids()+")";
        }else{
            sqlwhere=" where subcompanyid1 in("+CheckSubCompanyRight.getSubcompanyids()+")";
        }
    }
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentmultiDecOrder"+uid)){
  rem=cks[i].getValue();
  break;
}
}
String tabid="0";
if(rem!=null&&rem.length()>1){
String[] atts=Util.TokenizerString2(rem,"|");
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

  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0)" ><b><%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%></b></td>

  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>

  <td nowrap name="oTDtype_2"  id="oTDtype_2" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=40%>

<IFRAME name=frame1 id=frame1  width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr id="subdepttr" style="display:none">
  <td colspan="3"><input type="checkbox" id="showsubdept" name="showsubdept" value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage())%></td>
</tr>  
<tr>
<td  id=oTd2 name=oTd2 width=100% height=60%>

<iframe name=frame2 id=frame2 src="/hrm/company/MultiSelect.jsp?isdec=1&tabid=<%=tabid%>&resourceids=<%=resourceids%>&sqlwhere=<%=sqlwhere%>" width=100%  height=100% frameborder="no" scrolling="no">
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){
		//for(i=0;i<=1;i++){
			//document.all("oTDtype_"+i).background="/images/tab/bgdark.gif";
		//}
		//document.all("oTDtype_"+objid).background="/images/tab/bglight.gif";
		for(i=0;i<=1;i++){
			$("#oTDtype_"+i).attr("background","/images/tab/bgdark.gif");
		}
		$("#oTDtype_"+objid).attr("background","/images/tab/bglight.gif");
		//ypc 2012-08-13 ypc 修改 start
		 var curDoc;
			if(document.all){
				curDoc=window.frames["frame2"].document;
			}
			else{
				curDoc=document.getElementById("frame2").contentDocument;
		}
		//ypc 2012-08-13 ypc 修改 end
		
		if(objid == 0 ){
		        window.frame1.location="/hrm/company/SearchByOrganByDec.jsp?onlyselfdept=<%=onlyselfdept%>&sqlwhere=<%=sqlwhere%>&departments=<%=departments%>&subcompanyids=<%=subcompanyids%>&isall=<%=isall%>";
		        try{
                    //document.getElementById("subdepttr").style.display='inlime';
                    $(curDoc).find("#subdepttr").css("display","inlime")
		            //window.frame2.btnsub.style.display="none"; //修改之前
		             $(curDoc).find("#btnsub").css("display","none"); //ypc 修改
		        }catch(err){}
		        }
		else if(objid == 1){
			window.frame1.location="/hrm/company/SearchByDec.jsp?sqlwhere=<%=sqlwhere%>";
			try{
               // document.getElementById("subdepttr").style.display="none";
                  $(curDoc).find("#subdepttr").css("display","none")
			    //window.frame2.btnsub.style.display="inline"; //修改之前
			    $(curDoc).find("#btnsub").css("display","inline"); //ypc 修改
			}catch(err){}
			}
	}

resetbanner(<%=tabid%>);
</script>

</body>
</html>