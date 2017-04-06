<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML>
    <HEAD>
    <%
    	String isBill = Util.null2String(request.getParameter("isBill"));
    	String name = Util.null2String(request.getParameter("formName"));
    %>
        <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    </HEAD>
    <BODY >

	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top}" ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top}";
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <COLGROUP>
            <COL width="10">
            <COL width="">
            <COL width="10">
        <TR>
			<TD height="10" colspan="3"></TD>
		</TR>
		<TR>
			<TD ></TD>
			<TD valign="top">
			
				<TABLE width=100% class=Shadow >
					<TR>
						<TD valign="top">
						
							<FORM NAME=SearchForm action="FormBillBrowser.jsp" method=post>		
								<TABLE width=100% class=ViewForm>
									<TR class=separator style="height:1px;"><TD class=Sep1 colspan=4></TD></TR>
									<TR>
										<TD width=20%><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></TD>
										<TD width=30% class=field>
											<SELECT name="isBill">
												<OPTION value="" <% if("".equals(isBill)) { %> selected <% } %> ></OPTION>
										    	<OPTION value="0" <% if("0".equals(isBill)) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></OPTION>
										    	<OPTION value="1" <% if("1".equals(isBill)) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></OPTION>
											</SELECT>
										</TD>
										<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
										<TD width=35% class=field><input class=inputstyle name=formName value="<%= name %>"></TD>
									</TR>
									<TR class=spacing><TD class=line1 colspan=4></TD></TR>
								</TABLE>
							</FORM>
						
							<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 style="width:100%;" >
								<TR class=DataHeader>
									<TH width=40%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
									<TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
								</TR>
								<TR class=Line>
									<TH colSpan=2></TH>
								</TR>
					    <!--================== 表单 ================== -->
						<%						
							boolean flag = true;
													
							String subCompanyString = "";
							
							
							int detachable = 0;
							RecordSet.executeSql("SELECT detachable from SystemSet");
					    	if(RecordSet.next())
					    	{
					    	    detachable = RecordSet.getInt("detachable");												    	    
					    	}
					    	if(1 == detachable)
					    	{
					    	    int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
					    	    
								for(int i = 0; i < subCompany.length; i++)
								{
								    subCompanyString += subCompany[i] + ",";
								}
								if(!"".equals(subCompanyString) && null != subCompanyString)
								{
								    subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
								}
					    	}
					    	
							
							String SQL = "SELECT * FROM WorkFlow_FormBase WHERE 1 = 1 ";
													
							if(!"".equals(name))
							{
							    SQL += " AND formName like '%" + name + "%' ";
							}
							if(!"".equals(subCompanyString) && null != subCompanyString)
							{
							    SQL += "AND subCompanyID IN (" + subCompanyString + ")";
							}

							if(!"1".equals(isBill))
							{
							
								RecordSet.execute(SQL);
							
								while(RecordSet.next())
								{	
								    String formName = RecordSet.getString("formName");
								    
								    String formDesc = RecordSet.getString("formDesc");
						%>
								<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
									<TD style="display:none"><A HREF=#>0</A></TD>
									<TD style="display:none"><A HREF=#><%= RecordSet.getInt("ID") %></A></TD>
									<TD><%= formName %></TD>
									<TD><%= formDesc %></TD>
								</TR>
						<%
									flag = !flag;
								}
								
								SQL = "SELECT * FROM WorkFlow_Bill";
								if(!"".equals(name)){
							    SQL += ", HtmlLabelInfo WHERE WorkFlow_Bill.nameLabel = HtmlLabelInfo.indexID AND HtmlLabelInfo.labelName like '%" + name + "%' AND languageID = " + user.getLanguage();
									if(!"".equals(subCompanyString) && null != subCompanyString)
									{
									    SQL += "AND subCompanyID IN (" + subCompanyString + ")";
									}
								}else{
									if(!"".equals(subCompanyString) && null != subCompanyString)
									{
									    SQL += " where subCompanyID IN (" + subCompanyString + ")";
									}
								}
								RecordSet.execute(SQL);
							
								while(RecordSet.next())
								{	
								    String tablename = RecordSet.getString("tablename");
								    int billid = RecordSet.getInt("ID");
								    if(!tablename.equals("formtable_main_"+billid*(-1))) continue;
								    String billName = SystemEnv.getHtmlLabelName(RecordSet.getInt("nameLabel"), user.getLanguage());
						%>
								<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
									<TD style="display:none"><A HREF=#>1</A></TD>
									<TD style="display:none"><A HREF=#><%=billid%></A></TD>
									<TD><%=billName%></TD>
									<TD><%=RecordSet.getString("formdes")%></TD>
								</TR>
						<%
									flag = !flag;
								}
							}
						%>
						
						<!--================== 单据 ================== -->
						<%
							SQL = "SELECT * FROM WorkFlow_Bill";
						
							if(!"".equals(name))
							{
							    SQL += ", HtmlLabelInfo WHERE WorkFlow_Bill.nameLabel = HtmlLabelInfo.indexID AND HtmlLabelInfo.labelName like '%" + name + "%' AND languageID = " + user.getLanguage();
							}
							
							if(!"0".equals(isBill))
							{
						
								RecordSet.execute(SQL);
	
								while(RecordSet.next())
								{
										String tablename = RecordSet.getString("tablename");
								    int billid = RecordSet.getInt("ID");
								    if(tablename.equals("formtable_main_"+billid*(-1))) continue;
								    String billName = SystemEnv.getHtmlLabelName(RecordSet.getInt("nameLabel"), user.getLanguage());
						%>
								<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
									<TD style="display:none"><A HREF=#>1</A></TD>
									<TD style="display:none"><A HREF=#><%= RecordSet.getInt("ID") %></A></TD>
									<TD><%= billName %></TD>
									<TD></TD>
								</TR>
						<%
									flag = !flag;
								}
							}
						%>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD height="10" colspan="3"></TD>
		</TR>
	</TABLE>

	</BODY>
</HTML>


<script type="text/javascript">
<!--
function btnclear_onclick(){
window.parent.returnValue = {isBill:"",id:"",name:""};
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
     window.parent.parent.returnValue = {isBill:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
	 window.parent.parent.close();
	}
}

//-->
</script>
<SCRIPT LANGUAGE=javascript>
function submitClear()
{
	btnclear_onclick();
}

function onview(objval1,objval2){
	SearchForm.listname.value=SearchForm.listname.value + objval2 + "->";
	SearchForm.parentid.value=objval1;
	SearchForm.submit();
}
</SCRIPT>
