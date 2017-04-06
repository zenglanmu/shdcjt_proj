<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=GBK" language="java"%>
<%
	String sysid = Util.null2String(request.getParameter("id"));//系统标识
	String gopage = Util.null2String(request.getParameter("gopage"));//登陆后直接显示哪个页面
	String account = "";
	String password = "";
	String logintype = "1";//访问类型
	String baseparam1 = "username";//账号参数名
	String baseparam2 = "password";//密码参数名
	int basetype1 = 0;//是否使用ecology账号
	int basetype2 = 0;//是否使用ecology密码
	RecordSet.executeSql("select * from outter_sys where sysid='"+ sysid + "'");
	String serverurl = "AccountSetting.jsp?sysid=" + sysid;
	String iurl = "";
	String ourl = "";
	String typename = "";
	if (RecordSet.next()) {
		baseparam1 = RecordSet.getString("baseparam1");
		baseparam2 = RecordSet.getString("baseparam2");
		basetype1 = Util.getIntValue(RecordSet.getString("basetype1"),0);
		basetype2 = Util.getIntValue(RecordSet.getString("basetype2"),0);
		iurl = RecordSet.getString("iurl");
		ourl = RecordSet.getString("ourl");
		typename = RecordSet.getString("typename");
	}

	RecordSet.executeSql("select account,password,logintype from outter_account where sysid='"+ sysid + "' and userid=" + user.getUID());
	if (RecordSet.next()) {
		account = RecordSet.getString("account");
		password = RecordSet.getString("password");
		if (basetype1 == 1) {//使用ecology账号
			account = user.getLoginid();
		}
		if (basetype2 == 1) {//使用ecology密码
			password = (String) session.getAttribute("password");
		}
		logintype = RecordSet.getString("logintype");
		if (logintype.equals("1"))
			serverurl = iurl;
		else
			serverurl = ourl;
	}
	if (serverurl.indexOf("AccountSetting.jsp") > -1) {
		response.sendRedirect(serverurl);
		return;
	}
	
	if("1".equals(typename)) {
		response.sendRedirect("NcEntrance.jsp?id="+sysid);
		return;
	}
	
	String str = "<html><body>\n"
			+ "<form name=Loginform action='"
			+ serverurl
			+ "' method=post target='_self'><INPUT type='hidden' NAME='gopage' VALUE='"
			+ gopage + "'>";
	RecordSet.executeSql("select * from outter_sysparam where sysid='"+ sysid + "' order by indexid");
	while (RecordSet.next()) {
		int paramtype = Util.getIntValue(RecordSet.getString("paramtype"), 0);
		String paramname = RecordSet.getString("paramname");
		String paramvalue = RecordSet.getString("paramvalue");
		if (paramtype == 0) {//固定值
			;
		} else if (paramtype == 1) {//用户输入
			RecordSet1.executeSql("select * from outter_params where sysid='"
							+ sysid
							+ "' and userid="
							+ user.getUID()
							+ " and paramname='" + paramname + "'");
			if (RecordSet1.next())
				paramvalue = RecordSet1.getString("paramvalue");

		} else if (paramtype == 2) {//分部
			paramvalue = "" + user.getUserSubCompany1();
		} else if (paramtype == 3) {//部门
			paramvalue = "" + user.getUserDepartment();
		}
		str += "<INPUT type='hidden' NAME='" + paramname + "' VALUE='"+ paramvalue + "'>";
	}
	str += "<INPUT type='hidden' NAME='" + baseparam1 + "' VALUE='"
			+ account + "'>" + "<INPUT type='hidden' NAME='"
			+ baseparam2 + "' VALUE='" + password + "'>";

	if (sysid.equals("1")) {
		//todo,add yourselves html fields
		str += "</form></body></html>"
				+ "<script>Loginform.submit();</script>";
		out.print(str);
	} else if (sysid.equals("2")) {
		//todo,add yourselves html fields
		str += "</form></body></html>"
				+ "<script>Loginform.submit();</script>";
		out.print(str);
	} else {
		str += "</form></body></html>"
				+ "<script>Loginform.submit();</script>";
		out.print(str);
	}
%>



