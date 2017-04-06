<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String isbill = Util.null2String(request.getParameter("isbill"));
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")));

if(tabid.equals("")) tabid="1";

int uid=user.getUID();

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!workflowname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowname like '%" + Util.fromScreen2(workflowname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and workflowname like '%" + Util.fromScreen2(workflowname,user.getLanguage()) +"%' ";
}
if(!isbill.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isbill ='" + isbill +"' ";
	}
	else
		sqlwhere += " and isbill ='" +isbill +"' ";
}
if(!typeid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowtype = "+ typeid ;
	}
	else
		sqlwhere += " and workflowtype ="+ typeid ;
}
if(isTemplate==1){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isTemplate = '"+ isTemplate + "' ";
	}
	else
		sqlwhere += " and isTemplate = '"+ isTemplate + "' ";
}
if(isTemplate==0){
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where (isTemplate <>'1' or isTemplate is null)";
	}
	else
		sqlwhere += " and (isTemplate <>'1' or isTemplate is null)";
}
String subcompanyids="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int[] subCompanyId=null;

    if(detachable==1){  
        subCompanyId= CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
        for(int i=0;i<subCompanyId.length;i++){
            subcompanyids+=subCompanyId[i]+",";
        }
        if(subcompanyids.length()>1){
            subcompanyids=subcompanyids.substring(0,subcompanyids.length()-1);
        }
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            subcompanyids="";
        }else{
            subcompanyids="0";
        }
    }
if(!subcompanyids.equals("")){
    if(ishead==0){
        ishead = 1;
        sqlwhere += " where subCompanyId in("+ subcompanyids+")" ;
    }
    else
        sqlwhere += " and subCompanyId in("+ subcompanyids+")" ;
}

String sqlstr = "select id,workflowname,workflowtype,isbill,formid,isTemplate "+
			    "from workflow_base " + sqlwhere+" order by id";
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
      <TH width=0% style="display:none"></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TH>      
      <TH width=35%><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></TH>
      <TH width=15%><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TH>
      
   </tr>
   <TR width=100% class=Line><TH colspan="5" ></TH></TR>          
   <tr width=100%>
     <td width=100% colspan=5>
       <div style="overflow-y:scroll;width:100%;height:195px">
         <table width=100% ID=BrowseTable class="BroswerStyle">
<%

int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String workflownames = Util.toScreen(RecordSet.getString("workflowname"),user.getLanguage());
	String workflowtypes = RecordSet.getString("workflowtype");
	String isbills = RecordSet.getString("isbill");
    String formids = RecordSet.getString("formid");
    String template=Util.null2String(RecordSet.getString("isTemplate"));
    String formname="";
    
    boolean isnewform = false;
    int newformlabelid = Util.getIntValue(BillComInfo.getBillLabel(formids));
    rs.executeSql("select namelabel from workflow_bill where tablename='formtable_main_"+Util.getIntValue(formids)*(-1)+"' and id="+formids);
    if(rs.next()){
        isnewform=true;
        newformlabelid = rs.getInt("namelabel");
    }
            
    if(isbills.equals("0")&&!isnewform){
        formname=FormComInfo.getFormname(formids);
    }else{
        formname=SystemEnv.getHtmlLabelName(newformlabelid,user.getLanguage());
    }
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
	  <TD width=25%> <%=workflownames%></TD>	
	  <TD width=25%><%=WorkTypeComInfo.getWorkTypename(workflowtypes)%></TD>
	  <TD width=35%><%=formname%></TD>
      <%if(template.equals("1")){%>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(18334,user.getLanguage())%></TD>
      <%}else{%>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
      <%}%>
         </TR>
<%}
%>
      </table>
     </div>
     </td>
     
   </tr>
   <tr width=100% >
    <td height="10" colspan=5></td>
   </tr>
   <tr width=100%>
     <td width=100% align="center" valign="bottom" colspan=5>
     
        <BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>     
	<BUTTON class=btn accessKey=2  id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
  </tr>
</TABLE>
	<!--########//Select Table End########-->
  


 <script type="text/javascript">


 	jQuery(document).ready(function(){
		//alert(jQuery("#BrowseTable").find("tr").length)
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			window.parent.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.parent.close();
		});
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected");
		});
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected");
		});

	});
 </script>

<script language="javascript">
function btnclear_onclick() {
	window.parent.parent.returnValue = {id:"", name:""};//Array("","")
	window.parent.parent.close();
}

function btnsub_onclick() {
	window.parent.document.getElementById("frame1").contentWindow.document.getElementById("btnsub").click()
}

function btncancel_onclick() {
	window.parent.parent.close()
}
</script>
<!-- 


Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataDark"
      Else
         p.className = "DataLight"
      End If
   End If
End Sub

 -->
 <!-- 
<SCRIPT LANGUAGE=VBS>

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub

Sub btnsub_onclick()
     window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>
 -->
</BODY>
</HTML>