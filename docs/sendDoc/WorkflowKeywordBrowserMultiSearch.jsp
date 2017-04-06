<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
</HEAD>
<body>
<%
int uid=user.getUID();
    String WorkflowKeywordBrowserMulti = null;

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
            WorkflowKeywordBrowserMulti = cks[i].getValue();
            break;
        }
    }

String rem="2";
if(WorkflowKeywordBrowserMulti!=null&&WorkflowKeywordBrowserMulti.length()>1){
	rem="2"+WorkflowKeywordBrowserMulti.substring(1);
}

Cookie ck = new Cookie("WorkflowKeywordBrowserMulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
//组合查询不接收条件
String sqlwhere ="";

String strKeyword = Util.null2String(request.getParameter("strKeyword"));


%>
	<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="WorkflowKeywordBrowserMultiSelect.jsp" method=post target="frame2">
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:btncancel_reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON type='button' class=btnSearch accessKey=S style="display:none"  id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON type=reset class=btnReset accessKey=T style="display:none" ><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=O style="display:none" id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>
<%}%>
<table width=100%  class=ViewForm  valign=top>

<!-- 2012-08-16 ypc 修改 给该行指定高度-->
<TR style="height:1%" class="Spacing"><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=keyWordName ></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=keywordDesc ></TD>
</tr>

<!-- 2012-08-16 ypc 修改 必须给该行指定 高度 -->
<TR style="height:2%"><TD class=Line colSpan=4></TD>
</TR>


  
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="strKeyword" value="<%=strKeyword%>">
<input class=inputstyle type="hidden" name="tabid" id="tabid">
	<!--########//Search Table End########-->
	</FORM>

<!--  
<SCRIPT LANGUAGE=VBS>
strKeyword =""
Sub btnclear_onclick()
     window.parent.returnvalue = ""
     window.parent.close
End Sub


Sub btnok_onclick()
	 setKeywordStr()
     window.parent.returnvalue = strKeyword
    window.parent.close
End Sub

Sub btnsub_onclick()
	setKeywordStr()
    document.all("strKeyword").value = strKeyword
    document.all("tabid").value=2
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>-->
<script language="javascript" type="text/javascript">
var strKeyword = "";
function btnclear_onclick(){
    window.parent.parent.returnValue = "";
	window.parent.parent.close();
}

function btnok_onclick(){
	setKeywordStr();
    window.parent.parent.returnValue = strKeyword;
    window.parent.parent.close();
}

function btnsub_onclick(){
	setKeywordStr();
    document.all("strKeyword").value = strKeyword;
    document.all("tabid").value=2
    document.SearchForm.submit();
}

function btncancel_onclick(){
    window.parent.parent.close();
}
//2012-08-20 ypc 修改　解决右键菜单　重新设置　不起作用
function btncancel_reset(){
	document.getElementById("SearchForm").reset();
}

function setKeywordStr(){
	var strKeyword1 =""

	try{
		for(var i=0;i<parent.frame2.keywordArray.length;i++){
			strKeyword1 += " "+parent.frame2.keywordArray[i].split("~")[1] ;
	    }
		if(strKeyword1!=""){
			strKeyword1=strKeyword1.substr(1)
		}
	    strKeyword=strKeyword1
    }catch(err){}
}
</script>
</BODY>
</HTML>