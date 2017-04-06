<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<script language=javascript>
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("必要信息不完整");
		 return false;
		}

	}
	return true;
}

function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 


function issubmit(){
   if(!confirm("确定要提交吗？")){
       return false;
   }
       return true;
   } 
</script>






<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>

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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ResourceBrowser.jsp" method=post>
<input type=hidden name=seclevelto value="">
<input type=hidden name=needsystem value="">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1>
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(16445,user.getLanguage())%></TH>      
      <TH width=25%><%=SystemEnv.getHtmlLabelName(16446,user.getLanguage())%></TH>
</TH>
</tr><TR class=Line><TH colSpan=3></TH></TR>
<%
int versionId = Util.getIntValue(request.getParameter("versionId"),0);
int docid = Util.getIntValue(request.getParameter("docid"),0);

DocImageManager.setVersionId(versionId);
DocImageManager.setDocid(docid);
DocImageManager.selectCurNewestVersion();
ArrayList versionIdTmp = new ArrayList();
ArrayList versionDetailTmp = new ArrayList();
ArrayList fileImageId = new ArrayList();
while(DocImageManager.next()){
    versionIdTmp.add(DocImageManager.getVersionId()+"");
    versionDetailTmp.add(DocImageManager.getVersionDetail()+"");
    fileImageId.add(DocImageManager.getImagefileid()+"");
}
%>
<%
int i=0;
int j=versionIdTmp.size();
while(i<versionIdTmp.size()){
    if((j+3)%2==0){
%>
<TR class=DataLight>

	<TD style="display:none"><A HREF=#><%=versionIdTmp.get(i)%></A></TD>
    <TD style="display:none"><A HREF=#><%=fileImageId.get(i)%></A></TD>
	<TD><%=j%> </TD>
	<TD><%=versionDetailTmp.get(i)%></TD>

</TR>
<%
    }else{
%>
<TR class=DataDark>

	<TD style="display:none"><A HREF=#><%=versionIdTmp.get(i)%></A></TD>
    <TD style="display:none"><A HREF=#><%=fileImageId.get(i)%></A></TD>
	<TD><%=j%> </TD>
	<TD><%=versionDetailTmp.get(i)%></TD>

</TR>
<%
    }
    j--;
    i++;
}
%>
  <input type="hidden" name="sqlwhere" value=''>
</FORM>

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
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
