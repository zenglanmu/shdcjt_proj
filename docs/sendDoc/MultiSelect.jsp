<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String nodeid = Util.null2String(request.getParameter("nodeid"));

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String receiveUnitId = Util.null2String(request.getParameter("receiveUnitId"));
int showsubdept=Util.getIntValue(request.getParameter("showsubdept"),0);
boolean isoracle = RecordSet.getDBType().equalsIgnoreCase("oracle");

int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("receiveUnitIdsmulti" + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }

    if (!nodeid.equals("")){
    	if(nodeid.indexOf("unit") > -1){
    		int receiveid_tmp = Util.getIntValue(nodeid.substring(nodeid.indexOf("_")+1), 0);
    		nodeid = "com_"+DocReceiveUnitComInfo.getSubcompanyid(""+receiveid_tmp);
    	}
        rem = nodeid;
    }else if(rem==null || "".equals(rem)){
   		int optSubcompanyid = Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()), 0);
    	if(optSubcompanyid > 0){
    		nodeid = "com_"+optSubcompanyid;
    	}
    	rem = nodeid;
    }

Cookie ck = new Cookie("receiveUnitIdsmulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

if(!"".equals(rem)){
	nodeid=rem;
	if(nodeid.indexOf("com")>-1){
	subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
	}else{
		receiveUnitId=nodeid.substring(nodeid.lastIndexOf("_")+1);
		//System.out.println("departmentid"+departmentid);
	}
}

//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);



String check_per = Util.null2String(request.getParameter("receiveUnitIds"));

String resourceids = "" ;
String resourcenames ="";

if(!check_per.equals("")){
	//if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	//if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	try{
		String strtmp = "select id, receiveunitname, subcompanyid from DocReceiveUnit where (canceled is null or canceled<>'1') and id in ("+check_per+")";

		//System.out.print(strtmp);
	    RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		//boolean ifhave=false;
		while(RecordSet.next()){
			String ids = RecordSet.getString("id");
			String receiveunitname = Util.null2String(RecordSet.getString("receiveunitname"));
			String subc = SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"));
	        int length = receiveunitname.getBytes().length;
	        if(length<22){
	            for(int i=0;i<22-length;i++){
	            	receiveunitname += " ";
	            }
	        }
	        String lastname = receiveunitname +"  |  "+subc;
	        ht.put(RecordSet.getString("id"), lastname);
		}
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			resourceids +=","+s;
			resourcenames += ","+Util.StringReplace(ht.get(s).toString(),",","£¬");
		}
	}catch(Exception e){
		resourceids="";
		resourcenames="";
	}
}

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(receiveUnitId.equals("0")){
	receiveUnitId = "";
}

if(subcompanyid.equals("0")){
	subcompanyid = "";
}

/*if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;*/
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

if(!receiveUnitId.equals("")){
	if(showsubdept == 0){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where (superiorunitid =" + receiveUnitId +" or id="+receiveUnitId+") " ;
		}else{
			sqlwhere += " and (superiorunitid =" + receiveUnitId +" or id="+receiveUnitId+") " ;
		}
	}else{
		if(isoracle == false){
			if(ishead==0){
				ishead = 1;
				sqlwhere += " where (','+allsuperiorunitid+',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}else{
				sqlwhere += " and (','+allsuperiorunitid+',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}
		}else{
			if(ishead==0){
				ishead = 1;
				sqlwhere += " where (','||allsuperiorunitid||',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}else{
				sqlwhere += " and (','||allsuperiorunitid||',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}
		}
	}
}
if(!subcompanyid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid =" + subcompanyid +" " ;
	}else{
		sqlwhere += " and subcompanyid =" + subcompanyid +" " ;
	}
	if(receiveUnitId.equals("") && showsubdept==0){
		sqlwhere += " and superiorunitid=0 ";
	}
}
if(ishead==0){
	ishead = 1;
	sqlwhere += " where (canceled is null or canceled<>'1') " ;
}else{
	sqlwhere += " and (canceled is null or canceled<>'1') " ;
}

/*String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;*/

String sqlstr = "select id, receiveunitname, subcompanyid from DocReceiveUnit " + sqlwhere+" order by showOrder asc";

%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

</HEAD>
<BODY>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% border="0" cellspacing="0" cellpadding="0">

<tr>
  <td height="10" colspan="3"></td>
</tr>
<tr>
  <td align="center" valign="top" width="45%">
	
			                <select size="13" name="from" multiple="true" style="width:100%" class="InputStyle" onclick="blur1($('select[name=srcList]')[0])" onkeypress="checkForEnter($('select[name=from]')[0],$('select[name=srcList]')[0])" ondblclick="one2two($('select[name=from]')[0],$('select[name=srcList]')[0])">
				             </select>
		      <script>
      <%
					
					RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){
						String ids = RecordSet.getString("id");
						String receiveunitname = Util.null2String(RecordSet.getString("receiveunitname"));
						String subc = SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"));
                        int length = receiveunitname.getBytes().length;
                        if(length<22){
                            for(int i=0;i<22-length;i++){
                            	receiveunitname += " ";
                            }
                        }
                        String lastnames = receiveunitname +" | "+subc;
                        %>

                          document.all("from").options.add(new Option('<%=lastnames%>','<%=ids%>'));


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
				</select>
  </td>
		
</tr>
<tr>
<td height="10" colspan=3></td>
</tr>
<tr>
     <td align="center" valign="bottom" colspan=3>
	<BUTTON type='button' class=btn accessKey=O  id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=2  id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON type='button' class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</TABLE>
<!--########//Shadow Table End########-->

<script language="javascript">
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"

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


init($("select[name=from]")[0],$("select[name=srcList]")[0]);



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

    reloadResourceArray();

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
	for(i=0; i<m2.length; i++){
		ids = m2.options[i].value;
		for(j=0;j<m1.length;j++){
			if(m1.options[j].value==ids){
				m1.options[j] = null;
				break;
			}
		}
	}
}

function setResourceStr(){

	var resourceids1 = "";
	var resourcenames1 = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids1 += ","+resourceArray[i].split("~")[0];
		resourcenames1 += ","+resourceArray[i].split("~")[1].replace(/,/g,"£¬");
	}
	resourceids = resourceids1;
	resourcenames = resourcenames1;
}
function replaceStr(){
	var re=new RegExp("[ ]*[|]","g");
	resourcenames = resourcenames.replace(re,"|");
	re = new RegExp("[|][^,]*","g");
	resourcenames = resourcenames.replace(re,"");
}


function btnok_onclick(){

	setResourceStr();
     replaceStr();
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
     window.parent.parent.close();
	
}
function btnclear_onclick(){
	window.parent.parent.returnValue ={id:"",name:""};
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
</script>

</BODY>
</HTML>
