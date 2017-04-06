<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<link rel="stylesheet" href="/integration/css/base.css" type="text/css">
<html>
<body scroll="no" oncontextmenu=self.event.returnValue=false>
	<%

		String type=Util.null2String(request.getParameter("type"));
		String showtype=Util.null2String(request.getParameter("showtype"));
		String loadurl="";
		if("1".equals(type)){
			loadurl="/integration/dataInterlist.jsp";
		}else if("2".equals(type)){
			loadurl="/integration/heteProductslist.jsp";
		}else if("3".equals(type)){
			//loadurl="/integration/dateSource/dataSAPlist.jsp";
			///integration/dateSource/dataDMLlist.jsp
			///integration/dateSource/dataWebservicelist.jsp
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=1";
		}else if("4".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=2";
		}else if("5".equals(type)){
			loadurl="/integration/sapLog/logMainDetail.jsp";
		}
	%>
<div class="w-all relative" style="background: #F5F6FA;height:50px;">
 <div class="absolute " style="top:12px;height:38px;" id="tabNav">
 
 	<div class="left hand  m-l-30  m-r-30 item" href="/integration/dataInterlist.jsp">
		<table height="38px" <%if("1".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style=""><div class="font14 bold" style="height:25px; line-height:25px; background: url(images/sub4.png) left center no-repeat;padding-left:35px;padding-right:5px;color:#589456;"><%=SystemEnv.getHtmlLabelName(81375,user.getLanguage()) %></div></td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-30 item"  href="/integration/heteProductslist.jsp">
		<table height="38px " <%if("2".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style=""><div class="font14 bold" style="height:25px; line-height:25px; background: url(images/sub1.png) left center no-repeat;padding-left:35px;padding-right:5px;color:#589456;"><%=SystemEnv.getHtmlLabelName(81377,user.getLanguage()) %></div></td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-30 item" href="/integration/serviceReg/serviceRegMain.jsp?showtype=1">
		<table height="38px" <%if("3".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style=""><div class="font14 bold" style="height:25px; line-height:25px; background: url(images/sub2.png) left center no-repeat;padding-left:35px;padding-right:5px;color:#589456;"><%=SystemEnv.getHtmlLabelName(81380,user.getLanguage()) %></div></td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-30 item" href="/integration/serviceReg/serviceRegMain.jsp?showtype=2">
		<table height="38px" <%if("4".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style=""><div class="font14 bold" style="height:25px; line-height:25px; background: url(images/sub3.png) left center no-repeat;padding-left:35px;padding-right:5px;color:#589456;"><%=SystemEnv.getHtmlLabelName(81383,user.getLanguage()) %></div></td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>

	<div class="left hand p-r-30 item" href="/integration/sapLog/logMainDetail.jsp">
		<table height="38px" <%if("5".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style=""><div class="font14 bold" style="height:25px; line-height:25px; background: url(images/sub5.png) left center no-repeat;padding-left:35px;padding-right:5px;color:#589456;"><%=SystemEnv.getHtmlLabelName(81386,user.getLanguage()) %></div></td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
</div>
</div>

<div style="border-top:  #0b7906 solid 3px;">
	<iframe id="contentFrame" src="<%=loadurl%>"  frameborder="0" width="100%" height="90%"></iframe>
</div>
</body>

<style>
	.selected .lefttd{
		background: url('images/btn_left.png');
		width: 5px;
	}
	.selected .centertd{
		background:url('images/btn_center.png') repeat;
	}
	.selected .righttd{
		background: url('images/btn_right.png');
		width: 5px;
	}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#tabNav").find(".item").bind("click",function(){
			if(!jQuery(this).find("table").hasClass("selected")){
				jQuery(".selected").removeClass("selected");
				jQuery(this).find("table").addClass("selected");
				jQuery("#contentFrame").attr("src",jQuery(this).attr("href"))
			}
		})
	})
</script>
</html>