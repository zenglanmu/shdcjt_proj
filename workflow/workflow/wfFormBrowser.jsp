<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String formname=Util.null2String(request.getParameter("formname"));
String sqlwhere = "";
if(!formname.equals("")) {
	sqlwhere = " and formname like '%"+formname+"%' ";
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="wfFormBrowser.jsp" method=post>
<input type="hidden" name="isbill" value="<%=isbill%>" >

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



<table width=100% class=viewform>
<TR>
<TD width=20%>
<%if(isbill.equals("0")){ %>      
      <%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></tr>
<%}else if(isbill.equals("1")){ %>
	<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></tr>
<%} %>
</TD>
<TD width=80% class=field><input name=formname value="<%=formname%>" class="InputStyle"></TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<TR class="Spacing" style="height:1px;">
      <TD class="Line1" colspan=4></TD>
    </TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<%if(isbill.equals("0")){ %>      
      <TH ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></TH></tr>
<%}else if(isbill.equals("1")){ %>
	<TH ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></TH></tr>
<%} %>
	  <TR class=Line style="height:1px;"><Th colspan="2" ></Th></TR> 
    <%
    if(isbill.equals("0")) {
    if(detachable==1){
        //获取具有查看权限的所有机构
        CheckSubCompanyRight mSubRight=new CheckSubCompanyRight();
        int[] mSubCom= mSubRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
        String mSubComStr="";
        for(int i=0;i<mSubCom.length;i++){
            if(i==0)
                mSubComStr=String.valueOf(mSubCom[i]);
            else
                mSubComStr+=","+String.valueOf(mSubCom[i]);
        }
        String sql="";
        if(!mSubComStr.equals("")){
            sql = "select * from workflow_formbase where subcompanyid in("+mSubComStr +") "+sqlwhere+" order by formname";
        }else{
            sql = "select * from workflow_formbase where 1=2";
        }
        RecordSet.executeSql(sql);
        int m = 0;
        while(RecordSet.next()){
            String checktmp = "";
            m++;
        	if(m%2==0) {
        %>
			<TR class=DataLight>
			<%
				}else{
			%>
			<TR class=DataDark>
			<%
			}
			%>
				<TD style="display:none"><A HREF=#><%=RecordSet.getInt("id")%></A></TD>
				<td> <%=RecordSet.getString("formname")%></TD>
			</TR>
        <%}
        if(!mSubComStr.equals("")){
        	RecordSet.executeSql("select * from workflow_bill where subcompanyid in("+mSubComStr+") and invalid is null and detailkeyfield='mainid' order by id desc");
        	while(RecordSet.next()){
        		int tempBillId = RecordSet.getInt("id");
        		String tablename = RecordSet.getString("tablename");
        		if(tablename.equals("formtable_main_"+tempBillId*(-1))){//新创建的表单
	        		String checktmp = "";
	            int templableid = RecordSet.getInt("namelabel");
	            String tempFormName = SystemEnv.getHtmlLabelName(templableid,user.getLanguage());
	            if (tempFormName == null) {
	            	tempFormName = "";
	            }
	            if(!formname.equals("") && tempFormName.indexOf(formname)==-1) continue;
	            m++;
	        	if(m%2==0) {
	        %>
				<TR class=DataLight>
				<%
					}else{
				%>
				<TR class=DataDark>
				<%
				}
				%>
					<TD style="display:none"><A HREF=#><%=tempBillId%></A></TD>
					<td> <%=SystemEnv.getHtmlLabelName(templableid,user.getLanguage())%></TD>
				</TR>
        	<%}
        	}
        }
    }else{
    	int m = 0;
        while(FormComInfo.next()){
            String checktmp = "";
            if(!formname.equals("") && FormComInfo.getFormname().indexOf(formname)==-1) continue;
        	m++;
        	if(m%2==0) {
        %>
			<TR class=DataLight>
			<%
				}else{
			%>
			<TR class=DataDark>
			<%
			}
			%>
				<TD style="display:none"><A HREF=#><%=FormComInfo.getFormid()%></A></TD>
				<td> <%=FormComInfo.getFormname()%></TD>
			</TR>
        <%}
        RecordSet.executeSql("select * from workflow_bill where invalid is null and detailkeyfield='mainid' order by id desc");
      	while(RecordSet.next()){
      		int tempBillId = RecordSet.getInt("id");
      		int templableid = RecordSet.getInt("namelabel");
      		//System.out.println("templableid:"+templableid);
      		String tablename = RecordSet.getString("tablename");
      		if(tablename.equals("formtable_main_"+tempBillId*(-1))){
      		String checktmp = "";
      		if(SystemEnv.getHtmlLabelName(templableid,user.getLanguage())==null)  continue;
      		if(!formname.equals("") && SystemEnv.getHtmlLabelName(templableid,user.getLanguage()).indexOf(formname)==-1) continue;
      		m++;
        	if(m%2==0) {
        %>
			<TR class=DataLight>
			<%
				}else{
			%>
			<TR class=DataDark>
			<%
			}
			%>
				<TD style="display:none"><A HREF=#><%=tempBillId%></A></TD>
				<td> <%=SystemEnv.getHtmlLabelName(templableid,user.getLanguage())%></TD>
			</TR>
    		<%}
    		}
    } } else {%>
    <%
    RecordSet.executeSql("select * from workflow_bill where invalid is null");
    int m = 0;
    while(RecordSet.next()){
    	int tmpid = RecordSet.getInt("id");
    	int tmplable = RecordSet.getInt("namelabel");
     	String checktmp = "";
     	String tablename = RecordSet.getString("tablename");
     	if(tablename.equals("formtable_main_"+tmpid*(-1))) continue;
     	String lbname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
     	if(!formname.equals("") && lbname.indexOf(formname)==-1) continue;
			m++;
        	if(m%2==0) {
        %>
			<TR class=DataLight>
			<%
				}else{
			%>
			<TR class=DataDark>
			<%
			}
			%>
				<TD style="display:none"><A HREF=#><%=tmpid%></A></TD>
				<td> <%=lbname%></TD>
			</TR>
<%
}
    }
%>
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

</FORM>
</BODY></HTML>

<script type="text/javascript">
function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
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
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
}


function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.formname.value='';
}
</script>