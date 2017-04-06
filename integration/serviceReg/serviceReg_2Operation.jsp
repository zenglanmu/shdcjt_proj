<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
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
		String poolid=Util.null2String(request.getParameter("poolid"));
		String serdesc=Util.null2String(request.getParameter("serdesc"));
		String regname=Util.null2String(request.getParameter("regname"));
		String sql="";
		if("save".equals(opera))
		{
			sql=" insert into ws_service (poolid,serdesc,regname,hpid)";
			sql+=" values ('"+poolid+"','"+serdesc+"','"+regname+"','"+hpid+"')";
			if(rs.execute(sql))
			{
				flag="1";
			}
			
		}else if("update".equals(opera))
		{
			sql=" update ws_service set poolid='"+poolid+"',serdesc='"+serdesc+"',regname='"+regname+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
			}
		}else if("delete".equals(opera))
		{
				sql=" delete ws_service where id in("+id+")";
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
			alert("操作成功!");
		}else
		{
			alert("操作失败!");
		}
		window.location.href="/integration/serviceReg/serviceReg_2list.jsp?hpid="+<%=hpid%>;
//-->
</script>
