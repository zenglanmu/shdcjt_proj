<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
String from = Util.null2String(request.getParameter("from"));
int uid=user.getUID();
String resourcesingle=(String)session.getAttribute("resourcesingle");
        if(resourcesingle==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcesingle"+uid)){
        resourcesingle=cks[i].getValue();
        break;
        }
        }
        }
String rem="2"+resourcesingle.substring(1);
session.setAttribute("resourcesingle",rem);
Cookie ck = new Cookie("resourcesingle"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select.jsp" method=post target="frame2">
	<input class=inputstyle type=hidden name=from value=<%=from%>>
	<input type="hidden" name="isinit" value="1"/>
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
<button type="button" class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<button type="button" class=btnok accessKey=1 style="display:none" onclick="btncancel_onclick();" id=btnok ><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=lastname ></TD>
   
<TD width=15%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=status name=status >
          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value="" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        </select>   
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR> 

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectSubcompany onclick="onShowSubcompany()"></BUTTON>
        <SPAN id=subcompanyspan></SPAN>
        <INPUT id=subcompanyid type=hidden name=subcompanyid >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
        <SPAN id=departmentspan></SPAN>
        <input class=inputstyle type=hidden name=departmentid id="departmentid">
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>    
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 >
      </td>
<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<TD width=35% class=field>
        <BUTTON type="button" class=Browser id=SelectRole onclick="onShowRole()"></BUTTON>
        <SPAN id=rolespan></SPAN>
        <input class=inputstyle type=hidden name=roleid>
      </TD>

</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD> 
</table>
<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
<input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function btnsub_onclick(){
    $("input[name=tabid]").val(2);
    //是否显示无账号人员 
    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
      jQuery("#isNoAccount").val("1");
    else
      jQuery("#isNoAccount").val("0");
    document.SearchForm.submit();
}
function btnclear_onclick(){
     window.parent.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.parent.close();
}

function btncancel_onclick(){
     window.parent.parent.close();
}

function onShowSubcompany(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+jQuery("#subcompanyid").val());
	if(results){
		if (results.id!="" ){
			subcompanyspan.innerHTML =results.name;
			$G("subcompanyid").value=results.id;
		    $G("departmentspan").innerHTML="";
		    $G("departmentid").value="";
		}
		else{
			subcompanyspan.innerHTML ="";
			$G("subcompanyid").value="";
		}
	}
}
function onShowDepartment(){
    var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("#departmentid").val());
	if (results){
		if (results.id!="") {
				departmentspan.innerHTML =results.name;
				document.SearchForm.departmentid.value=results.id;
				subcompanyspan.innerHTML="";
				document.SearchForm.subcompanyid.value="";
			}
            else{
				departmentspan.innerHTML="";
				document.SearchForm.departmentid.value="";
			}
	}
}

function onShowRole(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if(results){
	     if (results.id!= "" ){
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value=results.id;
		}
		else{
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value="";
		}
	}
}
</script>
</BODY>
</HTML>