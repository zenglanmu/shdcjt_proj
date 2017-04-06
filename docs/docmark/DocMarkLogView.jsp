<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
    String secId = (String)session.getValue("secId");
    String docId = Util.null2String(request.getParameter("docId"));  
    if ("".equals(docId)){
        out.println(SystemEnv.getHtmlLabelName(19001,user.getLanguage()));
        return ;
    }
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
  
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
      <col width="10">
      <col width="">
      <col width="10">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <TR><TD class=Line1 colspan=3></TD></TR>
        <tr>
            <td>&nbsp;</td>
            <td valign="top">
             <!--列表部分-->
              <%
                    //得到pageNum 与 perpage
                    int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                    int perpage = UserDefaultManager.getNumperpage();                   
                    if(perpage <2) perpage=10;
                    
                    //设置好搜索条件
					sppb.setBackFields("id,markHrmType,markHrmId,mark,remark,markDate");
					sppb.setSqlFrom("from  DocMark where docId="+docId);
					sppb.setSqlOrderBy("markDate,id");
					sppb.setSortWay(sppb.DESC);				
					sppb.setPrimaryKey("id");
					//sppb.setIsPrintExecuteSql(true);

					spu.setSpp(sppb);
					rs=spu.getCurrentPageRs(pagenum,perpage);

					


                    //String columnPara ="markHrmType,markHrmId,mark,remark,markDate";
                    //String fromSql = "from  DocMark where docId="+docId;
                    //String orderByAndGroupGBy="order by markDate desc ,id desc";
                    
                    ///得到符和 pagenum,perpage 的数据的一个迭代对象
                    //PageManagerUtil.setColumnPara(columnPara);
                    //PageManagerUtil.setFormSql(fromSql);
                    //PageManagerUtil.setOrderByAndGroupGBy(orderByAndGroupGBy);
                   
                    //Iterator docMarkLogIte = PageManagerUtil.getCurrentPageIterator(pagenum,perpage); 
                  %>
                <TABLE class="shadow">
                    <TR>
                    <TD valign="top">
                    <TABLE  class ="ListStyle">                    
                        <colgroup>
                        <col width="20%">
                        <col width="25%">
                        <col width="35%">  
                         <col width="20%"> 
                        <TR class=Header>
                            <TH><%=SystemEnv.getHtmlLabelName(19002,user.getLanguage())%></TH>
                            <TH><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></TH>
                            <TH><%=SystemEnv.getHtmlLabelName(1514,user.getLanguage())%></TH>  
                            <TH><%=SystemEnv.getHtmlLabelName(19003,user.getLanguage())%></TH>
                        </TR>
                        <%
                        int rows = 1; 
                        while(rs.next()) {
                                   //String[] tempArray =  (String[])docMarkLogIte.next();
                                   rows++;
                               %>
                                     <TR class="<%=rows%2==0?"datadark":"datalight"%>"> 
                                        <%for (int i=0;i<5;i++){  
                                               switch (i) { 
                                                   case 0: //markHrmType  订阅人类型
                                                       break ;
                                                   case 1:   //markHrmId   订阅人id 
                                                        if (DocMark.isAnonymityMark(secId)) {
                                                            out.println("<td>"+SystemEnv.getHtmlLabelName(18611,user.getLanguage())+"</td>");
                                                            break ;
                                                        } 
                                                        if ("1".equals(rs.getString("markHrmType"))){
                                                             out.println("<TD>"+ResourceComInfo.getResourcename(rs.getString("markHrmId"))+"</TD>");
                                                        } else {
                                                             out.println("<TD>"+CustomerInfo.getCustomerInfoname(rs.getString("markHrmId"))+"</TD>");
                                                        }
                                                        break ;
                                                    case 2:  //mark        分值
                                                        out.println("<TD>"+rs.getString("mark")+" "+SystemEnv.getHtmlLabelName(18928,user.getLanguage())+"</TD>");
                                                        break ;
                                                    case 3:  //remark     打分说明
                                                        out.println("<TD>"+rs.getString("remark")+"</TD>");
                                                        break ;
                                                    case 4:  //markDate　　打分日期
                                                        out.println("<TD>"+rs.getString("markDate")+"</TD>");
                                                        break ;  
                                                }                                         
                                           }%>
                                    </TR>
                               <%}%>
                      </TABLE>

                      <!--分页状态栏部分-->                               
                      <TABLE width="100%" border="0">                                
                        <TR>
                            <TD noWrap>
                             <%  
                                int recordSize = spu.getRecordCount();
                                String linkstr = "DocMarkLogView.jsp?docId="+docId;
                             %>
                             <%=Util.makeNavbar2(pagenum,recordSize,perpage,linkstr)%>
                            </TD>
                        </TR>
                      </TABLE>
                      </TD>
                      </TR>
                   </TABLE>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>      
    </TABLE>
  </BODY>
</HTML>

 <SCRIPT LANGUAGE="JavaScript">
    <!--  
     function onClose(){
       window.close();        
     }  
     //-->
 </SCRIPT>