<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String srzname=Util.null2String(request.getParameter("srzname"));
	String srzids[]=Util.null2String(request.getParameter("srzids")).split(",");
	String uid=user.getUID()+"";
	String msg="0";
	String checkSql = "select name from HrmGroup where name='"+ srzname +"' and owner=" + user.getUID();
	String sql="insert into HrmGroup(name,type,owner)values('"+srzname+"',0,'"+uid+"')";
	if(rs.execute(checkSql) && !rs.next()) {
		if(rs.execute(sql)){
			if(rs.execute("select MAX(id) m from HrmGroup")&&rs.next()){
				String 	maxid=rs.getString("m");
				for(int i=0;i<srzids.length;i++){
					if(!"".equals(srzids[i])){
						sql="insert into HrmGroupMembers(groupid,userid,usertype)values("+maxid+",'"+srzids[i]+"','')";
						rs.execute(sql);
					}
				}
				msg="1";
			}
		}
	} else {
		msg="3"; //Ë½ÈË×éÖØ¸´
	}
	out.clear();
	out.println(msg);
%>
