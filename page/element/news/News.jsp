<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_tabInfo" class="weaver.conn.RecordSet" scope="page" />
<%	

	ArrayList tabIdList = new ArrayList();
	ArrayList tabTitleList = new ArrayList();
	ArrayList tabWhereList = new ArrayList();
   
   String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by cast(tabId as int)";
   rs_tabInfo.execute(tabSql);
   while(rs_tabInfo.next()){
	   tabIdList.add(rs_tabInfo.getString("tabId"));
	   tabTitleList.add(rs_tabInfo.getString("tabTitle"));
	   tabWhereList.add(rs_tabInfo.getString("sqlWhere"));
  }
   
  String queryString = request.getQueryString();
  String url =ebc.getPath("news")+"NewsTabContentData.jsp";
  
%>
<%
String display ="none";
if(tabIdList.size()>1){
	display = "";
}
%>
<div id="tabContainer_<%=eid%>" class='tab2' style="display:<%=display%>">
	<table height='32' width="<%=77*(tabIdList.size()-1) %>" cellspacing='0' cellpadding='0' border='0' style="table-layout:fixed;">
		<tr>
			<%for(int i=0;i<tabIdList.size();i++){ %>
				<%if(i==0){ %>
					<td style="word-wrap:break-word;padding-top:5px;vertical-align:top;" id="tab_<%=eid%>" tabId=<%=tabIdList.get(i) %> class='tab2selected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString+"&tabWhere="+tabWhereList.get(i)%>',event)"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></td>
				<% }else{%>
					<td style="word-wrap:break-word;padding-top:5px;vertical-align:top;" id="tab_<%=eid+"_"+tabIdList.get(i)%>" tabId=<%=tabIdList.get(i) %> class='tab2unselected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString+"&tabWhere="+tabWhereList.get(i)%>',event)"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></td>
			<%	 }
			 } %>
		</tr>
	</table>
</div>
<div id="tabContant_<%=eid%>">
<%
if(tabIdList.size()>0){
%>
<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="tabId" value="<%=tabIdList.get(0)%>"/>
			<jsp:param name="tabWhere" value="<%=tabWhereList.get(0)%>"/>	

			<jsp:param name="ebaseid" value="<%=request.getParameter("ebaseid")%>"/>
			<jsp:param name="eid" value="<%=request.getParameter("eid")%>"/>
			<jsp:param name="styleid" value="<%=request.getParameter("styleid")%>"/>
			<jsp:param name="hpid" value="<%=request.getParameter("hpid")%>"/>
			<jsp:param name="subCompanyId" value="<%=request.getParameter("subCompanyId")%>"/>
	</jsp:include>
<%} %>
</div>