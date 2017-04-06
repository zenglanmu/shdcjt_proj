<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String suibian1 = Util.null2String(request.getParameter("suibian1"));
String fromPage= Util.null2String(request.getParameter("fromPage")); //来自于那个页面的请求
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
String rem=(String)session.getAttribute("jobtitlesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
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


session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
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
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;


if(subcompanyid.equals("")&&departmentid.equals("")&&sqlwhere.equals("") && !suibian1.equals("1")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!jobtitlemark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitlemark like '%" + Util.fromScreen2(jobtitlemark,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and jobtitlemark like '%" + Util.fromScreen2(jobtitlemark,user.getLanguage()) +"%' ";
}
if(!jobtitlename.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitlename like '%" + Util.fromScreen2(jobtitlename,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and jobtitlename like '%" + Util.fromScreen2(jobtitlename,user.getLanguage()) +"%' ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobdepartmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and jobdepartmentid =" + departmentid +" " ;
}else if(!subcompanyid.equals("")){
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobdepartmentid in(select id from hrmdepartment where subcompanyid1=" + subcompanyid +" and canceled!='1') " ;
	}
	else
		sqlwhere += " and jobdepartmentid in(select id from hrmdepartment where subcompanyid1=" + subcompanyid +" and canceled!='1') " ;
}


String sqlstr = "select id,jobtitlemark,jobtitlename,jobdepartmentid from hrmjobtitles " + sqlwhere+" order by jobdepartmentid,jobtitlemark";

%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">
   <TR width=100% class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
      <TH width=35%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
       <TH width=40%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
   </tr>
   <TR width=100% class=Line><TH colspan="4" ></TH></TR>          
   <tr width=100%>
     <td width=100% colspan=4>
       <div style="overflow-y:scroll;width:100%;height:195px">
         <table width=100% ID=BrowseTable class="BroswerStyle">
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String jobtitlemarks = RecordSet.getString("jobtitlemark");
    String jobtitlenames = RecordSet.getString("jobtitlename");
    String departmentids = RecordSet.getString("jobdepartmentid");
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
	  <TD width=35% style="word-break:break-all"> <%=jobtitlemarks%></TD>
      <TD width=40% style="word-break:break-all"> <%=jobtitlenames%></TD>
      <TD width=25% style="word-break:break-all"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
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
     
        <button type="button"  class=btnSearch accessKey=S <%if(!tabid.equals("1")){%>style="display:none"<%}%> id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button"  class=btn accessKey=2  id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <button type="button"  class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
  </tr>
</TABLE>
	<!--########//Select Table End########-->
 


 <script type="text/javascript">
 $("#BrowseTable").bind("mouseover",function(e){
		e=e||event;
	   var target=e.srcElement||e.target;
	   if("TD"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }else if("A"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }
	});
	$("#BrowseTable").bind("mouseout",function(e){
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
	});

	$("#BrowseTable").bind("click",function(e){
	   var e=e||event;
	   var target=e.srcElement||e.target;

	   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
		 window.parent.parent.close();
		}
	});

	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}

function btnsub_onclick(){
    window.parent.frame1.SearchForm.btnsub.click();
}
function btncancel_onclick(){
    window.parent.parent.close();
}
</script>



<SCRIPT LANGUAGE=VBS>



</SCRIPT>

</BODY>
</HTML>