<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="com.weaver.integration.util.ServiceRegTreeInfo"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
		
		String flag="0";//0保存失败,1保存成功
		//save--保存,update--修改,delete-删除
		String opera=Util.null2String(request.getParameter("opera"));
		String id=Util.null2String(request.getParameter("ids"));//表id,对于批量删除，他是一组id串
		if(!"".equals(id)&&(id.length()==(id.lastIndexOf(",")+1)))
		{
			id=id.substring(0,(id.length()-1));
		}
		String hetename=Util.null2String(request.getParameter("hetename"));
		String hetedesc=Util.null2String(request.getParameter("hetedesc"));
		String sid=Util.null2String(request.getParameter("sid"));//依赖的数据交互方式id
		
		String sql="";
		if("save".equals(opera))
		{
			if(!"".equals(hetename)&&!"".equals(sid))
			{
				sql=" insert into int_heteProducts (hetename,hetedesc,sid) values ('"+hetename+"','"+hetedesc+"','"+sid+"')";
				if(rs.execute(sql))
				{
					flag="1";
				}
			}
		}else if("update".equals(opera))
		{
			if(!"".equals(hetename)&&!"".equals(sid))
			{
				sql=" update int_heteProducts set hetename='"+hetename+"',hetedesc='"+hetedesc+"',sid='"+sid+"' where id="+id+"";
				if(rs.execute(sql))
				{
					flag="1";
				}
			}
		}else if("delete".equals(opera))
		{
				sql=" delete int_heteProducts where id in("+id+")";
				if(rs.execute(sql))
				{
					flag="1";
				}
		}
		new ServiceRegTreeInfo().removeServiceRegTreeCache();
%>
	<script type="text/javascript">
	<!--
		if(<%=flag%>==1)
		{
			alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage())%>"+"!");
		}else
		{
			alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>"+"!");
		}
		window.location.href="/integration/heteProductslist.jsp";
	//-->
	</script>
