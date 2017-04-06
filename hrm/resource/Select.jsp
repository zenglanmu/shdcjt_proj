<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String from  = Util.null2String(request.getParameter("from"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String needsystem = Util.null2String(request.getParameter("needsystem"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
//System.out.println("needsystem"+needsystem);

if(tabid.equals("")) tabid="0";

int uid=user.getUID();
String rem=(String)session.getAttribute("resourcesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
        
if(rem!=null)
  rem=tabid+rem.substring(1);
else
  rem=tabid;
if(!nodeid.equals(""))
  rem=rem.substring(0,1)+"|"+nodeid;


session.setAttribute("resourcesingle",rem);
Cookie ck = new Cookie("resourcesingle"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    //System.out.println("departmentid"+departmentid);
    }
}
else if(tabid.equals("1") && atts.length>1) {
	groupid=atts[1];
}
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
//String departmentid = Util.null2String(request.getParameter("departmentid"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
String firstname = Util.null2String(request.getParameter("firstname"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String roleid = Util.null2String(request.getParameter("roleid"));

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;


if(tabid.equals("0")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";

/*if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;*/
if(status.equals("-1")) status = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (lastname like '%"+Util.fromScreen2(lastname,user.getLanguage())+"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
	}
	else 
		sqlwhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
}
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
if(!seclevelto.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where HrmResource.seclevel <= '"+ seclevelto + "' ";
	}
	else
		sqlwhere += " and HrmResource.seclevel <= '"+ seclevelto + "' ";
}
if(!resourcetype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where resourcetype = '"+ resourcetype + "' ";
	}
	else
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
}
/*
if(!resourcestatus.equals("")){
	if(ishead==0){
		ishead = 1;
		if(resourcestatus.equals("0")) 
			sqlwhere += " where (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle ) 
			    sqlwhere += " where (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " where ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
	}
	else {
		if(resourcestatus.equals("0")) 
			sqlwhere += " and (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle )
			    sqlwhere += " and (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " and ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
	}
}
*/
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
	}
	else
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where departmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and departmentid =" + departmentid +" " ;
}
if(departmentid.equals("")&&!subcompanyid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid1 =" + subcompanyid +" " ;
	}
	else
		sqlwhere += " and subcompanyid1 =" + subcompanyid +" " ;
}
if(!status.equals("")&&!status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where status =" + status +" " ;
	}
	else
		sqlwhere += " and status =" + status +" " ;
}
if(status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (status =0 or status = 1 or status = 2 or status = 3) " ;
	}
	else
		sqlwhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
}
 if(!roleid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere += " where  HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
        }
        else
            sqlwhere += " and    HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
    }

 String noAccountSql="";
 if(!isNoAccount.equals("1")){
	 if(ishead==0){
		 ishead = 1;
		 noAccountSql=" where loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
	 }else{
		 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
	 }
 }
 sqlwhere=sqlwhere+(isNoAccount.equals("1")?"":noAccountSql); //是否显示无账号人员
/*String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;*/
String sqlstr = "";
if(mode==null||!mode.equals("ldap")){//win
if(from.equals("add")){
 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
			    "from HrmResource " + sqlwhere+" and (accounttype is null or accounttype=0) order by dsporder,lastname"; ;

if(tabid.equals("1")&&!groupid.equals("")){
sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where (t1.accounttype is null or t1.accounttype=0) and t1.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by t1.dsporder,t1.lastname";
}

if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
}
}else{
 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
			    "from HrmResource " + sqlwhere+" order by dsporder,lastname"; ;

if(tabid.equals("1")&&!groupid.equals("")){
sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where t1.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by t1.dsporder,t1.lastname";
}

if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
}
}
}else{//ldap
	if(from.equals("add")){
		 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
					    "from HrmResource " + sqlwhere+" and (accounttype is null or accounttype=0) order by dsporder,lastname"; ;

		if(tabid.equals("1")&&!groupid.equals("")){
		sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where (t1.accounttype is null or t1.accounttype=0) and t1.id=t2.userid and t2.groupid="+groupid+" order by t1.dsporder,t1.lastname";
		}

		if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
		}
		}else{
		 sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle "+
					    "from HrmResource " + sqlwhere+" order by dsporder,lastname"; ;

		if(tabid.equals("1")&&!groupid.equals("")){
		sqlstr="select t1.id,t1.lastname,t1.departmentid,t1.jobtitle from hrmresource t1,HrmGroupMembers t2 where t1.id=t2.userid and t2.groupid="+groupid+" order by t1.dsporder,t1.lastname";
		}

		if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" and subcompanyid1="+Util.getIntValue(subcompanyid)+" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and account is not null ";
		if(!isoracle) sqlstr+="and account<>''";
		sqlstr+=" and departmentid="+Util.getIntValue(departmentid)+" order by dsporder,lastname";
		} 
		}
}
//add by alan for td:10343
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0" width="100%">
    <tr>
       <td colspan="3" align="right">
           <input type="checkbox" value="1" name="isNoAccount" id="isNoAccount" <%=isNoAccount.equals("1")?"checked='checked'":""%>>显示无账号人员
       </td>
    </tr>
   <TR width=100% class=DataHeader>    
      <TH width=25%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH width=35%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
      <TH width=40%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
   </tr>
   <TR width=100% class=Line><TH colspan="4" ></TH></TR>          
   <tr width=100%>
     <td width=100% colspan=4>
       <div style="overflow-y:scroll;width:100%;height:195px">
         <table width=100% ID=BrowseTable class="BroswerStyle">
<%

if( needsystem.equals("1")) {
%>
          <TR width=100% class=DataDark>
	   <TD style="display:none" width=0><A HREF=#>1</A></TD>
	   <TD width=25%><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></TD>
	   <TD width=35%></TD>
	   <TD style="display:none" width=0></TD>
	   <TD width=25%></TD>
          </TR>
<%
}
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	//String resourcetypes = RecordSet.getString("resourcetype");
	//String startdates = RecordSet.getString("startdate");
	//String enddates = RecordSet.getString("enddate");
	String jobtitlenames = Util.toScreen(JobTitlesComInfo.getJobTitlesname(RecordSet.getString("jobtitle")),user.getLanguage());
	String departmentids = RecordSet.getString("departmentid");
	if(i==0){
		i=1;
%>
         <TR width=100% class=DataLight>
<%
	}else{
		i=0;
%>
         <TR width=100% class=DataDark>
<%
}
%>
	  <TD width=0 style="display:none"><A HREF=#><%=ids%></A></TD>
	  <TD width=25%> <%=lastnames%></TD>
	
	  <TD width=35%><%=jobtitlenames%></TD>
	  <TD width=0 style="display:none"><%=departmentids %></TD>
	  <TD width=25%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
         </TR>
<%}
%>
      </table>
     </div>
     </td>
     
   </tr>
   <tr width=100% >
    <td height="10" colspan=4></td>
   </tr>
   <tr width=100%>
     <td width=100% align="center" valign="bottom" colspan=4>
     
        <BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>     
	<BUTTON class=btn accessKey=2  id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
  </tr>
</TABLE>
<SCRIPT LANGUAGE=VBS>




</SCRIPT>



<script language="javascript">
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}

function btnsub_onclick(){
     window.parent.frame1.document.SearchForm.btnsub.click();
}

function btncancel_onclick(){
     window.parent.parent.close();
}

	function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{ 
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	var curTr=jQuery(target).parents("tr")[0];
     window.parent.parent.returnValue = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text(),
    		 a1:jQuery(curTr.cells[3]).text(),
    		 a2:jQuery(curTr.cells[4]).text()};
    

      window.parent.parent.close();
	}
}
$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	
	$("#btncancel").click(btncancel_onclick);
	$("#btnsub").click(btnsub_onclick);
	
	$("#btnclear").click(btnclear_onclick);
	
});
</script>
</BODY>
</HTML>