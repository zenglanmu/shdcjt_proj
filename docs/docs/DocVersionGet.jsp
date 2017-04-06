<%@ page language="java" contentType="application/x-json;charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page import="org.json.*" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	int docid = Util.getIntValue(request.getParameter("docid"),0);
	int doceditionid = Util.getIntValue(request.getParameter("doceditionid"),0);
	String readerCanViewHistoryEdition= Util.null2String(request.getParameter("readerCanViewHistoryEdition"));
	boolean canEditHis= Util.null2String(request.getParameter("canEditHis")).equals("true");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	JSONArray jsonArrayReturn= new JSONArray();
	
	int editionCount = 0;
	if(doceditionid>-1){
		rs.executeSql(" select count(0) as c from DocDetail where doceditionid = " + doceditionid);
		if(rs.next()){
			editionCount = Util.getIntValue(rs.getString("c"),0);
		}
	}


	if(doceditionid>-1){	  
	    rs.executeSql(" select id,isHistory from DocDetail where doceditionid = " + doceditionid + " order by docedition desc ");
	    while(rs.next()){
			JSONObject oJson= new JSONObject();
	        int currDocId = Util.getIntValue(rs.getString("id"));
	        int currIsHistory = Util.getIntValue(rs.getString("isHistory"));

	        String currCreater = "";
			String currUserLinkUrl = "";
			if (Util.getIntValue(DocComInfo.getUsertype(currDocId+"")) == 1) {
			    currCreater = ResourceComInfo.getLastname("" + DocComInfo.getDocCreaterid(currDocId+""));
				currUserLinkUrl = "/hrm/resource/HrmResource.jsp?id=" + DocComInfo.getDocCreaterid(currDocId+"");
			} else {
			    currCreater = CustomerInfoComInfo.getCustomerInfoname("" + DocComInfo.getDocCreaterid(currDocId+""));
				currUserLinkUrl = "/CRM/data/ViewCustomer.jsp?CustomerID=" + DocComInfo.getDocCreaterid(currDocId+"");
			}
			String tempImg="";
			if(currDocId==docid){
				tempImg="<img src='/images/replyDoc/openfld.gif'/>";
			}else{
				tempImg="<img src='/images/replyDoc/news_general.gif'/>";
			}

			if(currIsHistory==1&&!readerCanViewHistoryEdition.equals("1") && !canEditHis){
				oJson.put("",tempImg+DocComInfo.getDocname(currDocId+""));
			}else{
				oJson.put("docsubject",tempImg+"<a href='/docs/docs/DocDsp.jsp?id="+currDocId+"'>"+DocComInfo.getDocname(currDocId+"")+"</a>");
			}

			oJson.put("versionid",DocComInfo.getEditionView(currDocId)+"("+DocComInfo.getStatusView(currDocId,user)+")");	
			oJson.put("creator","<img src='/images/replyDoc/userinfo.gif' border='0'/><a href=\"javaScript:openhrm('"+DocComInfo.getDocCreaterid(currDocId+"")+"');\" onclick='pointerXY(event);'>"+currCreater+"</a>");
			oJson.put("doclastmoditime",DocComInfo.getDocCreateTime(currDocId+""));
			oJson.put("expanded",true);
			oJson.put("leaf",true);
			oJson.put("uiProvider","col");		

			jsonArrayReturn.put(oJson);
	    }
		
    } 
	out.println(jsonArrayReturn.toString());
%>


