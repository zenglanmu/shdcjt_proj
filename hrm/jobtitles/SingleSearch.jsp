<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
int uid=user.getUID();
String jobtitlesingle=(String)session.getAttribute("jobtitlesingle");
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

String rem="1";
if(jobtitlesingle!=null)
   rem="1"+jobtitlesingle.substring(1);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
String fromPage= Util.null2String(request.getParameter("fromPage")); //来自于那个页面的请求
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<button type="button" class=btnSearch accessKey=S style="display:none" id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<button type="button" class=btnReset accessKey=T style="display:none" type=reset ><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<button type="button" class=btnok accessKey=1 style="display:none" onclick="window.parent.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>
<%}%>
<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing style="height:1px;"><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=jobtitlemark ></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=jobtitlename ></TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR> 
<%if(!fromPage.equals("add")){%>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
       
              <INPUT class="wuiBrowser" id=departmentid type=hidden name=departmentid _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp">
      </TD>
</tr>
<%}%>
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="suibian1" id="suibian1" >
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT type="text/javascript">
function btnclear_onclick(){
    window.parent.parent.returnValue ={id:"",name:""};
    window.parent.parent.close()
}
function btnsub_onclick(){
   $G("tabid").value = 1;
   $G("suibian1").value = 1;
   document.SearchForm.submit();
}
</SCRIPT>

</BODY>
</HTML>