<%@ page contentType="text/html;charset=GBK" language="java"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="sun.misc.BASE64Decoder" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.net.InetAddress"%>
<%@ page import="java.net.UnknownHostException"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
	
<%
    String sysid = Util.null2String(request.getParameter("id"));//系统标识
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
	String ncaccountcode = "";
	if (RecordSet.next()) {
		baseparam1 = RecordSet.getString("baseparam1");
		baseparam2 = RecordSet.getString("baseparam2");
		basetype1 = Util.getIntValue(RecordSet.getString("basetype1"),0);
		basetype2 = Util.getIntValue(RecordSet.getString("basetype2"),0);
		iurl = RecordSet.getString("iurl");
		ourl = RecordSet.getString("ourl");
		ncaccountcode = RecordSet.getString("ncaccountcode");
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

	String strParam = "";
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
			if (RecordSet1.next()) {
				paramvalue = RecordSet1.getString("paramvalue");
			}
		} else if (paramtype == 2) {//分部
			paramvalue = "" + user.getUserSubCompany1();
		} else if (paramtype == 3) {//部门
			paramvalue = "" + user.getUserDepartment();
		}
		strParam += "&" + paramname + "=" + paramvalue;
	}

	String value=request.getRequestedSessionId();
	String ncnode=request.getParameter("tourl");
	String key =value;
		
    SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	String workdate = f.format(new Date());

	URL url = new URL(serverurl+"/service/RegisterServlet?key="+key+"&accountcode="+ncaccountcode+"&workdate="+workdate+"&language=simpchn&usercode="+account+"&pwd="+password+strParam);
	URLConnection uc = url.openConnection();

	uc.setConnectTimeout(24000);
	uc.setReadTimeout(24000);
	uc.setDoOutput(true);
	
	HttpURLConnection httpconn = (HttpURLConnection) uc;
	String str_return = httpconn.getResponseMessage();

	if (str_return.equals("OK")) {
		response.sendRedirect(serverurl+"/login.jsp?key="+key+"&ncnode="+ncnode);
	}
%>