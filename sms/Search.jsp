<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>


</HEAD>

<BODY>
<%
int uid=user.getUID();
String resourcemulti=null;
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcemulti"+uid)){
        resourcemulti=cks[i].getValue();
        break;
        }
        }
String rem="2"+resourcemulti.substring(1);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
    check_per=check_per.substring(1);
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("lastname"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
	}
}
%>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsub_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<button  type='button' class=btnSearch accessKey=S style="display:none"  id=btnsub  onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button  type='button' class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button  type='button' class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<button  type='button' class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button  type='button' class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing style="height: 1px;"><TD class=Line1 colspan=4></TD>
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
<TR style="height: 1px;"><TD class=Line colSpan=4></TD>
</TR>

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <button  type='button' class=Browser id=SelectSubcompany onclick="onShowSubcompany()"></BUTTON>
        <SPAN id=subcompanyspan></SPAN>
        <INPUT id=subcompanyid type=hidden name=subcompanyid >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <button  type='button' class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
        <SPAN id=departmentspan></SPAN>
        <input class=inputstyle type=hidden name=departmentid>
      </TD>
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=4></TD>    
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 >
      </td>
<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<TD width=35% class=field>
        <button  type='button' class=Browser id=SelectRole onclick="onShowRole()"></BUTTON>
        <SPAN id=rolespan></SPAN>
        <input class=inputstyle type=hidden name=roleid>
      </TD>

</tr>
<TR style="height: 1px;"><TD class=Line colSpan=4></TD></TR>
<tr colSpan=4>&nbsp;<tr>
	<tr colSpan=4>&nbsp;<tr>
<tr colSpan=4>&nbsp;<tr>
    

	<TR class=Spacing style="height: 1px;"><TD class=Line1 colspan=4></TD></TR>
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>


  

 
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick1()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick1()
	 setResourceStr()
     window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub

Sub btnsub_onclick1()
	setResourceStr() 
    document.all("resourceids").value = Mid(resourceids,2) 
    document.all("tabid").value=2   
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub


sub onShowDepartment1()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.SearchForm.departmentid.value)
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			departmentspan.innerHtml = id(1)
			document.SearchForm.departmentid.value=id(0)
            subcompanyspan.innerHtml=""
            document.SearchForm.subcompanyid.value=""
            else
            departmentspan.innerHtml=""
            document.SearchForm.departmentid.value=""
		end if
	end if
end sub

sub onShowSubcompany1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&document.SearchForm.subcompanyid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	subcompanyspan.innerHtml = id(1)
	document.SearchForm.subcompanyid.value=id(0)
    departmentspan.innerHtml=""
    document.SearchForm.departmentid.value=""
    else
    subcompanyspan.innerHtml=""
    document.SearchForm.subcompanyid.value=""
	end if
	end if
end sub

sub onShowRole1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		rolespan.innerHtml = id(1)
		document.SearchForm.roleid.value=id(0)
		else
		rolespan.innerHtml = ""
		document.SearchForm.roleid.value=""
		end if
	end if
end sub
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

function btnsub_onclick(){
	setResourceStr();
    $G("resourceids").value =resourceids.substr(1);
    $G("tabid").value=2;
    $G("SearchForm").submit();   
}

function doReset(){
    $G("SearchForm").reset();
}

function btnok_onclick(){
	 setResourceStr();
     window.parent.parent.returnValue ={id:resourceids,name:resourcenames};
     window.parent.parent.close();
}

function btncancel_onclick(){
     window.parent.parent.close();
}

function btnclear_onclick(){
     window.parent.parent.returnValue ={id:"",name:""};
     window.parent.parent.close();
}

function onShowSubcompany(){
	results= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+$G("subcompanyid").value);
	if (results) {
		if (results.id!=""){
			$G("subcompanyspan").innerHTML =results.name;
			$G("subcompanyid").value=results.id;
		    $G("departmentspan").innerHTML="";
		    $G("departmentid").value="";
	    }else{
		    $G("subcompanyspan").innerHTML="";
		    $G("subcompanyid").value="";
		}
	}
}

function onShowDepartment(){
    results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$G("departmentid").value);
	if (results){
		if (results.id!="") {
			$G("departmentspan").innerHTML =results.name;
			$G("departmentid").value=results.id;
            $G("subcompanyspan").innerHTML="";
            $G("subcompanyid").value="";
            }else{
            $G("departmentspan").innerHTML="";
            $G("departmentid").value="";
		}
	}
}

function onShowRole(){
	results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	if (results){
	    if (results.id!="") {
			$G("rolespan").innerHTML = results.name;
			$G("roleid").value=results.id;
		}else{
			$G("rolespan").innerHTML = "";
			$G("roleid").value="";
		}
	}
}


</script>
</BODY>
</HTML>