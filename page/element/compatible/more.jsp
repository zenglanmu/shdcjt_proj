<%@ page language="java" contentType="text/html; charset=GBK"%>

<%@ page import="weaver.general.Util"%>
<%@ page import = "java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.homepage.HomepageMore"%>
<%@ page import="weaver.page.element.ElementBaseCominfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	ElementBaseCominfo ebc = new ElementBaseCominfo();
	HomepageMore hm = new HomepageMore();
	String tranMethod = Util.null2String(ebc.getMoreMethod(ebaseid));
	String redirectUrl = "";
	if(!tranMethod.equals("")){
		Class tempClass = Class.forName("weaver.page.element.compatible.PageMore");		
		Method tempMethod = tempClass.getMethod(tranMethod, new Class[] {String.class });
		Constructor ct = tempClass.getConstructor(null);
		redirectUrl =(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid});
	}
	if(!tabid.equals("")){
		redirectUrl=redirectUrl+"&tabid="+tabid;
	}else{
		User user = HrmUserVarify.getUser (request , response);
		if(user!=null){
			rs.execute("select currenttab from hpcurrenttab where eid="+eid
					+ " and userid="
					+ user.getUID()
					+ " and usertype="
					+ user.getType());
			if(rs.next()){
				tabid =rs.getString("currenttab");
			}
		}else{
			if(ebaseid.equals("7")||ebaseid.equals("1")||ebaseid.equals("news")){
				rs.execute("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by tabId");	
			}else{
				rs.execute("select tabId,tabTitle from hpsetting_wfcenter where eid="+eid+" order by tabId");
			}
			if(rs.next()){
				tabid = rs.getString("tabId");
			}
		}
		if(!tabid.equals("")){
			redirectUrl=redirectUrl+"&tabid="+tabid;
		}
	}
	response.sendRedirect(redirectUrl);
%>