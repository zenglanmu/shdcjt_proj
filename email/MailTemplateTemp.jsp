<%@ page language="java" contentType="text/html; charset=gbk" %><%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="dept" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="comp" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="job" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String templateType = Util.null2String(request.getParameter("templateType"));
String userId = Util.null2String(request.getParameter("userId"));
String hrmName = "", hrmDepartment = "", hrmSubcompany = "", hrmCompany = "", hrmPost = "", hrmAddress = "";
String hrmOffice = "", hrmTelOffice = "", hrmMobile = "", hrmTelOther = "", hrmFax = "", hrmMail = "";
String templateSubject = "", templateContent = "";
String sql = "";

//=================== Sender ===================
hrmName = hrm.getResourcename(userId);
hrmDepartment = dept.getDepartmentname(hrm.getDepartmentID(userId));
hrmSubcompany = comp.getSubCompanyname(dept.getSubcompanyid1(hrm.getDepartmentID(userId)));
hrmCompany = "";
hrmPost = job.getJobTitlesname(hrm.getJobTitle(userId));
hrmAddress = "";
hrmOffice = "";
hrmTelOffice = hrm.getTelephone(userId);
hrmMobile = hrm.getMobile(userId);
hrmTelOther = "";
hrmFax = "";
hrmMail = hrm.getEmail(userId);

if(templateType.equals("0")){
	sql = "SELECT templateSubject, templateContent FROM MailTemplate WHERE id="+Util.getIntValue(request.getParameter("id"))+"";
}else{
	sql = "SELECT '' AS templateSubject, mouldtext AS templateContent FROM DocMailMould WHERE id="+Util.getIntValue(request.getParameter("id"))+"";
}
rs.executeSql(sql);
if(rs.next()){
	templateSubject = rs.getString("templateSubject");
	templateContent = rs.getString("templateContent");

	int oldpicnum = 0;
	int pos = templateContent.indexOf("<IMG alt=");
	while(pos!=-1){
		String tempStr = templateContent.substring(0, pos+9);
		tempStr += "docimages_" + oldpicnum;
		int srcPos = templateContent.indexOf(" src=", pos+9);
		tempStr += templateContent.substring(srcPos);
		templateContent = tempStr;

		pos = templateContent.indexOf("?fileid=",pos);
		if(pos==-1) continue;
		int endpos = templateContent.indexOf("\"",pos);
		String tmpid = templateContent.substring(pos+8,endpos);
		int startpos = templateContent.lastIndexOf("\"",pos);
		String servername = request.getHeader("host");
		String tmpcontent = templateContent.substring(0,startpos+1);
		tmpcontent += "http://"+servername;
		tmpcontent += templateContent.substring(startpos+1);
		templateContent = tmpcontent;
		pos = templateContent.indexOf("<IMG alt=",endpos);
		oldpicnum += 1;
	}

	//=================== Macro Replace ===================
	templateContent = Util.replace(templateContent, "\\[\\$hrm_name\\]", hrmName, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_department\\]", hrmDepartment, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_subcompany\\]", hrmSubcompany, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_post\\]", hrmPost, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_tel\\]", hrmTelOffice, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_mobile\\]", hrmMobile, 0, true);
	templateContent = Util.replace(templateContent, "\\[\\$hrm_mail\\]", hrmMail, 0, true);

	out.println("@@@"+templateSubject+"@@@"+templateContent);
}
%>