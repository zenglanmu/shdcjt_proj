<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<script type="text/javascript" src="/js/jquery/jquery.scrollTo.js"></script>
<script type="text/javascript">
function backMarqueeDiv7(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft - 100 + 'px')}, 500 );
}

function nextMarqueeDiv7(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft + 100 + 'px')}, 500 );
}
</script>

<style type="text/css" rel="STYLESHEET">
.picturebackhp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_left.gif) no-repeat 0 0;
}
.picturenexthp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_right.gif) no-repeat 0 0;
}
</style>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>

<%	

	ArrayList tabIdList = new ArrayList();
	ArrayList tabTitleList = new ArrayList();
	ArrayList tabWhereList = new ArrayList();
	
   
   
	  
   String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by cast(tabId as int)";

   rs.execute(tabSql);
   while(rs.next()){
	   tabIdList.add(rs.getString("tabId"));
	   tabTitleList.add(rs.getString("tabTitle"));
	   tabWhereList.add(rs.getString("sqlWhere"));
   }
   
   //校验当前tab信息
   tabSql="select tabId from hpNewsTabInfo where eid="+eid+" and tabid='"+currenttab+"'";
   rs.execute(tabSql);
   if(!rs.next()){
	   if(tabIdList.size()>0){
	       currenttab =(String)tabIdList.get(0);
	   }
   }
  
  
  
   
  String queryString = request.getQueryString();
  String url = "/page/element/compatible/NewsTabContentData.jsp";
  
%>
<%
String display ="none";
if(tabIdList.size()>1){
	display = "";
}
int sumLength = 0;
%>
<div style="border:0px;positon:absolute;width:100%;">
<div id="tabnavprev_<%=eid%>" style="cursor:hand;position:relative;float:left;left:-5px;top:-5px;" class="picturebackhp" onclick="backMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
<div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:right;right:-5px;top:-5px;" class="picturenexthp" onclick="nextMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
<div id="tabContainer_<%=eid%>" class='tab2' style="width:100%;overflow:hidden;display:none;">
	<table height='32' width="<%=77*tabIdList.size() %>"  cellspacing='0' cellpadding='0' border='0' style="table-layout:fixed;">
		<tr>
			<%for(int i=0;i<tabIdList.size();i++){ 
				int length = 77;
				String alength = Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"));
				int lengthByte = alength.getBytes().length;
				if(lengthByte*8>77){
					length = lengthByte * 7;
				}
				length = 77;
				%>
				<%if(currenttab.equals(tabIdList.get(i))){ %>
					<td style="word-wrap:break-word;padding-top:5px;vertical-align:top;" id="tab_<%=eid%>" tabId=<%=tabIdList.get(i) %> class='tab2selected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString+"&tabWhere="+tabWhereList.get(i)%>',event)"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></td>
				<% }else{%>
					<td style="word-wrap:break-word;padding-top:5px;vertical-align:top;"  id="tab_<%=eid+"_"+tabIdList.get(i)%>" tabId=<%=tabIdList.get(i) %> class='tab2unselected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString+"&tabWhere="+tabWhereList.get(i)%>',event)"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></td>
			<%	 }
				sumLength += length;
			 }
			 sumLength = sumLength + 36;%>
		</tr>
	</table>
</div>
</div>

<div id="tabContant_<%=eid%>">
<%
if(tabIdList.size()>0){
%>
<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="tabId" value="<%=currenttab%>"/>
			<jsp:param name="tabWhere" value="<%=tabWhereList.get(tabIdList.indexOf(currenttab))%>"/>	

			<jsp:param name="ebaseid" value="<%=request.getParameter("ebaseid")%>"/>
			<jsp:param name="eid" value="<%=request.getParameter("eid")%>"/>
			<jsp:param name="styleid" value="<%=request.getParameter("styleid")%>"/>
			<jsp:param name="hpid" value="<%=request.getParameter("hpid")%>"/>
			<jsp:param name="subCompanyId" value="<%=request.getParameter("subCompanyId")%>"/>
	</jsp:include>
<%} %>
</div>

<script type="text/javascript">
	var divWidth = "<%=sumLength%>";
	var hpWidth = $("#content_"+<%=eid%>).width();
	
	if(parseFloat(divWidth) > parseFloat(hpWidth)) {
		$("#tabnavprev_<%=eid%>").css("display","block");
		$("#tabnavnext_<%=eid%>").css("display","block");
		
		<%if(tabIdList.size()>1){%>
		$("#tabContainer_<%=eid%>").css("width", $("#content_<%=eid%>").width() - 42);
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "18px");
		$("#tabContainer_<%=eid%>").css("margin-right", "18px"); 
		<%}else{
		%>
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}else{
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
	
		<%if(tabIdList.size()>1){%>
		$("#tabContainer_<%=eid%>").css("width", $("#content_<%=eid%>").width() );
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "0");
		$("#tabContainer_<%=eid%>").css("margin-right", "0"); 
		<%}else{
		%>
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}
</script>