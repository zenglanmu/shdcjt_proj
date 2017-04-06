<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int ppicturetype = Util.getIntValue(Util.null2String(request.getParameter("picturetype")),1);
	String eid = Util.null2String(request.getParameter("eid"));
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
		<link href="/page/maint/style/common.css" type="text/css" rel=stylesheet>

		<SCRIPT language="javascript" src="/js/weaver.js"></script>
		<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
		<link href="/js/jquery/ui/jquery-ui.css" type="text/css" rel=stylesheet>
		<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree.js"></script>
		<style type="">
		body{
			scroll:no;
			margin:0px;
			padding-left:10;
			padding-right:10;
		}
		</style>
	</HEAD>
	<BODY scroll=no>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			/*RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:saveData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			*/
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<FORM id="pictureForm" NAME=pictureForm STYLE="margin-bottom: 0;"
			action="/page/element/Picture/PictureOperation.jsp" method=post target="_parent">
			<input type="hidden" value="save" name="operation">
			<input type="hidden" value="<%=ppicturetype %>" name="picturetype">
			<input type="hidden" value="<%=eid %>" name="eid">
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
				<col width="10">
				<col width="100">
				<col width="10">
				</colgroup>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
				   <td width='10'></td>
					<td width="*" algin='center' valign="top" height="100%">
						<TABLE width='100%' class=Shadow height="100%">
							<tr>
								<td valign="top">
									<table width=100% height="50" class=viewform  >
										<col width="100" />
										
										<col width="*" />
										<tbody>
										<tr>
											<td class="" valign='top' style='padding-top:5;padding-left:5'>  
													<%=SystemEnv.getHtmlLabelName(22930, user.getLanguage())%>
											</td>
											<td class="">
											 <table width='100%' class=viewform cellSpacing=1>
											 <TR>
												
												<TD class="Field">
													<INPUT style='' id="pictureSrcType" type="radio" checked name="pictureSrcType" selecttype="1" value='1' />
													<%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493, user.getLanguage())%>
												
													<input  name="pictureSrc" id="pictureSrc" class="filetree" type="hidden" value="" />
												</td>
											</TR>
											
											<TR>
												
												<TD class="Field">
													<INPUT  style='' id="pictureSrcType" type="radio" name="pictureSrcType" selecttype="2" value="2" />
													URL<%=SystemEnv.getHtmlLabelName(18499, user.getLanguage())%>
												
													<input style="width:230" name="pictureUrlOther" id="pictureUrlOther" class="inputStyle" type="text" value="">&nbsp;&nbsp;<A href='#' onclick="javascript:addPicture();"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></A>
												</TD>
											</TR>
										
											
											 </table>
											</td>
											</tr>
										</tbody>
									</table>
									<div id="favouritediv"
										style="overflow-y: auto; width: 100%; height: 85%">
										<TABLE id="pictureTable"  class="ListStyle" cellSpacing=1 style="table-layout:fixed">
											<col width="5%" />
											<col width="39%" />
											<col width="20%" />
											<col width="20%" />
											<col width="8%" />
											<col width="8%" />
											<THEAD>
												<TR class=HeaderForXtalbe style=' height:25px! important'>
													<TH><INPUT id="pictureAllCheck" name="pictureAllCheck" value="1" type=checkbox onclick="checkAllChkBox(this.checked);"></TH>
													<TH title=<%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%>>
														&nbsp;<%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%>&nbsp;
													</TH>
													<TH title=<%=SystemEnv.getHtmlLabelName(22931, user.getLanguage())%>>
														&nbsp;<%=SystemEnv.getHtmlLabelName(22931, user.getLanguage())%>&nbsp;
													</TH>
													<TH title=<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>>
														&nbsp;<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>&nbsp;
													</TH>
													<TH title=<%=SystemEnv.getHtmlLabelName(88, user.getLanguage())%>>
														&nbsp;<%=SystemEnv.getHtmlLabelName(88, user.getLanguage())%>
													</TH>
													<TH class=Header>
														&nbsp;<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%>
													</TH>
												</TR>
											</THEAD>
											<TBODY>
												<TR class=Line>
													<TH colSpan=5></TH>
												</TR>
												<TR id="copydata" style="display:none;VERTICAL-ALIGN: middle" onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor='#FFFFFF'">
													<TD>
														<INPUT id="pictureCheck" name="pictureCheck" value="0" type=checkbox onclick="if(this.checked){this.value='1';}else{this.value='0';}">
														<INPUT id="pictureid" name="pictureid" value="" type=hidden>
													</TD>
													<TD align=left>
														&nbsp;<input nowrap id="pictureUrl" title="" style="background-color: transparent; border: 0px; width:100%;" readonly="true" name="pictureUrl" value="">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureName" maxlength=1000 style="width:90%;" name="pictureName" value="" class="inputStyle">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureLink" maxlength=1000 style="width:90%;" name="pictureLink" value="" class="inputStyle">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureOrder" style="width:90%;" name="pictureOrder" value="0" class="inputStyle" onblur="checkNum(this);">
													</TD>
													<TD>
														&nbsp;<A id="pictureOperation" href="#" onclick="javascript:deletePicture(this,'');"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></A>&nbsp;
													</TD>
												</TR>
												<%
													String trclass = "";
													String sql = "select * from picture where picturetype="+ppicturetype+" and eid='"+eid+"' order by pictureOrder";
													rs.executeSql(sql);
													while(rs.next())
													{
														if(!"DataLight".equals(trclass))
														{
															trclass = "DataLight";
														}
														else
														{
															trclass = "DataDark";
														}
														String id = rs.getString("id");
														String pictureurl = rs.getString("pictureurl");
														//String picturename = Util.toHtml(rs.getString("picturename"));
														String picturename = rs.getString("picturename");
														String picturelink = rs.getString("picturelink");
														String picturetype = rs.getString("picturetype");
														int pictureOrder = Util.getIntValue(rs.getString("pictureOrder"),0);
														
												%>
												<TR class=<%=trclass %> style="VERTICAL-ALIGN: middle" id="<%=id %>" onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor='#FFFFFF'">
													<TD>
														<INPUT id="pictureCheck" name="pictureCheck" value="0" type=checkbox onclick="if(this.checked){this.value='1';}else{this.value='0';}">
														<INPUT id="pictureid" name="pictureid" value="<%=id %>" type=hidden>
													</TD>
													<TD align=left title="<%=pictureurl %>">
														&nbsp;<input nowrap title="<%=pictureurl %>" id="pictureUrl" style="background-color: transparent; border: 0px; width:100%;" readonly="true" name="pictureUrl" value="<%=pictureurl %>" class="inputStyle">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureName" style="width:90%;" maxlength="1000" name="pictureName" value="<%=picturename %>" class="inputStyle">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureLink" style="width:90%;" name="pictureLink" value="<%=picturelink %>" class="inputStyle">
													</TD>
													<TD align=left>
														&nbsp;<input id="pictureOrder" style="width:90%;" name="pictureOrder" value="<%=pictureOrder %>" class="inputStyle" onblur="checkNum(this);">
													</TD>
													<TD>
														&nbsp;<A href="#" onclick="javascript:deletePicture(this,'<%=id %>');"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></A>&nbsp;
													</TD>
												</TR>
												<TR vAlign="top">
													<TD class="line" colSpan="6"></TD>
												</TR>
												<%
												} 
												%>
											</TBODY>
										</TABLE>
									</div>
								</td>
							</tr>
						</TABLE>
					</td>
					<td width='10'></td>
				</tr>
				<tr>
					<td width=100% align="center" valign="top" colspan=3>
						<BUTTON class=btnSave accessKey=O id=btnclear onclick="javascript:submitData()">
							<U>O</U>-<%=SystemEnv.getHtmlLabelName(16631, user.getLanguage())%></BUTTON>
						<BUTTON class=btnReset accessKey=T id=btncancel
							onclick="javascript:window.returnValue = 0;window.parent.close();">
							<U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
					</td>
				</tr>
			</table>
		</FORM>
	</BODY>
</HTML>
<script type="text/javascript">
	 var trclass = "<%=trclass %>";
	 var delImg = "";
	 function addPicture()
	 {
	 	//获取图片类型,1为服务器上的图片;2为图片链接
	 	var pictureSrcTypes = document.getElementsByName("pictureSrcType");
	 	var pictureSrcType = null;
	 	for(var i=0;i<pictureSrcTypes.length;i++)
	 	{
	 		pictureSrcType = pictureSrcTypes[i];
	 		if(pictureSrcType.checked)
	 		{
	 			break;
	 		}
	 	}
	 	if(pictureSrcType)
	 	{
		 	var srcType = pictureSrcType.value;
		 	//获取图片的url
		 	var pictureSrc = null;
		 	if("1"==srcType)
		 	{
		 		pictureSrc = document.getElementById("pictureSrc");
		 	}
		 	else
		 	{
		 		pictureSrc = document.getElementById("pictureUrlOther");
		 		if(!isUrl(pictureSrc.value)){
		 			pictureSrc.value='';
		 			alert("<%=SystemEnv.getHtmlLabelName(25022, user.getLanguage())%>");
		 			return;
		 		}
		 	}
		 	var pictureSrcValue = pictureSrc.value;
		 	if(""==pictureSrcValue)
		 	{
		 		alert("<%=SystemEnv.getHtmlLabelName(22933, user.getLanguage())%>");
		 		return;
		 	}else if("none"==pictureSrcValue){
		 		return;
		 	}
		 	else
		 	{
		 		var oTBODY = $("#pictureTable tbody")[0];
		    	var copydata = $("#copydata")[0];
		    	
				var newTR = copydata.cloneNode(true);
				newTR.setAttribute("id","newdata");
				if("DataLight"!=trclass)
				{
					trclass = "DataLight";
				}
				else
				{
					trclass = "DataDark";
				}
				newTR.className = trclass;
				oTBODY.insertAdjacentElement("beforeEnd",newTR);	
				var newTDs = newTR.children;
	 			var pictureCheck = newTDs[0];
				var pictureUrl = newTDs[1];
				var pictureName = newTDs[2];
				var pictureLink = newTDs[3];
				var pictureUrlInput = pictureUrl.children[0];
				pictureUrlInput.value = pictureSrcValue;
				pictureUrlInput.title = pictureSrcValue;
				pictureUrl.title=pictureSrcValue;
				newTR.style.display="";
				newTR.setAttribute("id","0");
				pictureSrc.value = "";
				
		 	}
		 }
	 }
	 function deletePicture(o,id)
	 {
	 	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	 	if(confirm(str)){
		 	var oTable = document.getElementById("pictureTable");
		 	var pictureTr = o.parentNode.parentNode;
	 		var lineindex = pictureTr.rowIndex;
	 		oTable.deleteRow(lineindex);
 		}
	 }
	
	function deleteData()
	{
		if($("input[name='pictureCheck'][checked=true]").length==0){
			alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>")
			return;
		}
		var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
		
		if(confirm(str))
	    {
			var chkboxElems= document.getElementsByName("pictureCheck");
	    	$("input[name='pictureCheck']").each(function(){
	    		if($(this).attr("checked")&&$(this).parent().parent().css("display")!='none'){
	    			$(this).parent().parent().next().remove(); 
	    			$(this).parent().parent().remove();
	    		}
	    	})
	    }
	    
	}
	
	 
	 function submitData()
	 {
	 	var formParams = $("#pictureForm").serialize();
	 	$.ajax({
		   type: "POST",
		   url: "/page/element/Picture/PictureOperation.jsp",
		   data: formParams,
		   success: function(msg)
		   {
		   	  window.returnValue = 0;
		   	  window.parent.close();
		   }
		});  
	 }
	 function checkAllChkBox(btnChecked)
	{
	    var chkboxElems= document.getElementsByName("pictureCheck");
	    for (j=0;j<chkboxElems.length;j++)
	    {
	        if (btnChecked) 
	        {
	        	if(chkboxElems[j].style.display!='none'){
	            	chkboxElems[j].checked = true ;		
	            }	
	        } 
	        else 
	        {       
	            chkboxElems[j].checked = false ;
	        }
	    }
	}
	function checkNum(o)
	{
		var ordernum = o.value;
		var r = /^-?[0-9]+$/g;　　//整数 
        var flag = r.test(ordernum);
        if(!flag)
        {
        	o.value = "0";
        	o.focus();
   			return;
        }
	}
	function isUrl(url)
	{
		 return url.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/);
	}
	$("#pictureSrc").filetree({call:addPicture});
</SCRIPT>