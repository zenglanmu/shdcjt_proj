<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
		
		String flag="0";//0保存失败,1保存成功
		//save--保存,update--修改,delete-删除
		String opera=Util.null2String(request.getParameter("opera"));
		String id=Util.null2String(request.getParameter("ids"));
		if(!"".equals(id)&&(id.length()==(id.lastIndexOf(",")+1)))
		{
			id=id.substring(0,(id.length()-1));
		}
		String hpid=Util.null2String(request.getParameter("hpid"));
		String poolname=Util.null2String(request.getParameter("poolname")); 
		String wsdladdress=Util.null2String(request.getParameter("wsdladdress"));
		String pooldesc=Util.null2String(request.getParameter("pooldesc"));
		String sql="";
		if("save".equals(opera))
		{
			sql=" insert into ws_datasource (hpid,poolname,wsdladdress,pooldesc)";
			sql += " values ('"+hpid+"','"+poolname+"','"+wsdladdress+"','"+pooldesc+"')";
			if(rs.execute(sql))
			{
				flag="1";
			}
			
		}else if("update".equals(opera))
		{
			sql=" update ws_datasource set hpid='"+hpid+"',poolname='"+poolname+"',wsdladdress='"+wsdladdress+"',pooldesc='"+pooldesc+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
			}
		}else if("delete".equals(opera))
		{
				sql=" delete ws_datasource where id in("+id+")";
				if(rs.execute(sql))
				{
					flag="1";
				}
		}
%>

<script type="text/javascript">
	<!--
		if(<%=flag%>==1)
		{
			alert("<%=SystemEnv.getHtmlLabelName(30648,user.getLanguage())%>!");
		}else
		{
			alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>!");
		}
		window.location.href="/integration/dateSource/dataWebservicelist.jsp?hpid=<%=hpid%>";
//-->
</script>
