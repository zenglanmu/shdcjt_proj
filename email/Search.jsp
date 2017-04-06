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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
	%>
	<BUTTON class=btnSearch accessKey=S style="display:none"  id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	
	<TR class=Spacing style="height:2px">
	<TD class=Line1 colspan=4></TD></TR>
	
	<TR>
	<TD width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
		  <TD width=20% class=field>
			<input class=inputstyle name=lastname >
		  </TD>
	<TD width=30%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
		  <TD width=20% class=field>
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
	<!--
	<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
		  <TD width=35% class=field>
			<select class=inputstyle id=resourcetype name=resourcetype>
			  <option value=""></option>
			  <option value=F ><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
			  <option value=H ><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></option>
			  <option value=D ><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
			  <option value=T ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			</select>
		  </TD>
	-->
	</tr>
	<TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
	<tr>
	<TD width=30%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
	<TD width=20% class=field>
			<input class=inputstyle name=jobtitle maxlength=60 >
		  </td>
	<TD width=30%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD width=20% class=field>
			<select class=inputstyle id=departmentid name=departmentid>
			<option value="0"><%=SystemEnv.getHtmlLabelName(16138,user.getLanguage())%></option>
			<% while(DepartmentComInfo.next()) {
				String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
			%>
			  <option value=<%=tmpdepartmentid%> >
			  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
			<% } %>
			</select>
		  </TD>
	</tr>
	<tr>
		<td width="30%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<td width="20%" class=field colspan='3'>
			<select class="inputstyle" id="roleid" name="roleid">
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<% while(RoleComInfo.next()) {
				String temproleid = RoleComInfo.getRolesid() ;
			%>
			  <option value=<%=temproleid%> >
			  <%=Util.toScreen(RoleComInfo.getRolesname(),user.getLanguage())%></option>
			<% } %>
			</select>
			
		</td>
		
	</tr>
	<tr colSpan=6>&nbsp;<tr>
	<tr colSpan=6>&nbsp;<tr>
	<tr colSpan=6>&nbsp;<tr>
	
	<TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
        
	<TR class=Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>

	</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>

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
    if(resourcenames.indexOf("@")<0)
    resourcenames="";
    re=new RegExp("[,]+[^,]*[<]","g")
    resourcenames=resourcenames.replace(re,",")
    re=new RegExp("[>]","g")
    resourcenames=resourcenames.replace(re,"")
    re=new RegExp(",[^,@]*,","g")
    resourcenames=resourcenames.replace(re,",")
}

resourceids =""
resourcenames = ""

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
	setResourceStr() ;
    jQuery("input[name=resourceids]").val(resourceids.substr(1)); 
    jQuery("input[name=tabid]").val(2);
    document.SearchForm.submit();
}

function btncancel_onclick(){
     window.parent.parent.close();
}
</script>
</BODY>
</HTML>