<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
	String fformid=Util.null2String(request.getParameter("formid"));
	String wflid=request.getParameter("id");
	String isbill=request.getParameter("bill");
	String nodeid=request.getParameter("node");
	
	int tableid=0;
	int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
	String inputchecks="";
%>
<script language="javascript" type="text/javascript">
window.onload = function(){
<%
	String triggerfieldnameS=request.getParameter("trg");
	ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
	for(int temp=0;temp<triggerfieldnameArr.size();temp++){
		String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
		if(triggerfieldname.equals("")) continue;
		int indexid = Util.getIntValue(triggerfieldname.substring(triggerfieldname.indexOf("_")+1,triggerfieldname.length()));
		triggerfieldname = triggerfieldname.substring(0,triggerfieldname.indexOf("_"));
		if(triggerfieldname != null && !triggerfieldname.trim().equals("")){
			DynamicDataInput DDI = new DynamicDataInput(wflid, triggerfieldname, isbill, "1");
			ArrayList clearjs = DDI.ClearDetailField(wflid, triggerfieldname, isbill, nodeid, indexid);
			for(int i=0; i<clearjs.size(); i++){
				String tempjs = (String)clearjs.get(i);
				tempjs = tempjs.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
				//页面输出字段值初始化（明细字段值清除） 
				eval("<%=tempjs%>");
<%			}										%>
//清除所以明细
<%
			String entryid = "";
			String datainputid = "";
			Hashtable outdatahash = new Hashtable();
			String sql="select id from Workflow_DataInput_entry where WorkFlowID="+wflid+" and type='1' and  TriggerFieldName='"+triggerfieldname+"'";
			rs.executeSql(sql);
			while(rs.next()){
				entryid=rs.getString("id");
				String sql1="";
				ArrayList outfieldnamelist = new ArrayList();
				ArrayList outdatasList = new ArrayList();
				ArrayList[] templist = new ArrayList[10];
				ArrayList[] templistdetail = new ArrayList[10];
				String[] isclear = new String[10];
				String[] iscleardetail = new String[10];
				
				rs1.executeSql("select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID = "+entryid+" order by orderid");
				while(rs1.next()){
					isclear[tableid] = "1";
					iscleardetail[tableid] = "1";
					templist[tableid] = new ArrayList();
					templistdetail[tableid]=new ArrayList();
					datainputid=rs1.getString("id");
					ArrayList infieldnamelist = DDI.GetInFieldName(datainputid);
					for(int i=0; i<infieldnamelist.size(); i++){
						DDI.SetInFields((String)infieldnamelist.get(i), Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
					}
					ArrayList conditionfieldnameList = DDI.GetConditionFieldName(datainputid);
					for(int j=0; j<conditionfieldnameList.size(); j++){
						DDI.SetConditonFields((String)conditionfieldnameList.get(j), Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j))));
					}
			        DDI.GetOutData(datainputid);
			        outfieldnamelist = DDI.GetOutFieldNameList();
			        outdatasList = DDI.GetOutDataList();
			        
			       	if(DDI.GetIsCycle().equals("1")){   //明细表字段更新
				       	for(int i=0;i<outdatasList.size();i++){
				       		outdatahash=(Hashtable)outdatasList.get(i);
				       		for(int j=0;j<outfieldnamelist.size();j++){
				       		    String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
				       		 	tempValue = Util.toExcelData(tempValue);
				       		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
			       				String js=DDI.ChangeDetailField((String)outfieldnamelist.get(j),tempValue,isbill,nodeid,triggerfieldname,indexid);
			       				js = Util.StringReplace(js,"&quot;","\\\\\\\"");
			       				js = Util.StringReplace(js,"\''", "\'");
			       				js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
			%>
								var temp = "<%=js%>";
								var spaninx = temp.indexOf(";");					
								var mainjs = "";
								if(spaninx>0){
									mainjs += temp.substring(spaninx+1,temp.length);
									temp = temp.substring(0,spaninx);						
								}
								var indx=0;
								while(temp.length > 0){
									indx = temp.indexOf("<br>");
									if(indx >= 0){
										mainjs += temp.substring(0,indx)+"\\"+"r"+"\\"+"n";
										temp = temp.substring(indx+4, temp.length);
									}else{
										mainjs += temp;
										temp = "";
									}
								}	
								mainjs = mainjs.replace(/┌weaver┌/g,";");
								eval(mainjs);
			<%
				        		
				        	}
			       		}
			       	}else{      //明细表字段更新
			       		ArrayList viewfields=new ArrayList();
			       		if(outdatasList.size()>0){
			       			viewfields=DDI.ViewDetailFieldList(fformid,nodeid,tableid);
			       		}
				       	for(int i=0;i<outdatasList.size();i++){
				       		outdatahash=(Hashtable)outdatasList.get(i);
				       		String html="";
				       		if(outdatahash.size()>0 && outfieldnamelist.size() > 0){
			%>
								var oTable = window.parent.$G('oTable<%=tableid%>', window.parent.document);
						        curindex = parseInt(window.parent.$G('nodesnum<%=tableid%>', window.parent.document).value);
						        rowindex = parseInt(window.parent.$G('indexnum<%=tableid%>', window.parent.document).value);
						        oRow = oTable.insertRow(curindex+1);
						        oCell = oRow.insertCell(-1);
						        oCell.style.height=24;
						        oCell.style.background= "#E7E7E7";
						        var oDiv = window.parent.document.createElement("div");
						        var sHtml = "<input type='checkbox' name='check_node<%=tableid%>' value='"+rowindex+"'>";
						        oDiv.innerHTML = sHtml;
						        oCell.appendChild(oDiv);
			<%
							}
							
				        	for(int j=0; j<viewfields.size(); j++){
				        		int outindx=outfieldnamelist.indexOf(viewfields.get(j));
				        		if(outindx>-1){
				        			html=DDI.addcol((String)outfieldnamelist.get(outindx),(String)outdatahash.get(outfieldnamelist.get(outindx)),isbill,nodeid,triggerfieldname,i,tableid);
				        		}else{
				        			html=DDI.addcol((String)viewfields.get(j),"",isbill,nodeid,triggerfieldname,i,tableid);
				        		}
				        		if(!html.trim().equals("")){
			%>
					                oCell = oRow.insertCell(-1);
							        oCell.style.height=24;
							        oCell.style.background= "#E7E7E7";
							        var oDiv = window.parent.document.createElement("div");
									var temp = "<%=html%>";
									var spaninx = temp.indexOf("<span notview");
									var mainjs = "";
									if(spaninx > 0){
										mainjs += temp.substring(spaninx,temp.length);
										temp = temp.substring(0,spaninx);				
									}
									var indx = 0;
									while(temp.length>0){			
										indx = temp.indexOf("<br>");
										if(indx >= 0){
											mainjs += temp.substring(0,indx) + "\r\n";
											temp = temp.substring(indx+4,temp.length);							
										}else{
											mainjs+=temp;
											temp="";
										}
									}
							        oDiv.innerHTML = mainjs;
							        oCell.appendChild(oDiv);        
			<%
				        		}
				        	}
			%>
			
				        	rowindex = rowindex*1 +1;
				    		curindex = curindex*1 +1;
							window.parent.$G("nodesnum<%=tableid%>", window.parent.document).value=curindex;
							window.parent.$G("indexnum<%=tableid%>", window.parent.document).value=rowindex;
							window.parent.calSum(<%=tableid%>);
			<%
				        }
				       	if(outdatasList.size()>0)
			        		tableid++;
			        }
				}
			}
			
			inputchecks = DDI.GetNeedCheckStr();
		}
	}
%>
	window.parent.$G("inputcheck", window.parent.document).value = window.parent.$G("inputcheck", window.parent.document).value + "<%=inputchecks%>";
}

function delall(){
<%  for(int j=0; j<detailsum; j++){  %>
  	var oTable = window.parent.$G('oTable<%=j%>', window.parent.document);
    len = window.parent.document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>')
            rowsum1 += 1;
    }
    
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>'){
            oTable.deleteRow(rowsum1);
            rowsum1 -=1;
        }
    }
    
    window.parent.calSum(<%=j%>);
    window.parent.$G("nodesnum<%=j%>", window.parent.document).value = "0";
	window.parent.$G("indexnum<%=j%>", window.parent.document).value = "0";
<%  }	                               %>
}

/**
 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
 * 却在js中使用document.getElementById(name)来获取元素的问题。
 * @param identity name或者id
 * @return 元素
 */
function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

function getElementByDocument(_document, identity) {
	return $GetEle(identity, _document);
}
</script>