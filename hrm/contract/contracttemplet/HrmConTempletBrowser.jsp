<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String id = Util.null2String(request.getParameter("id"));
String templetname = Util.null2String(request.getParameter("templetname"));
String templetdocid = Util.null2String(request.getParameter("templetdocid"));
String  subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!templetname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where templetname like '%";
		sqlwhere += Util.fromScreen2(templetname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and templetname like '%";
		sqlwhere += Util.fromScreen2(templetname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!templetdocid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where templetdocid ="+Util.fromScreen2(templetdocid,user.getLanguage());		
	}
	else{
		sqlwhere += " and templetdocid ="+Util.fromScreen2(templetdocid,user.getLanguage());		
	}
}
if(!id.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where id ="+Util.fromScreen2(id,user.getLanguage());		
	}
	else{
		sqlwhere += " and id  ="+Util.fromScreen2(id,user.getLanguage());		
	}
}
if(detachable==1){
	if(ishead==0){
		if(subcompanyid!= null &&!subcompanyid.equals(""))
		ishead = 1;
		sqlwhere += " where subcompanyid = "+subcompanyid;		
	}
	else{
		sqlwhere += " and subcompanyid = "+subcompanyid;
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
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="HrmConTempletBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input class=inputstyle type=hidden name=subcompanyid value="<%=subcompanyid%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<table width=100% class=Viewform>          
<TR class=Spacing><TD class=Line1 colspan=6>
    </TD>
</TR>
<TR>
    <TD class=field><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=10 name=id value="<%=id%>">
    </TD>
    <TD class=field><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=20 name=templetname value="<%=templetname%>">
    </TD>
    <TD class=field><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=10 name=templetdocid value="<%=templetdocid%>">
    </TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;	
sqlwhere = "select * from HrmContractTemplet "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
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
	<TD><A HREF=#><%=rs.getString(1)%></A></TD>
	<TD><%=rs.getString(2)%></TD>	
	<TD><%=rs.getString(3)%></TD>	
</TR>
<%}%>
</TABLE></FORM>
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
 </BODY></HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick1()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick1()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover1()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout1()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>

<script>
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
	$("#btnclear").click(btnclear_onclick);
});

function doSearch(){
   jQuery("#SearchForm").submit();
}

function doReset(){
   jQuery("#SearchForm")[0].reset();
}

</script>