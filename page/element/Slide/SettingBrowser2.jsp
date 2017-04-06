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
			padding:0;
		}
		
		</style>
	</HEAD>
	<BODY scroll=no>
		<FORM id="pictureForm" NAME=pictureForm STYLE="margin-bottom: 0;"
			action="/page/element/Picture/PictureOperation.jsp" method=post target="_parent">
			<input type="hidden" value="save" name="operation">
			<input type="hidden" value="<%=ppicturetype %>" name="picturetype">
			<input type="hidden" value="<%=eid %>" name="eid">
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
				<col width="1">
				<col width="100">
				<col width="1">
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
									
										<TABLE id="pictureTable"  class="ListStyle" cellSpacing=1 style="table-layout:fixed">
											<colgroup>
												
												<col width="190">
												<col width="190">
												<col width="190">
												<col>
												<col>
											</colgroup>
											<THEAD>
												<TR class=HeaderForXtalbe style=' height:25px! important'>
													
													<TH title=主图片 >
														<%=SystemEnv.getHtmlLabelName(26283, user.getLanguage())%>
													</TH>
													<TH title=导航样式前景图>
														<%=SystemEnv.getHtmlLabelName(26284, user.getLanguage())%>
													</TH>
													<TH title=导航样式背景图>
														&nbsp;<%=SystemEnv.getHtmlLabelName(26285, user.getLanguage())%>&nbsp;
													</TH>
													<TH title=标题>
														&nbsp;<%=SystemEnv.getHtmlLabelName(24986, user.getLanguage())%>&nbsp;
													</TH>
													<TH title=描述>
														&nbsp;<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%>
													</TH>
													<TH class=Header>
														&nbsp;<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>
													</TH>
												</TR>
											</THEAD>
											<TBODY>
												<%
													String sql="select * from slideElement where eid="+eid;
													rs.execute(sql);
													int size=0;
													while(rs.next()){
												%>
												<tr class="DataLight" id="">
													<td > 
														<input value="<%=Util.null2String(rs.getString("url1")) %>"  name="url1"  width="96%"   class="filetree pictureSrc" readonly="readonly"  />
													</td>
													<td >
														<input  value="<%=Util.null2String(rs.getString("url2")) %>"   name="url2"  width="96%" class="filetree pictureSrc" readonly="readonly"/>
													
													</td>
													<td >
														<input  value="<%=Util.null2String(rs.getString("url3")) %>"  name="url3"  width="96%" class="filetree pictureSrc"  readonly="readonly" />
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("title")) %>"  style="width:96%" class="inputstyle" name="title">
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("description")) %>"  style="width:96%" class="inputstyle" name="description">
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("link")) %>"  style="width:96%" class="inputstyle" name="link">
													</td>
												</tr>
												<% 
												size++;
													}
												while(size<4){%>
												<tr class="DataLight" id="">
													<td > 
														<input value=""  name="url1"  width="96%"   class="filetree pictureSrc" readonly="readonly"  />
													</td>
													<td >
														<input  value=""   name="url2"  width="96%" class="filetree pictureSrc" readonly="readonly"/>
													
													</td>
													<td >
														<input  value=""  name="url3"  width="96%" class="filetree pictureSrc"  readonly="readonly" />
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="title">
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="description">
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="link">
													</td>
												</tr>
													
												<%
												size++;
												}%>
											</TBODY>
										</TABLE>
								</td>
							</tr>
						</TABLE>
					</td>
					<td width='10'></td>
				</tr>
				<tr>
					<td width=100% align="center" valign="top" colspan=3>
						<BUTTON type="button" class=btnSave accessKey=O id=btnclear onclick="javascript:submitData()">
							<U>O</U>-<%=SystemEnv.getHtmlLabelName(16631, user.getLanguage())%></BUTTON>
						<BUTTON type="button" class=btnReset accessKey=T id=btncancel
							onclick="javascript:window.returnValue = 0;window.parent.close();">
							<U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
					</td>
				</tr>
			</table>
		</FORM>
	</BODY>
</HTML>
<script type="text/javascript">
	 var trclass = "DataLight";
	
	 function submitData()
	 {
	 	var formParams = $("#pictureForm").serialize();
	 	$.ajax({
		   type: "POST",
		   url: "/page/element/Slide/PictureOperation.jsp",
		   data: formParams,
		   success: function(msg)
		   {
		   	  window.returnValue = 0;
		   	  window.parent.close();
		   }
		});  
	 }
	
	
	$(".pictureSrc").filetree();
</SCRIPT>