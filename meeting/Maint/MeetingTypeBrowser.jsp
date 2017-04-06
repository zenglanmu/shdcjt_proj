<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
String approver = Util.null2String(request.getParameter("approver"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
int isfrist=Util.getIntValue(request.getParameter("isfrist"),0);
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
boolean hasRight = false;
if(detachable==1){
    ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
    String subcompanys="";
    for(int i=0;i<subcompanylist.size();i++){
        subcompanys+=((String)subcompanylist.get(i)+",");
    }
    if(subcompanys.length()>1){
    	hasRight = true;
        subcompanys=subcompanys.substring(0,subcompanys.length()-1);
        if(ishead==0){
            ishead=1;
            sqlwhere="where subcompanyid in("+subcompanys+") ";
        }else{
            sqlwhere+=" and subcompanyid in("+subcompanys+") ";
        }
    }else{
        if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)){
        	hasRight = true;
        	if(ishead==0){
        		ishead=1;
	        	sqlwhere="where 1=2 ";
        	}else{
        		sqlwhere=" and 1=2 ";
        	}
    	}else{
    	    if(subcompanyid.equals("") && isfrist==0){
    	        if(user.getUID()!=1) subcompanyid=""+user.getUserSubCompany1();
    	    }
    		if(ishead==0){
        		ishead=1;
	    		sqlwhere="where subcompanyid="+user.getUserSubCompany1()+" ";
    		}else{
    			sqlwhere=" and subcompanyid="+user.getUserSubCompany1()+" ";
    		}
    	}
    }
}

if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!subcompanyid.equals("")){
    String subcoms=SubCompanyComInfo.getSubCompanyTreeStr(""+subcompanyid);
    if(subcoms.length()>1){
        subcoms=subcoms+subcompanyid;
    }else{
        subcoms=""+subcompanyid;
    }
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid in(" + subcoms+")";
	}
	else
		sqlwhere += " and subcompanyid in(" + subcoms+")";
}
if( null != approver && !"".equals(approver)){
    if(sqlwhere.indexOf("where")>-1){
        sqlwhere += " and approver = "+approver;
    }else{
        sqlwhere += " where approver = "+approver;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MeetingTypeBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input class=inputstyle type=hidden name=approver value="<%=approver%>">
<input type="hidden" name="isfrist" value='1'>
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR>
<TD width=12%><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></TD>
<TD width=38% class=field><input class=inputstyle name=fullname value="<%=fullname%>"></TD>
<%if(detachable==1){%>
      <TD width=12%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
      <TD width=38% class=field>
       
          <%if(hasRight){ %>
        <INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>" _displayText="<%if(!subcompanyid.equals("")){%><%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%><%}%>"
        	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=MeetingType:Maintenance">
        	<%} %>
      </TD>
    <%}%>
</tr>
<TR class=spacing style="height:1px;"><TD class=line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=10%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></TH>
<%if(detachable==1){%><th width=30%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></th><%}%>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></TH>
</tr><TR class=Line style="height:1px;"><TH colSpan=4></TH></TR>
<%
int i=0;
sqlwhere = "select * from Meeting_Type "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD><%=RecordSet.getString("name")%></TD>
    <%if(detachable==1){%><td><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"))%></td><%}%>
    <TD><%=WorkflowComInfo.getWorkflowname(RecordSet.getString("approver"))%></TD>
	
</TR>
<%}%>
</TABLE></FORM>

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
</script>
</BODY></HTML>


