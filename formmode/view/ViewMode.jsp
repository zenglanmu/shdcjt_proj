<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver.js"></SCRIPT>
		<style>
			#loading {
				Z-INDEX: 20001; BORDER-BOTTOM: #ccc 1px solid; POSITION: absolute; BORDER-LEFT: #ccc 1px solid; PADDING-BOTTOM: 8px; PADDING-LEFT: 8px; PADDING-RIGHT: 8px; BACKGROUND: #ffffff; HEIGHT: auto; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 8px; TOP: 40%; LEFT: 45%
			}
		</style>
	</HEAD>
<%
	//type=0&modeId=2&formId=-241&billid=103
	String type = Util.null2String(request.getParameter("type"));
	String modeId = Util.null2String(request.getParameter("modeId"));
	String formId = Util.null2String(request.getParameter("formId"));
	String billid = Util.null2String(request.getParameter("billid"));
	int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
	String sql = "";
	String iframeList = "";

	ModeRightInfo.setModeId(Util.getIntValue(modeId));
	ModeRightInfo.setType(Util.getIntValue(type));
	ModeRightInfo.setUser(user);
	boolean isRight = false;
	boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
	boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
	if(Util.getIntValue(type) == 1 || Util.getIntValue(type) == 3){//新建、监控权限判断
		isRight = ModeRightInfo.checkUserRight(Util.getIntValue(type));
	}
	ModeShareManager.setModeId(Util.getIntValue(modeId));
	if(Util.getIntValue(type) == 0 || Util.getIntValue(type) == 2){//查看、编辑权限
		String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",user);
		//System.out.println("select * from "+rightStr+" as t ");
		rs.executeSql("select * from "+rightStr+" t where sourceid="+billid);
		if(rs.next()){
			int MaxShare = rs.getInt("sharelevel");
			isRight = true;
			if(MaxShare > 1) {
				isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
				if(MaxShare == 3) isDel = true;		//有完全控制权限的出现删除按钮
			}
		}
	}

	if(!isRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	
	//获得主表的数据
	FieldInfo.setUser(user);
	HashMap hm = FieldInfo.getMainTableData(modeId,formId,billid);
	
	//获得模块的主字段
	HashMap modeMainFieldMap = FieldInfo.getModeFieldList(modeId);

%>
<BODY style="overflow-y:auto">
	
<table width="100%" style="min-width:820px;height:100%;">
	<colgroup>
		<col width="5">
		<col width="">
		<col width="5">
	</colgroup>
	<tr style="height:1px;">
		<td></td>
		<td>
			
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
			  	<tr>
			  		<td width="6px" height="28px;" style="">
						<div id="tab-left" class="tab-left-selected" style="">
							
						</div>
					</td>
					<td>
						<div id="tab-center" >
							<ul>
				   					<%
				   						String modename = "";
				   						sql = "select * from modeinfo where id = " + modeId;
				   						rs.executeSql(sql);
				   						while(rs.next()){
				   							modename = rs.getString("modename");
				   						}
				   						String mainmodehreftarget = "/formmode/view/AddFormMode.jsp?isfromTab=1&type="+type+"&modeId="+modeId+"&formId="+formId+"&billid="+billid+"&fromSave="+fromSave;
				   						mainmodehreftarget = mainmodehreftarget+"&"+Util.null2String(request.getQueryString());
				   						iframeList=" <iframe src='"+mainmodehreftarget+"'  id='iframepage'  frameBorder=0 scrolling=auto width=100% height='100%' onload=\"loading()\"  style='display:block;'></iframe>";
				   					%>
				   					<li sid="<%=0%>" first="yes" url="<%=mainmodehreftarget%>" title="<%=modename%>">
					   					<div class="tab-selected tab-item">
						   					<a href='javascript:void(0)'>
						   						<%=modename%>
						   					</a>
					   					</div>
				   					</li>
				   					
						   		<%
						   			//只查询tab页
						   			sql = "select id,expendname,showtype,opentype,hreftype,hrefid,hreftarget,showcondition,showorder,issystem from mode_pageexpand where modeid = "+modeId+" and isshow = 1 and showtype = 1 and isbatch in(0,2) order by showorder asc";
						   			rs.executeSql(sql);
						   			while(rs.next()){
						   				String detailid = Util.null2String(rs.getString("id"));
						   		    	String expendname = Util.null2String(rs.getString("expendname"));
						   		    	String hreftitle = Util.null2String(rs.getString("expendname"));
						   		    	String hreftarget = Util.null2String(rs.getString("hreftarget"));
						   		    	String showcondition = Util.null2String(rs.getString("showcondition"));
						   		    	int hreftype = rs.getInt("hreftype");
						   		    	int hrefid = rs.getInt("hrefid");
						   		    	boolean isshowcurrentpage = true;
										if(!showcondition.equals("")){
											isshowcurrentpage = false;
											sql = "select 1 from formtable_main_" + Math.abs(Util.getIntValue(formId)) + " where id = " + billid + " and "+showcondition;
											RecordSet.executeSql(sql);
											if(RecordSet.next()){
												isshowcurrentpage = true;
											}
										}
						   		    	if(!isshowcurrentpage){
						   		    		continue;
						   		    	}
						   		    	
						   		    	if(hreftype==1&&hrefid>0){//模块
						   		    		sql = "select * from modeinfo where id = " + hrefid;
						   		    		RecordSet.executeSql(sql);
						   		    		//out.println(sql);
											if(RecordSet.next()){
												int modeformid = RecordSet.getInt("formid");
												String sqlwhere = FieldInfo.getRelateSqlWhere(modeId,hrefid,hreftype,hreftarget,hm);
												//sql = "select id from formtable_main_" + Math.abs(modeformid) + " where parentbillid = " + billid + " and parentmodeid = " + modeId;
												//查询数据是否存在，如果存在的话，就进入查看页面，如果不存在，则新建
												sql = "select id from formtable_main_" + Math.abs(modeformid) + " " + sqlwhere;
												RecordSet.executeSql(sql);
												//out.println(sql);
												if(RecordSet.next()){//存在直接打开数据
													String subid = RecordSet.getString("id");
													//http://127.0.0.1:86/formmode/view/addformmode.jsp?isfromTab=1&type=0&modeId=10&formId=-257&billid=5
													hreftarget = "/formmode/view/AddFormMode.jsp?type="+type+"&modeId="+hrefid+"&formId="+modeformid+"&billid="+subid;
													//System.out.println(hreftarget);
												}else{//如果不存在，新建数据
													hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,hreftarget,hm,modeMainFieldMap);
												}
											}
						   		    	}else if(hreftype==3&&hrefid>0){//模块查询列表
						   		    		try{
						   		    			hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,hreftarget,hm,modeMainFieldMap);
						   		    		}catch(Exception e){
						   		    			out.println(e);
						   		    		}
						   		    	}else{
						   		    		hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,hreftarget,hm,modeMainFieldMap);
						   		    	}
						   		    	
						   		    	if(hreftarget.indexOf("?")>-1){
						   		    		hreftarget = hreftarget + "&isfromTab=1";
						   		    	}else{
						   		    		hreftarget = hreftarget + "?isfromTab=1";
						   		    	}

								%>
										<li sid="<%=detailid%>" url="<%=hreftarget%>" title="<%=hreftitle%>">
											<div class="tab-item" >
												<a href='javascript:void(0)'>
													<%=expendname%>
												</a>
											</div>
										</li>
								<%
						   			}
						   		%>
							</ul>
						</div>
					</td>
					<td width="6px" style="">
						<div id="tab-right" style=""></div>
					</td>
			  	</tr>
	  		</table>
		</td>
		<td></td>
	</tr>
	<tr style="height:100%">
		<td colspan="3" style="height:100%">
		  <div id="content" style="height:100%">
				<%=iframeList%>		
		  </div>
		</td>
	</tr>
</table>

<script language="javascript">

function loading(){
	$("#loading").hide();
}

$("#tab-left").addClass("tab-left-selected");

$(function(){
	initMenuWidth();
	$("#tab-center li").click(function(){
		
		$("#tab-center li .tab-selected").removeClass("tab-selected");
		$(this).children("div").addClass("tab-selected");
		$("#content iframe").css("display","none");
		var temid=$(this).attr("sid");
		if($(this).attr("first")=="yes"){
			$("#tab-left").removeClass("tab-left-unselected");
			$("#tab-left").addClass("tab-left-selected");
			$("#iframepage").css("display","block");
		}else{
			$("#tab-left").removeClass("tab-left-selected");
			$("#tab-left").addClass("tab-left-unselected");
			if($("#"+$(this).attr("sid")).attr("src")==undefined){
			  $("#content").append(	" <iframe src=''  id='"+$(this).attr("sid")+"'  frameBorder=0 onload=\"loading()\" scrolling=auto width='100%'  height='100%' onload='loading();'  style='display:none;'></iframe>");
			  $("#"+$(this).attr("sid")).attr("src",$(this).attr("url")).load(function(){});
				$("#loading").hide();
				$("#loading").show();
			}else{
				$("#loading").hide();
			}
		}
		
		$("#"+$(this).attr("sid")).css("display","block");
	});
	window.onresize=function(){
		var ifms=document.getElementsByTagName("iframe");
		for(var i=0;i<ifms.length;i++ ){
			ifms[i].height=document.body.clientHeight-getElementTop(ifms[i])-3;
		}
	}
});
function getElementTop(element){
　　var actualTop = element.offsetTop;
　　var current = element.offsetParent;

　　while (current !== null){
　　　　actualTop += current.offsetTop;
　　　　current = current.offsetParent;
　　}

　　return actualTop;
}
function initMenuWidth(){
	var tabWidth=0;
	$("#tab-center li").each(function(e,e2){
		tabWidth+=$(e2).width();
	});
	$("#tab-center ul").css("width",tabWidth+10);
}

</script>
</BODY></HTML>
