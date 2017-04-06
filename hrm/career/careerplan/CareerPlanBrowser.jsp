<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String topic = Util.null2String(request.getParameter("topic"));
String startdate = Util.null2String(request.getParameter("startdate"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String principalid = Util.null2String(request.getParameter("principalid"));
String informmanid = Util.null2String(request.getParameter("informmanid"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!topic.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where topic like '%";
		sqlwhere += Util.fromScreen2(topic,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and topic like '%";
		sqlwhere += Util.fromScreen2(topic,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!principalid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where principalid =";
		sqlwhere += Util.fromScreen2(principalid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and principalid =";
		sqlwhere += Util.fromScreen2(principalid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!informmanid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where informmanid =";
		sqlwhere += Util.fromScreen2(informmanid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and informmanid =";
		sqlwhere += Util.fromScreen2(informmanid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!startdate.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where startdate >='" + Util.fromScreen2(startdate,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and startdate >='" + Util.fromScreen2(startdate,user.getLanguage()) +"' ";
}
if(!startdateto.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
			sqlwhere += " where (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
			sqlwhere += " where (startdate <> '' and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
	}
	else 
	        if(rs.getDBType().equals("oracle")){
			sqlwhere += " and (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
			sqlwhere += " and (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="CareerPlanBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON  type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON  type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON  type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON  type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>
<TR class=spacing style="height: 1px;"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=10%><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
<TD width=30% class=field>
  <input class=inputstyle name=topic value="<%=topic%>">
</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15668,user.getLanguage())%></TD>
<TD width=45% class=field>
  <BUTTON  type="button" class=Calendar id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
  <SPAN id=datespan ><%=startdate%></SPAN>-- 
  <BUTTON  type="button" class=Calendar id=selectdateto onclick="getDate(datetospan,startdateto)"></BUTTON> 
  <SPAN id=datetospan ><%=startdateto%></SPAN> 
  <input class=inputstyle type="hidden" id="startdateto" name="startdateto" value="<%=startdateto%>">   
  <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>"> 
</TD>
</TR>
<TR style="height: 1px;"><TD class=Line colSpan=4></TD></TR> 
<TR>
<TD width=10%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
<TD width=30% class=field>
  <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
       _displayTemplate="<A href='HrmResource.jsp?id=#b{id}' target='_blank'>#b{name}</A>"
       _displayText="<%=ResourceComInfo.getResourcename(principalid)%>" id=principalid
       name=principalid value="<%=principalid%>"
   >
</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></TD>
<TD width=45% class=field>
  <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
       _displayTemplate="<A href='HrmResource.jsp?id=#b{id}' target='_blank'>#b{name}</A>"
       _displayText="<%=ResourceComInfo.getResourcename(informmanid)%>" id=informmanid
       name=informmanid value="<%=informmanid%>"
   >
</TD>
</TR>
<TR class=Spacing style="height: 1px;"><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
  <COLGROUP>  
  <COL width="20%">
  <COL width="20%">  
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>  
  
  <TR class=DataHeader>   
    <Th><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></Th>
    <Th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></Th>
    <Th><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></Th>
    <Th><%=SystemEnv.getHtmlLabelName(15668,user.getLanguage())%></Th>
    <Th><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></Th>
  </tr><TR class=Line style="height: 1px;"><TH colspan="5" ></TH></TR>
 
<% 
String sql = "select * from HrmCareerPlan "+sqlwhere; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
String	plantopic=Util.null2String(rs.getString("topic")); 
String	planprincipalid=Util.null2String(rs.getString("principalid")); 
String  planinformmanid = Util.null2String(rs.getString("informmanid"));
String  planstartdate = Util.null2String(rs.getString("startdate"));
String  advice = Util.null2String(rs.getString("advice"));
try{ 
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%
} 
%> 
   <TD style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
   <td><%=plantopic%></td>
   <TD><%=ResourceComInfo.getResourcename(planprincipalid)%></TD> 
   <TD><%=ResourceComInfo.getResourcename(planinformmanid)%></TD>  
   <TD><%=planstartdate%></TD> 
   <TD><%=advice%></TD>   
  </TR>
<% 
  }catch(Exception e){ 
  System.out.println(e.toString()); } } 
%>
</TBODY>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script type="text/javascript">
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
    		 name:jQuery(curTr.cells[1]).text()
    		 };
    
      window.parent.parent.close();
	}
}

function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	jQuery("#btnclear").click(btnclear_onclick);
});

function doSearch(){
    jQuery("#SearchForm").submit();
}

function doReset(){
    jQuery("#SearchForm")[0].reset();
}

</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>