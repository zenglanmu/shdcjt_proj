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
String rem="1"+jobtitlesingle.substring(1);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btncancel.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON  type="button" class=btn accessKey=S style="display:none" id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON  type="button" class=btn accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<BUTTON  type="button" class=btn accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON  type="button" class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>
<%}%>
<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing><TD class=Line1 colspan=4></TD>
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

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
              <SPAN id=departmentspan>
              </SPAN>
              <INPUT class=inputstyle id=departmentid type=hidden name=departmentid>
      </TD>
</tr>

</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="suibian1" id="suibian1" >
<input class=inputstyle type="hidden" name="jobtitles" >
<input class=inputstyle type="hidden" name="jobtitlesnames" >

</FORM>

<SCRIPT language="javascript">
var jobtitles="";
var jobtitlesname="";

function setJobStr(){
	
	var jobtitles1 ="";
	var jobtitlesname1="";
    try{
		for(var i=0;i<parent.frame2.resourceArray.length;i++){
			jobtitles1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;		
			jobtitlesname1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
		}
		jobtitles=jobtitles1;
		jobtitlesname=jobtitlesname1;
       }catch(err){}	
		
}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

</SCRIPT>

<SCRIPT LANGUAGE=javascript>
function btnclear_onclick(){
	 window.parent.returnValue = new Array("0","");
     window.parent.close();
}

function btnsub_onclick(){
    setJobStr();
	$("input[name=jobtitles]").val( jobtitles.substr(2));
	$("input[name=tabid]").val(1)
	$("#suibian1").val(1);
    document.SearchForm.submit();
}
function onShowDepartment(){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name=departmentid]").val()
			,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas) {
		if (datas.id!="") {
			$("#departmentspan").html(datas.name);
			$("input[name=departmentid]").val(datas.id);
		}
		else{
			$("#departmentspan").html("");
			$("input[name=departmentid]").val("");
		}
	}
}
$(function(){
	$("#btnsub").click(btnsub_onclick);
	$("btnclear").click(btnclear_onclick);
});
</SCRIPT>

</BODY>
</HTML>