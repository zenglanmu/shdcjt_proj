<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.DesUtil"%>	
<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%!
 private String getFileExt(String file) {
        if (file == null || file.trim().equals("")) {
            return "";
        } else {
            int idx = file.lastIndexOf(".");
            if (idx == -1) {
                return "";
            } else {
                if (idx + 1 >= file.length()) {
                    return "";
                } else {
                    return file.substring(idx + 1);
                }
            }
        }
    }
%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	FileUpload fu = new FileUpload(request,"utf-8");
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	int docid=Util.getIntValue(fu.getParameter("docid"));
	//request.setCharacterEncoding("utf-8");
	boolean hasRight = false;
	DesUtil desUtil = new DesUtil();
	String userid = Util.null2String(fu.getParameter("userid"));
	if(!userid.equals("")){
		if(Util.getIntValue(desUtil.decrypt(userid))>0){
			hasRight = true;
		}
	}
	
	if(!hasRight)  return ;
	

	
	//String mode=Util.null2String(fu.getParameter("mode"));

	//System.out.println("imagefileid:"+imagefileid);
	//System.out.println("docid:"+docid);

	 String imgFilename="";
	 rs.executeSql("select imagefilename from imagefile where imagefileid="+imagefileid);
	 if(rs.next()){
		imgFilename=rs.getString(1);
	 }

	

	imgManger.resetParameter();
	imgManger.setDocid(docid);
	imgManger.setImagefileid(imagefileid);
	imgManger.setImagefilename(imgFilename);
	imgManger.setIsextfile("1");
	String ext = getFileExt(imgFilename);
	if (ext.equalsIgnoreCase("doc")) {
		imgManger.setDocfiletype("3");
	} else if (ext.equalsIgnoreCase("xls")) {
		imgManger.setDocfiletype("4");
	} else if (ext.equalsIgnoreCase("ppt")) {
		imgManger.setDocfiletype("5");
	} else if (ext.equalsIgnoreCase("wps")) {
		imgManger.setDocfiletype("6");
	} else if (ext.equalsIgnoreCase("docx")) {
		imgManger.setDocfiletype("7");
	} else if (ext.equalsIgnoreCase("xlsx")) {
		imgManger.setDocfiletype("8");
	} else if (ext.equalsIgnoreCase("pptx")) {
		imgManger.setDocfiletype("9");
	} else if (ext.equalsIgnoreCase("et")) {
		imgManger.setDocfiletype("10");
	} else {
		imgManger.setDocfiletype("2");
	}
	imgManger.AddDocImageInfo();
	
	String sql="select count(distinct id) from docimagefile where isextfile = '1' and docid="+docid;
	rs.executeSql(sql);
	int countImg=0;
	while(rs.next()){
		countImg=rs.getInt(1);	
	}	
	
	Calendar today = Calendar.getInstance();
	String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
			+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
			+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
			+ Util.add0(today.get(Calendar.MINUTE), 2) + ":"
			+ Util.add0(today.get(Calendar.SECOND), 2);
	
	sql = "update  docdetail set accessorycount="+countImg+",doclastmoddate='"+formatdate+"',doclastmodtime='"+formattime+"' where id="+docid;
	//System.out.println(sql);
	rs.executeSql(sql);
	//if("view".equals(mode))
	//{
	String docsubject = "";
	String creatertype = "";
	int doccreater = 0;
	String selSql = "select docsubject,creatertype, doccreater from DocDetailLog where docid="+ docid + " order by id desc";
	//System.out.println("selSql : "+selSql);
	rs.executeSql(selSql); 
	if (rs.next()) {
		docsubject = rs.getString(1);
		creatertype = rs.getString(2);
		doccreater = Util.getIntValue(rs.getString(3));
	}
	String clientip = request.getRemoteAddr();
	String usertype = Util.null2String(fu.getParameter("usertype"));
	;
	docDetailLog.resetParameter();
	docDetailLog.setDocId(docid);
	docDetailLog.setDocSubject(docsubject);
	docDetailLog.setOperateType("2");
	docDetailLog.setOperateUserid( Util.getIntValue(desUtil.decrypt(userid)));
	docDetailLog.setUsertype(usertype);
	docDetailLog.setClientAddress(clientip);
	docDetailLog.setDocCreater(doccreater);
	docDetailLog.setCreatertype(creatertype);
	docDetailLog.setDocLogInfo();
	//}
%>





