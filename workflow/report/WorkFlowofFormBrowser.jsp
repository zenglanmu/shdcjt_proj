<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
		<%
			String value = Util.null2String(request.getParameter("value"));
		
			String isBill = value.substring(0, value.indexOf("_"));
		  	
		  	String formID = value.substring(value.indexOf("_") + 1, value.lastIndexOf("_"));
		  	
		  	String workflowID = value.substring(value.lastIndexOf("_") + 1);		  	
			if(workflowID.equals("0")){workflowID="";}



			String workFlowName = Util.null2String(request.getParameter("workFlowName"));
            String customid = Util.null2String(request.getParameter("customid"));
			String resourceids = "";
			
			String resourcenames = "";
			
			
			if(!workflowID.equals(""))
			{
				try
				{
					String SQL = "SELECT * FROM WorkFlow_Base WHERE ID IN ( " + workflowID + ")";
					RecordSet.executeSql(SQL);
					//System.out.println(SQL);
					Hashtable hashtable = new Hashtable();
					while(RecordSet.next())
					{
					    hashtable.put(RecordSet.getString("ID"), RecordSet.getString("workFlowName"));
					}

					StringTokenizer st = new StringTokenizer(workflowID, ",");

					while(st.hasMoreTokens())
					{
						String s = st.nextToken();
						resourceids += "," + s;
						resourcenames += "," + hashtable.get(s).toString();
					}
				}
				catch(Exception e)
				{
					
				}
			}
		%>
	</HEAD>
		
	<BODY>
		<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkFlowofFormBrowser.jsp" method=post>
        <input name=customid type=hidden value="<%=customid%>">    
		<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		<DIV align=right style="display:none">
			<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit onclick="btnSearch_onclick(event);"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>				
			<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON type='button' class=btn accessKey=O id=btnok onclick="btnok_onclick(event);"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>		
			<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>				
			<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON type='button' class=btn accessKey=2 id=btnclear onclick="btnclear_onclick(event);"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		</DIV>
		<%@ include file="/systeminfo/RightClickMenu.jsp" %>
	
		<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
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
				
					<TABLE class=Shadow>
						<TR>
							<TD valign="top" width="100%" colspan="2">
								<!--================== 搜索框开始 ==================-->
								<TABLE width=100% class="ViewForm" valign="top">
									<TR class=Spacing style="height:1px;">
										<TD class=Line1 colspan=4></TD>
									</TR>							
									<TR>
										<TD width="15%"><%=SystemEnv.getHtmlLabelName(2079, user.getLanguage())%></TD>
										<TD width="35%" class=field>
											<input class=inputstyle name="workFlowName" maxlength=60 value="<%=workFlowName%>">
										</TD>
									</TR>
									<TR style="height:1px;">
										<TD class=Line colSpan=6></TD>
									</TR>							
									<TR class=Spacing style="height:1px;">
										<TD class=Line1 colspan=4></TD>
									</TR>
								</TABLE>
								<INPUT type="hidden" name="value" value="<%= isBill %>_<%= formID %>_<%= workflowID %>">
								<!--================== 搜索框结束 ==================-->
							</TD>
						</TR>
						
						<TR width="100%">
							<!--================== 显示列表 ==================-->
							<TD width="60%" valign="top">
								<TABLE  cellpadding="1"  class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0;width:100%;" align="left">
									<TR class=DataHeader>
										<TH width="0%" style="display:none"><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
										<TH width="90%"><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
									 	<TH width="7%"></TH>
									</TR>
									</TR>
									<TR>
										<TD colspan="5" width="100%">
											<DIV style="overflow-y:scroll;width:100%;height:350px">
												<TABLE width="100%" id="BrowseTable"  >
													<%
														int i = 0;													
														String subCompanyString = "";														
														String SQL = "SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'";
													
														
														int detachable = 0;
                                                        if(customid!=null&&!customid.trim().equals("")){
                                                            RecordSet.executeSql("select workflowids from WorkFlow_custom where id="+customid);
                                                            String workflowids="";
                                                            if(RecordSet.next()){
                                                                workflowids=Util.null2String(RecordSet.getString("workflowids")).trim();
                                                            }
                                                            if(!workflowids.equals("")){
                                                                SQL+=" and id in ("+workflowids+")";
                                                            }
                                                        }else{
														RecordSet.executeSql("SELECT detachable from SystemSet");
												    	if(RecordSet.next())
												    	{
												    	    detachable = RecordSet.getInt("detachable");												    	    
												    	}
												    	if(1 == detachable)
												    	{
															int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
																															
															for(int j = 0; j < subCompany.length; j++)
															{
															    subCompanyString += subCompany[j] + ",";
															}
															if(!"".equals(subCompanyString) && null != subCompanyString)
															{
															    subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
															}
												    	}	
														
															
														if(!"".equals(subCompanyString) && null != subCompanyString)
														{
														    SQL += " AND subCompanyID IN (" + subCompanyString + ")";
														}
                                                        }
														
														if(!"".equals(workFlowName) && null != workFlowName)
														{
														    SQL += " AND workFlowName LIKE '%" + workFlowName + "%'";
														}
													
														//out.println(SQL);
													
														RecordSet.executeSql(SQL);
														
														while(RecordSet.next())
														{																													
															if(i == 0)
															{
																i=1;
													%>
															<TR class=DataLight>
													<%
															}
															else
															{
																i=0;
													%>
															<TR class=DataDark>
													<%
															}
													%>
																<TD style="display:none"><A HREF=#><%= RecordSet.getString("ID") %></A></TD>
																<TD width="90%"><%= RecordSet.getString("workFlowName") %></TD>																																
															</TR>
													<%
															}
													%>
												</TABLE>
											</DIV>
										</TD>
									</TR>	            
								</TABLE>
							</TD>
							
							<!--================== 选中列表 ==================-->
							<TD width="40%" valign="top">
								<TABLE  cellspacing="1" align="left" width="100%">
									<TR>
										<TD align="center" valign="top" width="30%">
											<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
											<BR><BR>
											<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
											<BR><BR>
											<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
											<BR><BR>
											<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
											<BR><BR>
											<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
										</TD>
										<TD align="center" valign="top" width="70%">
											<select size="15" name="srcList" multiple="true" style="width:100%" class="InputStyle">																								
											</select>
										</TD>
									</TR>									
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
		</FORM>
	</BODY>
</HTML>



<script type="text/javascript">
<!--
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
	if(target.nodeName == "TD" || target.nodeName == "A"){
		var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+$($(target).parents("tr")[0].cells[1]).text() ;
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect($("select[name=srcList]")[0],newEntry);
			reloadResourceArray();
		}
	}
	}catch (en) {
		alert(en.message);
	}
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
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}
//-->
</script>
<script language="javascript">
resourceids = "<%=resourceids%>"
	resourcenames = "<%=resourcenames%>"

	function btnclear_onclick(){
	     window.parent.returnValue = {id:"",name:""};
	     window.parent.close();
	}


	function btnok_onclick(){
		setResourceStr();
		window.parent.returnValue = {id:resourceids,name:resourcenames};
		window.parent.close();
	}

	function btnsub_onclick(){
		doSearch();
	}

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	$(oOption).val(str.split("~")[0]);
	$(oOption).text(str.split("~")[1])  ;
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
}

function setResourceStr(){
	resourceids ="";
	resourcenames = "";
	var resourceidArray=new Array();
	var resourceNameArray=new Array();
	resourceidArray.toString()
	for(var i=0;i<resourceArray.length;i++){
		resourceidArray.push(resourceArray[i].split("~")[0]);
		resourceNameArray.push(resourceArray[i].split("~")[1]);
	}
	resourceids=resourceidArray.toString();
	resourcenames=resourceNameArray.toString();
}
function CheckAll(checked) {
//	alert(resourceids);
//	resourceids = "";
//	resourcenames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				resourceids = resourceids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		resourcenames = resourcenames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
 //	alert(resourceids);
}
function doSearch()
{
	setResourceStr();
	var value = document.all("value").value;
    document.all("value").value = value.substring(0, value.lastIndexOf("_")) + "_" + resourceids;

    document.SearchForm.submit();
}
</script>