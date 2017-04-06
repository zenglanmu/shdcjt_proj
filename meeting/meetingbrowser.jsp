<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
String name = Util.null2String(request.getParameter("name"));
String address = Util.null2String(request.getParameter("address"));
String begindatefrom = Util.null2String(request.getParameter("begindatefrom"));
String begindateto = Util.null2String(request.getParameter("begindateto"));


String sqlwhere="";
if(!name.equals("")) {
  if (!sqlwhere.equals("")){
    sqlwhere += " and  name like '%"+name+"%'";
  } else {
    sqlwhere += " name like '%"+name+"%'";
  }
} 

if(!address.equals("")) {
  if (!sqlwhere.equals("")){
    sqlwhere += " and  address ="+address;
  } else {
    sqlwhere += " address ="+address;
  }
} 


if(!begindatefrom.equals("")) {
  if (!sqlwhere.equals("")){
    sqlwhere += " and  begindate>'"+begindatefrom+"'";
  } else {
    sqlwhere += "  begindate>'"+begindatefrom+"'";
  }
} 


if(!begindateto.equals("")) {
  if (!sqlwhere.equals("")){
    sqlwhere += " and  begindate<'"+begindateto+"'";
  } else {
    sqlwhere += "  begindate<'"+begindateto+"'";
  }
} 

int perpage = 15 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

%>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

      <FORM NAME=SearchForm  action="meetingbrowser.jsp" method=post>
	  <DIV align=right style="display:none">
      <%
      RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
      RCMenuHeight += RCMenuHeightStep ;
      %>
     

      <%
      RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
      RCMenuHeight += RCMenuHeightStep ;
      %>
      <BUTTON type="button" class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
      
      <%
      RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
      RCMenuHeight += RCMenuHeightStep ;
      %>
      <BUTTON type="button" class=btn accessKey=C id=btnclear onclick="submitClear()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
      </DIV>
        <table width=100% class=ViewForm>
          <TR>
            <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD width=35% class=field><input class=InputStyle  name="name" value="<%=name%>"></TD>	
            <TD width=15%><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%></TD>
            <TD width=35% class=field>            
              <input class=wuiBrowser _displayText="<%=MeetingRoomComInfo.getMeetingRoomInfoname(address)%>" _url="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp" style="display:none" id="address" name="address" value="<%=address%>">            
            </TD>
          </TR>

           <TR>
            <TD width=15%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
            <TD width=35% class=field>
                <button type="button" class=Calendar id=selectdate1 onClick="getDate(begindatefromSpan,begindatefrom)"></button>
                <span id=begindatefromSpan ><%=begindatefrom%></span> -
                <button type="button" class=Calendar id=selectdate2 onClick="getDate(begindatetoSpan,begindateto)"></button>
                <span id=begindatetoSpan ><%=begindateto%></span>

                <input type=hidden  name=begindatefrom value="<%=begindatefrom%>">
                <input type=hidden name=begindateto  value="<%=begindateto%>">

            </TD>	
            <TD width=15%></TD>
            <TD width=35% class=field></TD>
          </TR>

        </table>
      </FORM>




      <TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
      <TR class=DataHeader>
           <TH width=0% style="display:none"></TH>       
          <TH width=45%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
          <TH width=18%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
          <TH width=14%><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%></TH>
      </tr>
      <TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
      <%
      SplitPageParaBean spp = new SplitPageParaBean();
      SplitPageUtil spu = new SplitPageUtil();

      String columnPara =" id ,name,begindate,address ";
      String fromSql = " from meeting " ;

      spp.setBackFields(columnPara);
      spp.setSqlFrom(fromSql);
      if (!sqlwhere.equals("")){
        sqlwhere=" where "+ sqlwhere;
        spp.setSqlWhere(sqlwhere);
      }
      spp.setDistinct(true);
      spp.setPrimaryKey("id");
      spp.setSqlOrderBy("begindate");
      spp.setSortWay(spp.DESC);

      spu.setSpp(spp);
      int recordSize = spu.getRecordCount();   //所有的条记录数  
      rs = spu.getCurrentPageRs(pagenum,perpage);
      int i=0;

      while(rs.next()) {
          String id = Util.null2String(rs.getString("id"));
          name = Util.null2String(rs.getString("name"));
          String begindate = Util.null2String(rs.getString("begindate"));
          address = Util.null2String(rs.getString("address"));
      %>

        <TR  <%if(i%2==0) out.println("class=DataLight"); else out.println("class=DataDark");%>>       
          <TD style="display:none"><A HREF=#><%=id%></A></TD>         
          <TD><%=name%></TD>
          <TD ><%=begindate%></TD>
          <TD><%=MeetingRoomComInfo.getMeetingRoomInfoname(address)%></TD>
        </TR>        
        <%
          i++;
          } %>
      <table width=100% class=Data>
      <tr>
      <td align=center><%=Util.makeNavbar3(pagenum, recordSize , perpage, "meetingbrowser.jsp")%></td>
      </tr>
      </table>
      <br>
      </TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function submitClear()
{
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}


//下面的函数由分页栏产生的函数调用
function changePagePre(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageTo(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageNext(pageStr){
    changePageSubmit(pageStr);
}

function changePageSubmit(pageStr){
  //location=pageStr+"&documentids="+documentids+"&searchid="+document.all("searchid").value+"&searchmainid="+document.all("searchmainid").value+"&searchsubject="+document.all("searchsubject").value+"&searchcreater="+document.all("searchcreater").value+"&searchdatefrom="+document.all("searchdatefrom").value+"&searchdatefrom="+document.all("searchdatefrom").value;
	location=pageStr+"&name="+document.all("name").value+"&address="+document.all("address").value+"&begindatefrom="+document.all("begindatefrom").value+"&begindateto="+document.all("begindateto").value;
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>