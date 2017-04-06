<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<body>
<%
int uid=user.getUID();
    String departmentmultiOrder = null;

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("departmentmultiOrder" + uid)) {
            departmentmultiOrder = cks[i].getValue();
            break;
        }
    }

    String rem="1"+departmentmultiOrder.substring(1);
Cookie ck = new Cookie("departmentmultiOrder"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

%>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
	loadTopMenu = 0; //1-加载头部操作按钮，0-不加载头部操作按钮，主要用于多部门查询框。
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S style="display:none"  id=btnsub onclick="btnsub_onclick();" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
        <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

	<%
	//把window.close() 改成 window.parent.parent.close(); 就解决啦 组合查询 取消按钮不起作用
	//2012-08-15 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.parent.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden';
</script>

<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing style="height:1px;"><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15% class=lable><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
<TD width=35% class=Field1 colspan="3"><input class=inputstyle name=deptname size="40"></TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
<TR>
<TD width=15% class=lable><%=SystemEnv.getHtmlLabelName(22806,user.getLanguage())%></TD>
      <TD width=35% class=Field1 colspan="3">
        <input class=inputstyle name=deptcode size="40">
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
<TR>
<TD colspan="4">&nbsp;</TD>
</tr>
<TR>
<TD colspan="4">&nbsp;</TD>
</tr>
<TR>
<TD colspan="4">&nbsp;</TD>
</tr>
    <TR>
<TD colspan="4">&nbsp;</TD>
</tr>
    <TR>
<TD colspan="4">&nbsp;</TD>
</tr>

    <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>

	<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
<input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT type="text/javascript">
resourceids ="";
resourcenames = "";

function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}


function btnok_onclick(){
	 setResourceStr();
     replaceStr();
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
	setResourceStr();
    $("input[name=resourceids]").val(resourceids.substr(1));
    $("input[name=tabid]").val(1);
    document.SearchForm.submit();
}

function btncancel_onclick(){
     window.parent.parent.close();
}

</SCRIPT>





<script language="javascript">

function setResourceStr(){

	var resourceids1 =""
        var resourcenames1 = ""
     try{
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;

		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
     }catch(err){}
}

function replaceStr(){    
    var re=new RegExp("[ ]*[|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

</script>
</BODY>
</HTML>