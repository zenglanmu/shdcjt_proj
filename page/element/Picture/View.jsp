<%@ page language="java" contentType="text/html; charset=GBK"%>

<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<%
String height = (String)valueList.get(nameList.indexOf("height"));
String width = (String)valueList.get(nameList.indexOf("width"));
if("".equals(height)){
	height ="75";
}
if("".equals(width)){
	width = "75";
}
String highopen = (String)valueList.get(nameList.indexOf("highopen"));
String pictureShowType = (String)valueList.get(nameList.indexOf("pictureShowType"));
String autoShow = (String)valueList.get(nameList.indexOf("autoShow"));
String autoShowSpeed = (String)valueList.get(nameList.indexOf("autoShowSpeed"));
String needbutton = (String)valueList.get(nameList.indexOf("needbutton"));
if(!"1".equals(needbutton)){
	needbutton = "0";
}
String pictureheight = (String)valueList.get(nameList.indexOf("pictureheight"));
String picturewidth = (String)valueList.get(nameList.indexOf("picturewidth"));
String picturewordcount = (String)valueList.get(nameList.indexOf("picturewordcount"));
pictureheight = height;
picturewidth = width;
if("".equals(autoShowSpeed))
{
	autoShowSpeed = "20";
}
 			

%>

<%
if("1".equals(pictureShowType))
{
%>
<div id="picture_<%=eid %>" style="overflow: hidden; background-color: #FFFFFF;" >
	<table cellspacing="0" cellpadding="0" border="0" >
		<tbody>
		<%
			String ssql = "select * from picture where picturetype=1 and eid='"+eid+"' order by pictureOrder";
			rs_Setting.executeSql(ssql);
			if(rs_Setting.next())
			{
				String id = rs_Setting.getString("id");
				String pictureurl = rs_Setting.getString("pictureurl");
				String picturename = rs_Setting.getString("picturename");
				String picturelink = rs_Setting.getString("picturelink");
				String picturetype = rs_Setting.getString("picturetype");
				int pictureOrder = Util.getIntValue(rs_Setting.getString("pictureOrder"),0);
				if(picturelink.equals("")){
					picturelink="#";
				}
				String apictureurl = "1".equals(highopen)?pictureurl:"#";
				
				String aclick = "1".equals(highopen)?"return hs.expand(this);":"javascript:void(0);";
		%>
			<tr>
				<td >
					<%if("1".equals(highopen)) {%>
					<a title="<%=picturename %>" id='resourceimghref_<%=eid %>'  href='<%=apictureurl %>' onclick="<%=aclick %>" style="cursor:hand;" onFocus="this.blur()"> 
						<img id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=width %>px;height:<%=height %>px;">
					</a>
					<%}else{ %>
						<a title="<%=picturename %>" style="cursor:default;" id='resourceimghref_<%=eid %>'  onclick="<%=aclick %>"  onFocus="this.blur()"> 
						<img id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=width %>px;height:<%=height %>px;">
					</a>
					<%} %>
					<div class="highslide-caption">
						<%if(!"#".equals(picturelink)){ %>
						<a title="<%=picturename %>" style="cursor:hand;" id='resourceimghref_<%=eid %>' href="<%=picturelink %>" target="_blank"> 
							<font class=font><%=picturename %></font>
						</a>
						<%}else{ %>
							<font class=font><%=picturename %></font>
						<%} %>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<%if(!"#".equals(picturelink)){ %>
					<a title="<%=picturename %>" style="cursor:hand;" id='resourceimghref_<%=eid %>' href="<%=picturelink %>" target="_blank"> 
						<font class=font><%=picturename %></font>
					</a>
					<%}else{ %>
						<font class=font><%=picturename %></font>
					<%} %>
				</td>
			</tr>
		<%
			}
		%>
		</tbody>
	</table>
</div>
<%
}
else
{
%>
<table id="pictureTable_<%=eid %>" style="display:none;overflow: hidden; background-color: #FFFFFF;height: <%=height %>px; width: 100%;" align="center" onresize="try{setPictureWidth(<%=eid %>,<%=needbutton %>);}catch(e){}">
  <tr>
    <%if("1".equals(needbutton)){ %>
    <td VALIGN="middle" style="vertical-align:middle;">
    	<div  id="pictureback_<%=eid %>" style="cursor:hand;" class=pictureback onclick="backMarquee(<%=eid %>);"></div>
    </td><%} %>
    <td align="center">
	    <div id="picture_<%=eid %>" style="overflow:hidden;">
			<table cellspacing="0" cellpadding="0" border="0">
				<tbody>
					<tr>
						<td id="picturetd_<%=eid %>" nowrap="nowrap">
							<table width="100%" style='fixed-layout:fixed'>
								<tr>
								<%
									String sql = "select * from picture where picturetype=2 and eid='"+eid+"' order by pictureOrder";
									rs_Setting.executeSql(sql);
									while(rs_Setting.next())
									{
										String id = rs_Setting.getString("id");
										String pictureurl = rs_Setting.getString("pictureurl");
										//String picturename = Util.toHtml(rs_Setting.getString("picturename"));
										String picturename = rs_Setting.getString("picturename");
										String picturelink = rs_Setting.getString("picturelink");
										String picturetype = rs_Setting.getString("picturetype");
										int pictureOrder = Util.getIntValue(rs_Setting.getString("pictureOrder"),0);
										if(picturelink.equals("")){
											picturelink="#";
										}
										String apictureurl = "1".equals(highopen)?pictureurl:"#";
										String aclick = "1".equals(highopen)?"return hs.expand(this);":"javascript:void(0);";
									
								%>
								<td>
									<% if( "1".equals(highopen)){%>
									<a class="highslide" style="cursor:hand;" title="<%=picturename %>" id='resourceimghref_<%=eid %>' href="<%=apictureurl %>" onclick="<%=aclick %>" target="_blank" onFocus="this.blur()"> 
										<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;">
									</a>
									<%}else{ %>
										<a class="highslide" style="cursor:default;" title="<%=picturename %>" id='resourceimghref_<%=eid %>' onclick="<%=aclick %>" target="_blank" onFocus="this.blur()"> 
										<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;">
									</a>
									<%} %>
									<div class="highslide-caption" style="display:none">
										<%if(!"#".equals(picturelink)){ %>
										<a title="<%=picturename %>" style="cursor:hand;" id='resourceimghref_<%=eid %>' href="<%=picturelink %>" target="_blank"> 
											<font class=font><%=picturename %></font>
										</a>
										<%}else{ %>
											<font class=font><%=picturename %></font>
										<%} %>
									</div>
								</td>
								<%
									}
								%>
								</tr>
							</table>
						</td>
						<td id="pictureothertd_<%=eid %>" nowrap="nowrap"></td>
					</tr>
					<tr height="20px">
						<td id="picturelinktd_<%=eid %>" nowrap="nowrap" height="20px">
							<table width="100%" height="20px">
								<tr>
								<%
									rs_Setting.executeSql(sql);
									while(rs_Setting.next())
									{
										String id = rs_Setting.getString("id");
										String pictureurl = rs_Setting.getString("pictureurl");
										//String picturename = Util.toHtml(rs_Setting.getString("picturename"));
										String picturename = rs_Setting.getString("picturename");
										String picturelink = rs_Setting.getString("picturelink");
										String picturetype = rs_Setting.getString("picturetype");
										int pictureOrder = Util.getIntValue(rs_Setting.getString("pictureOrder"),0);
										String npicturename=Util.getMoreStr(picturename,Util.getIntValue(picturewordcount,8),"...");
										if(picturelink.equals("")){
											picturelink="#";
										}
								%>
								<td >
									<%if(!"#".equals(picturelink)){ %>
									
									<a  style="width:<%=picturewidth %>px;height:16px;overflow: hidden;text-overflow:ellipsis;text-decoration:none;color:black" title="<%=picturename %>" style="cursor:hand;" id='resourceimghref_<%=eid %>' href="<%=picturelink %>" target="_blank"> 
										<font class=font><%=npicturename %></font>
									</a>
									
									<%}else{ %>
										<span style="width:<%=picturewidth %>px;height:16px;overflow: hidden;text-overflow:ellipsis;white-space:nowrap;"><font class=font><%=npicturename %></font></span>
									<%} %>
								</td>
								<%
									}
								%>
								</tr>
							</table>
						</td>
						<td id="pictureotherlinktd_<%=eid %>" nowrap="nowrap"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</td>
    <%if("1".equals(needbutton)){ %>
    <td VALIGN="middle" style="vertical-align:middle;">
    	<div id="picturenext_<%=eid %>" class="picturenext" style="cursor:hand;" onclick="nextMarquee(<%=eid%>);"></div>
    </td>
    <%} %>
  </tr>
</table>
<%
}
%>
<script language="javascript">

<%

//判断是否为多张显示
if(!"1".equals(pictureShowType))
{
%>
	setPictureWidth(<%=eid%>,<%=needbutton%>);
	<%
	//判断是否为主动滚动
	if("1".equals(autoShow))
	{
	%>
		doScrollAuto('<%=eid%>','<%=needbutton%>','<%=autoShowSpeed%>')
	<%
	}
	%>
	
<%
}
%>
</SCRIPT>