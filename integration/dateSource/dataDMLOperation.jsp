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
		String sourcename=Util.null2String(request.getParameter("sourcename"));
		int DBtype=Util.getIntValue(request.getParameter("DBtype"),1);
		String serverip=Util.null2String(request.getParameter("serverip"));
		int port=Util.getIntValue(request.getParameter("port"),1433);
		String dbname=Util.null2String(request.getParameter("dbname"));
		String username=Util.null2String(request.getParameter("username"));
		String password=Util.null2String(request.getParameter("password"));
		int minConnNum=Util.getIntValue(request.getParameter("minConnNum"),10);
		int maxConnNum=Util.getIntValue(request.getParameter("maxConnNum"),50);
		String datasourceDes=Util.null2String(request.getParameter("datasourceDes"));
		String sql="";
		if("save".equals(opera))
		{
			sql=" insert into dml_datasource (hpid,sourcename,DBtype,serverip,port,dbname,username,password,minConnNum,maxConnNum,datasourceDes)";
			sql+=" values ('"+hpid+"','"+sourcename+"','"+DBtype+"','"+serverip+"','"+port+"','"+dbname+"','"+username+"','"+password+"','"+minConnNum+"','"+maxConnNum+"','"+datasourceDes+"')";
			if(rs.execute(sql))
			{
				flag="1";
			}
			
		}else if("update".equals(opera))
		{
			sql=" update dml_datasource set hpid='"+hpid+"',sourcename='"+sourcename+"',DBtype='"+DBtype+"',serverip='"+serverip+"',port='"+port+"',dbname='"+dbname+"',username='"+username+"',password='"+password+"',minConnNum='"+minConnNum+"',maxConnNum='"+maxConnNum+"',datasourceDes='"+datasourceDes+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
			}
		}else if("delete".equals(opera))
		{
				sql=" delete dml_datasource where id in("+id+")";
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
		window.location.href="/integration/dateSource/dataDMLlist.jsp?hpid=<%=hpid%>";
//-->
</script>
