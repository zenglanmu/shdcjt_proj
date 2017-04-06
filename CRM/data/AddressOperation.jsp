<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String TypeID = Util.null2String(request.getParameter("TypeID"));
String strTemp = "";
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));
String ProcPara = "";
String fieldName = "";		// added by xys for TD2031
	fieldName = SystemEnv.getHtmlLabelName(17742,user.getLanguage());
if(method.equals("toEqual"))
{	
	RecordSet.executeProc("CRM_CustomerAddress_UEqual",TypeID+flag+CustomerID+flag+"1");

	ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
	ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+"0"+flag+"1";
	ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
	RecordSet.executeProc("CRM_Modify_Insert",ProcPara);

	ProcPara = CustomerID;
	ProcPara += flag+"ma";
	ProcPara += flag+"0";
	ProcPara += flag+"";
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	response.sendRedirect("/CRM/data/ViewAddressDetail.jsp?CustomerID="+CustomerID+"&TypeID="+TypeID);
	return;
}

if(method.equals("toNoEqual"))
{
	RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);

	ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
	ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+"1"+flag+"0";
	ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
	RecordSet.executeProc("CRM_Modify_Insert",ProcPara);

	ProcPara = CustomerID;
	ProcPara += flag+"ma";
	ProcPara += flag+"0";
	ProcPara += flag+"";
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	if(RecordSet.getCounts()<=0)
	{
		ProcPara = TypeID+flag+CustomerID;
		
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
		if(RecordSet.getCounts()<=0)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData_AO");
			return;
		}
		RecordSet.first();

		ProcPara += flag+"0";
		ProcPara += flag+RecordSet.getString("address1");
		ProcPara += flag+RecordSet.getString("address2");
		ProcPara += flag+RecordSet.getString("address3");
		ProcPara += flag+RecordSet.getString("zipcode");
		ProcPara += flag+RecordSet.getString("city");
		ProcPara += flag+RecordSet.getString("country");
		ProcPara += flag+RecordSet.getString("province");
		ProcPara += flag+RecordSet.getString("county");
		ProcPara += flag+RecordSet.getString("phone");
		ProcPara += flag+RecordSet.getString("fax");
		ProcPara += flag+RecordSet.getString("email");
		ProcPara += flag+"0";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";

		RecordSet.executeProc("CRM_CustomerAddress_Insert",ProcPara);

		response.sendRedirect("/CRM/data/ViewAddressDetail.jsp?CustomerID="+CustomerID+"&TypeID="+TypeID);
		return;
	}
	else
	{
		RecordSet.executeProc("CRM_CustomerAddress_UEqual",TypeID+flag+CustomerID+flag+"0");

		response.sendRedirect("/CRM/data/ViewAddressDetail.jsp?CustomerID="+CustomerID+"&TypeID="+TypeID);
		return;
	}
}

String Address1 = Util.fromScreen(request.getParameter("Address1"),user.getLanguage());
String Address2 = Util.fromScreen(request.getParameter("Address2"),user.getLanguage());
String Address3 = Util.fromScreen(request.getParameter("Address3"),user.getLanguage());
String Zipcode = Util.fromScreen(request.getParameter("Zipcode"),user.getLanguage());
String City = Util.fromScreen(request.getParameter("City"),user.getLanguage());
String Country = Util.fromScreen(request.getParameter("Country"),user.getLanguage());
String Province = Util.fromScreen(request.getParameter("Province"),user.getLanguage());
String County = Util.fromScreen(request.getParameter("County"),user.getLanguage());
String Phone = Util.fromScreen(request.getParameter("Phone"),user.getLanguage());
String Fax = Util.fromScreen(request.getParameter("Fax"),user.getLanguage());
String Email = Util.fromScreen(request.getParameter("Email"),user.getLanguage());
String Contacter = Util.fromScreen(request.getParameter("ContacterID"),user.getLanguage());

String dff01=Util.null2String(request.getParameter("dff01"));
String dff02=Util.null2String(request.getParameter("dff02"));
String dff03=Util.null2String(request.getParameter("dff03"));
String dff04=Util.null2String(request.getParameter("dff04"));
String dff05=Util.null2String(request.getParameter("dff05"));

String nff01=Util.null2String(request.getParameter("nff01"));
if(nff01.equals("")) nff01="0.0";
String nff02=Util.null2String(request.getParameter("nff02"));
if(nff02.equals("")) nff02="0.0";
String nff03=Util.null2String(request.getParameter("nff03"));
if(nff03.equals("")) nff03="0.0";
String nff04=Util.null2String(request.getParameter("nff04"));
if(nff04.equals("")) nff04="0.0";
String nff05=Util.null2String(request.getParameter("nff05"));
if(nff05.equals("")) nff05="0.0";

String tff01=Util.fromScreen(request.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen(request.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen(request.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen(request.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen(request.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(request.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(request.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(request.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(request.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(request.getParameter("bff05"));
if(bff05.equals("")) bff05="0";

if(method.equals("edit"))
{

	RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);
	RecordSet.next();
	boolean bNeedUpdate = false;

	strTemp = RecordSet.getString("address1");
	if(!Address1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage())+"1";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("address2");
	if(!Address2.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage())+"2";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address2;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("address3");
	if(!Address3.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage())+"3";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address3;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("zipcode");
	if(!Zipcode.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1899,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Zipcode;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("city");
	if(!City.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(493,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+City;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("country");
	if(!Country.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(377,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Country;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("province");
	if(!Province.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(800,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Province;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("county");
	if(!County.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(644,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+County;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}


	strTemp = RecordSet.getString("phone");
	if(!Phone.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(421,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Phone;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("fax");
	if(!Fax.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(494,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Fax;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("email");
	if(!Email.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(477,user.getLanguage());
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Email;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("contacter");
	if(!Contacter.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(572,user.getLanguage())+"ID";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Contacter;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield1");
	if(!dff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield2");
	if(!dff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield3");
	if(!dff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield4");
	if(!dff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield5");
	if(!dff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield1");
	if(!nff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield2");
	if(!nff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield3");
	if(!nff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield4");
	if(!nff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield5");
	if(!nff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield1");
	if(!tff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield2");
	if(!tff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield3");
	if(!tff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield4");
	if(!tff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield5");
	if(!tff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield1");
	if(!bff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield2");
	if(!bff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield3");
	if(!bff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield4");
	if(!bff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield5");
	if(!bff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"3"+flag+TypeID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

  if(bNeedUpdate)
  {

	ProcPara = TypeID+flag+CustomerID;
	
	ProcPara += flag+"0";
	ProcPara += flag+Address1;
	ProcPara += flag+Address2;
	ProcPara += flag+Address3;
	ProcPara += flag+Zipcode;
	ProcPara += flag+City;
	ProcPara += flag+Country;
	ProcPara += flag+Province;
	ProcPara += flag+County;
	ProcPara += flag+Phone;
	ProcPara += flag+Fax;
	ProcPara += flag+Email;
	ProcPara += flag+Contacter;

	ProcPara += flag+dff01;
	ProcPara += flag+dff02;
	ProcPara += flag+dff03;
	ProcPara += flag+dff04;
	ProcPara += flag+dff05;
	ProcPara += flag+nff01;
	ProcPara += flag+nff02;
	ProcPara += flag+nff03;
	ProcPara += flag+nff04;
	ProcPara += flag+nff05;
	ProcPara += flag+tff01;
	ProcPara += flag+tff02;
	ProcPara += flag+tff03;
	ProcPara += flag+tff04;
	ProcPara += flag+tff05;
	ProcPara += flag+bff01;
	ProcPara += flag+bff02;
	ProcPara += flag+bff03;
	ProcPara += flag+bff04;
	ProcPara += flag+bff05;


	RecordSet.executeProc("CRM_CustomerAddress_Update",ProcPara);

	ProcPara = CustomerID;
	ProcPara += flag+"ma";
	ProcPara += flag+"0";
	ProcPara += flag+"";
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);
  }
	response.sendRedirect("/CRM/data/ViewAddressDetail.jsp?CustomerID="+CustomerID+"&TypeID="+TypeID);
	return;
}
%>
