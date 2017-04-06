<%@ page language="java" contentType="application/x-json;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page
	import="weaver.general.Util,weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	int seccategory = 0;
	seccategory = Util.getIntValue(request.getParameter("seccategory"),
			0);
	StringBuffer taleString = new StringBuffer();
	int tmpcount = 0;
	if (seccategory != 0) {
		

		taleString.append("<table width=\"100%\" class=viewform>\n");
		taleString
		.append("<COLGROUP > <COL width=\"4%\"> <COL width=\"20%\"> <COL width=\"20%\"> <COL width=\"18%\">");
		taleString.append("<COL width=\"20%\"> <COL width=\"18%\">");
		taleString.append(" <TR class=title>");
		taleString.append("<TH colSpan=6>自定义字段</TH>");
		taleString.append("</TR>");
		taleString.append("<TR style=\"height:1px\">");
		taleString.append("<TD class=line1 colspan=6></TD>");
		taleString.append("</TR>");
		taleString.append("<TR class=title>");
		taleString.append("<td></td>");
		taleString.append("<td>"
		+ SystemEnv.getHtmlLabelName(261, user.getLanguage())
		+ "</td>");
		taleString.append("<td colspan=4>"
		+ SystemEnv.getHtmlLabelName(15364, user.getLanguage())
		+ "</td>");
		taleString.append("</tr> <TR style=\"height:1px\">");
		taleString.append("<TD class=line colspan=6></TD>");
		taleString.append("</TR>");

		int linecolor = 0;
		
		CustomFieldManager cfm = new CustomFieldManager(
		"DocCustomFieldBySecCategory", seccategory);
		cfm.getCustomFields();
		while (cfm.next()) {
			
			tmpcount++;
			String id = String.valueOf(cfm.getId());
			String name = "field" + cfm.getId();
			String label = cfm.getLable();
			String htmltype = cfm.getHtmlType();
			String type = String.valueOf(cfm.getType());
			String fielddbtype=Util.null2String(cfm.getFieldDbType());

			taleString.append("<tr class=title >");
			taleString.append("<td>");
			taleString
			.append("<input type='checkbox' name='check_con'  value="
			+ cfm.getId() + " >");
			taleString.append("</td>");
			taleString.append("<td>");
			taleString.append("<input type=hidden name=\"con"
			+ cfm.getId() + "_id\" value=\"" + cfm.getId()
			+ "\">");
			taleString.append(Util.toScreen(label, user.getLanguage()));
			taleString.append("<input type=hidden name=\"con"
			+ cfm.getId() + "_colname\" value=\"" + name
			+ "\">");
			taleString.append("</td>");
			taleString.append("<input type=hidden name=\"con" + id
			+ "_htmltype\" value=\"" + htmltype + "\">");
			taleString.append("<input type=hidden name=\"con" + id
			+ "_type\" value=\"" + type + "\">");

			if ((htmltype.equals("1") && type.equals("1"))
			|| htmltype.equals("2")) {

		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"3\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"4\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString.append("<td colspan=3>");
		taleString
				.append("<input type=text class=inputstyle size=12 name=\"con"
				+ id
				+ "_value\"  onfocus=\"changelevel('"
				+ tmpcount + "')\"  >");
		taleString.append(" </td>");
			} else if (htmltype.equals("1") && !type.equals("1")) {

		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\">");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(15508, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(325, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"3\" >"
				+ SystemEnv.getHtmlLabelName(15509, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"4\" >"
				+ SystemEnv.getHtmlLabelName(326, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"5\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"6\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString.append("<td >");
		taleString
				.append("<input type=text class=inputstyle size=12 name=\"con"
				+ id
				+ "_value\"  onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("</td>");
		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt1\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(15508, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(325, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"3\" >"
				+ SystemEnv.getHtmlLabelName(15509, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"4\" >"
				+ SystemEnv.getHtmlLabelName(326, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"5\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"6\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString.append("<td>");
		taleString
				.append("<input type=text class=inputstyle size=12 name=\"con"
				+ id
				+ "_value1\"  onfocus=\"changelevel('"
				+ tmpcount + "')\"  >");
		taleString.append("</td>");
			} else if (htmltype.equals("4")) {

		taleString.append("<td colspan=4>");
		taleString
				.append("<input type=checkbox value=1 name=\"con"
				+ id
				+ "_value\"  onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("</td>");
			} else if (htmltype.equals("5")) {
		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString.append("<td colspan=3>");
		taleString.append("<select class=inputstyle name=\"con"
				+ id + "_value\"  onfocus=\"changelevel('"
				+ tmpcount + "')\">");
	
		char flag = 2;
		cfm.getSelectItem(cfm.getId());
		while (cfm.nextSelect()) {
			String tmpselectvalue = cfm.getSelectValue();
			String tmpselectname = cfm.getSelectName();

			taleString.append("<option value=\""
			+ tmpselectvalue
			+ "\"  >"
			+ Util.toScreen(tmpselectname, user
					.getLanguage()) + "</option>");
		}

		taleString.append("</select>");
		taleString.append("</td>");
			} else if (htmltype.equals("3") && !type.equals("2")
			&& !type.equals("18") && !type.equals("19")
			&& !type.equals("17") && !type.equals("37")
			&& !type.equals("65")&& !type.equals("161") && !type.equals("162")) {
		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString.append("<td colspan=3>");

		//for test
		int sharelevel = 1;
		String browserurl = UrlComInfo.getUrlbrowserurl(type);
		if (type.equals("4") && sharelevel < 2) {
			if (sharelevel == 1)
				browserurl = browserurl.trim()
				+ "?sqlwhere=where subcompanyid1 = "
				+ user.getUserSubCompany1();
			else
				browserurl = browserurl.trim()
				+ "?sqlwhere=where id = "
				+ user.getUserDepartment();
		}

		taleString
				.append("<button type='button' class=Browser  onfocus=\"changelevel('<"
				+ tmpcount
				+ "')\" onclick=\"onShowDepartment('"
				+ id
				+ "','" + browserurl + "')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3")
			&& (type.equals("2") || type.equals("19"))) { // 增加日期和时间的处理（之间）
		taleString.append(" <td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(15508, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(325, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"3\" >"
				+ SystemEnv.getHtmlLabelName(15509, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"4\" >"
				+ SystemEnv.getHtmlLabelName(326, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"5\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"6\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td> <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser1('"
				+ id
				+ "','"
				+ UrlComInfo.getUrlbrowserurl(type)
				+ "','1')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");
		taleString.append("</span> </td>");
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt1\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(15508, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(325, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"3\" >"
				+ SystemEnv.getHtmlLabelName(15509, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"4\" >"
				+ SystemEnv.getHtmlLabelName(326, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"5\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"6\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td > <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser1('"
				+ id
				+ "','"
				+ UrlComInfo.getUrlbrowserurl(type)
				+ "','2')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value1\" >");
		taleString.append("<span name=\"con" + id
				+ "_value1span\" id=\"con" + id
				+ "_value1span\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3") && type.equals("17")) { // 增加多人力资源的处理（包含，不包含）
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td colspan=3> <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser('"
				+ id
				+ "','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3") && type.equals("18")) { // 增加多客户的处理（包含，不包含）
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td colspan=3> <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser('"
				+ id
				+ "','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3") && type.equals("37")) { // 增加多文档的处理（包含，不包含） 
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td colspan=3> <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser('"
				+ id
				+ "','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3") && type.equals("65")) { // 增加多角色的处理（包含，不包含）
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");
		taleString
				.append("<td colspan=3> <button type='button' class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowser('"
				+ id
				+ "','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			} else if (htmltype.equals("3") && type.equals("161")) {// 增加自定义单选的处理（等于，不等于）
		taleString.append("<td>");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(327, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15506, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");

		String browserurl = UrlComInfo.getUrlbrowserurl(type);
		browserurl+="?type="+fielddbtype;

		taleString.append("<td colspan=3>");
		taleString
				.append("<button class=Browser  onfocus=\"changelevel('<"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowserCommon('"
				+ id
				+ "','" + browserurl + "',"+type+")\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			}  else if (htmltype.equals("3") && type.equals("162")) { // 增加自定义多选的处理（包含，不包含）
		taleString.append("<td >");
		taleString
				.append("<select class=inputstyle name=\"con"
				+ id
				+ "_opt\" style=\"width:100%\" onfocus=\"changelevel('"
				+ tmpcount + "')\" >");
		taleString.append("<option value=\"1\" >"
				+ SystemEnv.getHtmlLabelName(346, user
				.getLanguage()) + "</option>");
		taleString.append("<option value=\"2\" >"
				+ SystemEnv.getHtmlLabelName(15507, user
				.getLanguage()) + "</option>");
		taleString.append("</select>");
		taleString.append("</td>");

		String browserurl = UrlComInfo.getUrlbrowserurl(type);
		browserurl+="?type="+fielddbtype;

		taleString
				.append("<td colspan=3> <button class=Browser  onfocus=\"changelevel('"
				+ tmpcount
				+ "')\" onclick=\"onShowBrowserCommon('"
				+ id
				+ "','" + browserurl + "',"+type+")\"></button>");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_value\" >");
		taleString.append("<input type=hidden name=\"con" + id
				+ "_name\" >");
		taleString.append("<span name=\"con" + id
				+ "_valuespan\" id=\"con" + id
				+ "_valuespan\">");

		taleString.append("</span> </td>");
			}
			taleString.append("</tr>");
			taleString
			.append("	<tr style=\"height:1px\"><td colspan=6 class=line1></td></tr>");

		}

		taleString.append("</table>");
		if(tmpcount==0){
			taleString.setLength(0);
			
		}
	}

out.println(taleString.toString()+tmpcount);
%>