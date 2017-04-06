<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String suibian1 = Util.null2String(request.getParameter("suibian1"));
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
String rem=(String)session.getAttribute("jobtitlesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }

if(rem!=null)
  rem=tabid+rem.substring(1);
else
  rem=tabid;
if(!nodeid.equals(""))
  rem=rem.substring(0,1)+"|"+nodeid;


session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    //System.out.println("departmentid"+departmentid);
    }
}
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;

String check_per = Util.null2String(request.getParameter("jobtitles"));

//======================================================

String _jobtitles = "";
String _jobtitlesname = "";

if(!check_per.equals("")){
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	try{
		String strtmp = "select id,jobtitlemark,jobtitlename,jobdepartmentid from hrmjobtitles where id in ("+check_per+")";
	
	    RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while(RecordSet.next()){
		
	        String department = Util.toScreen(RecordSet.getString("jobdepartmentid"),user.getLanguage());
	    	String mark=DepartmentComInfo.getDepartmentmark(department);
	
			if(mark.length()>6)
	        	mark=mark.substring(0,6);
	        int length=mark.getBytes().length;
	        if(length<12){
	            for(int i=0;i<12-length;i++){
	              mark+=" ";
	            	}
	        }
	        String subcid=DepartmentComInfo.getSubcompanyid1(department);
	        String subc= SubCompanyComInfo.getSubCompanyname(subcid);
	        String _jobtitlename=RecordSet.getString("jobtitlename");
	        length=_jobtitlename.getBytes().length;
	        if(length<10){
	            for(int i=0;i<10-length;i++){
	              _jobtitlename+=" ";
	            }
	        }
	        _jobtitlename=_jobtitlename+" | "+mark+" | "+subc;
	        ht.put(RecordSet.getString("id"),_jobtitlename);
	
		}
	
		StringTokenizer st = new StringTokenizer(check_per,",");
	
		while(st.hasMoreTokens()){
			String s = st.nextToken();
			_jobtitles +=","+s;
			_jobtitlesname += ","+Util.StringReplace(ht.get(s).toString(),",","£¬");
		}
	}catch(Exception e){
		_jobtitles="";
		_jobtitlesname="";
	}
}



















//=============================================================




if(subcompanyid.equals("")&&departmentid.equals("")&&sqlwhere.equals("") && !suibian1.equals("1")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!jobtitlemark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitlemark like '%" + Util.fromScreen2(jobtitlemark,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and jobtitlemark like '%" + Util.fromScreen2(jobtitlemark,user.getLanguage()) +"%' ";
}
if(!jobtitlename.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitlename like '%" + Util.fromScreen2(jobtitlename,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and jobtitlename like '%" + Util.fromScreen2(jobtitlename,user.getLanguage()) +"%' ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobdepartmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and jobdepartmentid =" + departmentid +" " ;
}else if(!subcompanyid.equals("")){
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobdepartmentid in(select id from hrmdepartment where subcompanyid1=" + subcompanyid +" and canceled!='1') " ;
	}
	else
		sqlwhere += " and jobdepartmentid in(select id from hrmdepartment where subcompanyid1=" + subcompanyid +" and canceled!='1') " ;
}


String sqlstr = "select id,jobtitlemark,jobtitlename,jobdepartmentid from hrmjobtitles " + sqlwhere+" order by jobdepartmentid,jobtitlemark";

%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">

<tr>
  <td align="center" valign="top" width="45%">
	
			                 <select size="13" name="from" multiple="true" style="width:100%" class="InputStyle" onclick="blur1($('select[name=srcList]')[0])" onkeypress="checkForEnter($('select[name=from]')[0],$('select[name=srcList]')[0])" ondblclick="one2two($('select[name=from]')[0],$('select[name=srcList]')[0])">
				             </select>
		      <script>
      <%
					
					RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){

						String ids = RecordSet.getString("id");
						String jobtitlemarks = RecordSet.getString("jobtitlemark");
					    String jobtitlenames = RecordSet.getString("jobtitlename");

                        int length=jobtitlenames.getBytes().length;
                        if(length<10){
                            for(int i=0;i<10-length;i++){
                              jobtitlenames+=" ";
                            }
                        }

                        String department = Util.toScreen(RecordSet.getString("jobdepartmentid"),user.getLanguage());
                        String mark=DepartmentComInfo.getDepartmentmark(department);

                        if(mark.length()>6)
                        mark=mark.substring(0,6);
                        length=mark.getBytes().length;
                        if(length<12){
                            for(int i=0;i<12-length;i++){
                              mark+=" ";
                            }
                        }

                        String subcid=DepartmentComInfo.getSubcompanyid1(department);
                        String subc= SubCompanyComInfo.getSubCompanyname(subcid);
                        jobtitlenames=jobtitlenames+" | "+mark+" | "+subc;
                        %>

                          document.all("from").options.add(new Option('<%=jobtitlenames%>','<%=ids%>'));

						<%}%>

                      </script>
		
  </td>
  
  <td align="center" width="10%">
				<img src="/images/arrow_u.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br>
				<img src="/images/arrow_left.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two($('select[name=from]')[0],$('select[name=srcList]')[0]);">
				<br>
				<img src="/images/arrow_right.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one($('select[name=from]')[0],$('select[name=srcList]')[0]);">				
				<br>
				<img src="/images/arrow_left_all.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll($('select[name=from]')[0],$('select[name=srcList]')[0]);">
				<br>				
				<img src="/images/arrow_right_all.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll($('select[name=srcList]')[0],$('select[name=from]')[0]);">				
				<br>
				<img src="/images/arrow_d.gif"   style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
  </td>
  <td align="center" valign="top" width="45%">
				<select size="13" name="srcList"  multiple="true" style="width:100%" class="InputStyle" onclick="blur1($('select[name=from]')[0])"
				onkeypress="checkForEnter($('select[name=srcList]')[0],$('select[name=from]')[0])" ondblclick="two2one($('select[name=from]')[0],$('select[name=srcList]')[0])">
					
  </td>
		
</tr>







   <tr width=100% >
    <td height="10" colspan=4></td>
   </tr>
   <tr width=100%>
     <td width=100% align="center" valign="bottom" colspan=4>
     	<BUTTON class=btnSearch accessKey=S <%if(!tabid.equals("1")){%>style="display:none"<%}%> id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
		<BUTTON class=btn accessKey=2  id=btnok><U>2</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
		<BUTTON class=btn accessKey=2  id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
  </tr>
</TABLE>

 

<script language="javascript">

 var resourceids = "<%=_jobtitles%>";
 var resourcenames = "<%=_jobtitlesname%>";

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	if(resourceids.split(",")[i]!=0)
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}


function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str)
	val = str.split("~")[0];
	txt = str.split("~")[1];
	obj.options.add(new Option(txt,val));
	
}


init($("select[name=from]")[0],$("select[name=srcList]")[0])



function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
     }
  }
  reloadResourceArray();
}


function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function removeAll(from,to){
	
	var len = from.options.length;
	for(var i = 0; i < len; i++) {
	to_len=to.options.length
	txt=from.options[i].text
	val=from.options[i].value
	to.options[to_len]=new Option(txt,val)	  
	}
	
	for(var i = len; i>=0; i--) {
	from.options[i]=null	  
	}
	
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
     }
  }
  reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	
}

//xiaofeng
function one2two(m1, m2)
{  
   // add the selected options in m1 to m2
   m1len = m1.length ;
   for ( i=0; i<m1len ; i++){
       if (m1.options[i].selected == true ) {
           m2len = m2.length;
           m2.options[m2len]= new Option(m1.options[i].text, m1.options[i].value);
       }
   }

reloadResourceArray()

	// remove all the selected options from m1 (because they have already been added to m2)	
	j = -1;
   for ( i = (m1len -1); i>=0; i--){
       if (m1.options[i].selected == true ) {
           m1.options[i] = null;
			j = i;
       }
   }
	
	if (j == -1)
		return;
		
	// move focus to the next item
	if (m1.length <= 0)
		return;
		
	if ((j < 0) || (j > m1.length))
		return;
		
	if (j == 0)
		m1.options[j].selected = true;
	else if (j == m1.length)
		m1.options[j-1].selected = true
	else
		m1.options[j].selected = true;


}

function two2one(m1, m2)
{
  one2two(m2,m1);
  reloadResourceArray();
}

function blur1(m){
for(i=0;i<m.length;i++){
m.options[i].selected=false
}
}

function checkForEnter(m1, m2) {

  var charCode =  event.keyCode;
  if (charCode == 13) {
     
     one2two(m1, m2);
  }
  return false;
}

function init(m1,m2){
for(i=0;i<m2.length;i++){
ids=m2.options[i].value
for(j=0;j<m1.length;j++){
if(m1.options[j].value==ids){
m1.options[j]=null;
break;
}
}
}

}

function setResourceStr(){
	
	var resourceids1 =""
       var resourcenames1 = ""
       
	for(var i=0;i<resourceArray.length;i++){
		resourceids1 += ","+resourceArray[i].split("~")[0] ;
		
		resourcenames1 += ","+resourceArray[i].split("~")[1].replace(/,/g,"£¬") ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
	
}
function replaceStr(){
   var re=new RegExp("[ ]*[|][^|]*[|]","g")
   resourcenames=resourcenames.replace(re,"|")
   re=new RegExp("[|][^,]*","g")
   resourcenames=resourcenames.replace(re,"")   
}
function btnok_onclick(){

	 setResourceStr();
    replaceStr();
    window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
	
}
function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
}
function btnsub_onclick(){
	//window.parent.parent.frame1.SearchForm.btnsub.click();
		var curDoc;
		if(document.all){
			curDoc=window.parent.frames["frame1"].document
		}
		else{
			curDoc=window.parent.document.getElementById("frame1").contentDocument	
		}
		$(curDoc).find("#btnsub")[0].click();
}
function btncancel_onclick(){
	 window.parent.parent.close();
}
$(function(){
	$("#btnok").live("click",btnok_onclick);
	$("#btnclear").live("click",btnclear_onclick);
	$("#btnsub").live("click",btnsub_onclick);
});
</script>
 



<SCRIPT LANGUAGE=VBS>

Sub btnok_onclick()
	 setResourceStr()
     replaceStr() 
	 window.parent.returnvalue = Array(resourceids,resourcenames)
     window.parent.close
End Sub

Sub btnclear_onclick() 
	window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub

Sub btnsub_onclick()
     window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>

</BODY>
</HTML>