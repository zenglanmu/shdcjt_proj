<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>


<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    //request.setCharacterEncoding("utf-8");


    User user = HrmUserVarify.getUser(request, response);
    if (user == null) return;

    FileUpload fu = new FileUpload(request, "utf-8",false);
    int mainId = Util.getIntValue(fu.getParameter("mainId"),0);
    int subId = Util.getIntValue(fu.getParameter("subId"),0);
    int secId = Util.getIntValue(fu.getParameter("secId"),0);
    String[] filedata = new String[1];
    filedata[0] = "Filedata";
    DocExtUtil mDocExtUtil = new DocExtUtil();
    int[] returnarry = null;
    returnarry = mDocExtUtil.uploadDocsToImgs(fu, user, filedata,mainId,subId,secId,"","");
    String tempvalue = "";
    if (returnarry != null) {
        for (int i = 0; i < returnarry.length; i++) {
            if (returnarry[i] != -1)
                if (tempvalue.trim().equals(""))
                    tempvalue = String.valueOf(returnarry[i]);
                else
                    tempvalue = tempvalue + "," + String.valueOf(returnarry[i]);
        }
    }
    out.println(tempvalue);
%>