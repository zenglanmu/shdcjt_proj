<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<%@page import="weaver.formmode.view.ResolveFormMode"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
int fformId=Util.getIntValue(request.getParameter("formId"),0);
int modeId=Util.getIntValue(request.getParameter("modeId"),0);
int type=Util.getIntValue(request.getParameter("type"),0);
String triggerfieldnameS=request.getParameter("trg");
int tableid=0;
int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
String inputchecks="";
//System.out.println("detailsum:"+detailsum);
%>
<script language="javascript">
window.onload = function (){
<%
ResolveFormMode rfm = new ResolveFormMode(modeId,type);
ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
for(int temp=0;temp<triggerfieldnameArr.size();temp++){
	
	String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
	if(triggerfieldname.equals("")) continue;
	int indexid=Util.getIntValue(triggerfieldname.substring(triggerfieldname.indexOf("_")+1,triggerfieldname.length()));
	triggerfieldname=triggerfieldname.substring(0,triggerfieldname.indexOf("_"));
	//System.out.println("triggerfieldname:"+request.getParameter("triggerfieldname"));
	if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
		ArrayList clearjs=new ArrayList();
		clearjs=rfm.ClearDetailField(triggerfieldname,indexid);
		//System.out.println(clearjs);
		for(int i=0;i<clearjs.size();i++){
		%>
		//页面输出字段值初始化（明细字段值清除） 
		eval("<%=clearjs.get(i)%>");
		<%
		}
		String sql="select id from modeDataInputentry where modeid="+modeId+" and type='1' and TriggerFieldName='"+triggerfieldname+"'";
		//System.out.println(sql);
		rs.executeSql(sql);
		String entryid="";
		String datainputid="";
		Hashtable outdatahash=new Hashtable();
		while(rs.next()){
			entryid=rs.getString("id");
			rs1.executeSql("select id,IsCycle,WhereClause from modeDataInputmain where entryID="+entryid+" order by orderid");
			String sql1="";
			ArrayList outfieldnamelist=new ArrayList();
			ArrayList outdatasList=new ArrayList();
			ArrayList[] templist=new ArrayList[10];
			ArrayList[] templistdetail=new ArrayList[10];
			String[] isclear=new String[10];
			String[] iscleardetail=new String[10];
			
			while(rs1.next()){
				isclear[tableid]="1";
				iscleardetail[tableid]="1";
				templist[tableid]=new ArrayList();
				templistdetail[tableid]=new ArrayList();
				datainputid=rs1.getString("id");
		        //System.out.println("datainputid:"+datainputid);
				ArrayList infieldnamelist=rfm.GetInFieldName(datainputid);
				for(int i=0;i<infieldnamelist.size();i++){
		            //System.out.println((String)infieldnamelist.get(i)+"|"+Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
					rfm.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
				}
		        rfm.GetOutData(datainputid);
		        outfieldnamelist=rfm.GetOutFieldNameList();
		        outdatasList=rfm.GetOutDataList();
		        
		       if(rfm.getIsCycle().equals("1")){   //明细表字段更新
		       		for(int i=0;i<outdatasList.size();i++){
		       			outdatahash=(Hashtable)outdatasList.get(i);
			       		for(int j=0;j<outfieldnamelist.size();j++){
			       		    String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
			       		 	tempValue = Util.toExcelData(tempValue);
			       		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
		       				String js=rfm.ChangeDetailField((String)outfieldnamelist.get(j),tempValue,triggerfieldname,indexid);
		       				js = Util.StringReplace(js,"&quot；","\\\\\\\"");
		       				js = Util.StringReplace(js,"\''", "\'");
		%>
						try{
							var mainjs="<%=js%>";
							var temp=mainjs;
							var spaninx=temp.indexOf(";");					
							mainjs="";
							var indx=0;
							if(spaninx>0){
								mainjs+=temp.substring(spaninx+1,temp.length);
								temp=temp.substring(0,spaninx);						
							}
							while(temp.length>0){
								indx=temp.indexOf("<br>");
								if(indx>=0){
									mainjs+=temp.substring(0,indx)+"\\"+"r"+"\\"+"n";
									temp=temp.substring(indx+4,temp.length);
								}else{
									mainjs+=temp;
									temp="";
								}
							}	
							mainjs = mainjs.replace(/┌weaver┌/g,";");
							eval(mainjs);
							}catch(e){}
		<%
			        	}
		       		}
		       	}else{      //明细表字段更新
		       		ArrayList viewfields=new ArrayList();
		       		if(outdatasList.size()>0){
		       			viewfields=rfm.ViewDetailFieldList(fformId,tableid);
		       		}
			       for(int i=0;i<outdatasList.size();i++){
			       		outdatahash=(Hashtable)outdatasList.get(i);
			       		String html="";
				       	if(outdatahash.size()>0 && outfieldnamelist.size()>0){
			%>
							try{
							var oTable=window.parent.document.getElementById('oTable<%=tableid%>');
					        curindex=parseInt(window.parent.document.getElementById('modesnum<%=tableid%>').value);
					        rowindex=parseInt(window.parent.document.getElementById('indexnum<%=tableid%>').value);
					        oRow = oTable.insertRow(curindex+1);
					        oCell = oRow.insertCell();
					        oCell.style.height=24;
					        oCell.style.background= "#E7E7E7";
					        var oDiv = window.parent.document.createElement("div");
					        var sHtml = "<input type='checkbox' name='check_node<%=tableid%>' value='"+rowindex+"'>";
					
					        oDiv.innerHTML = sHtml;
					        oCell.appendChild(oDiv);
					        }catch(e){}
			<%
						}
						
			        	for(int j=0;j<viewfields.size();j++){
			        		int outindx=outfieldnamelist.indexOf(viewfields.get(j));
			        		if(outindx>-1){
			        			html=rfm.addcol((String)outfieldnamelist.get(outindx),(String)outdatahash.get(outfieldnamelist.get(outindx)),triggerfieldname,i,tableid);
			        		}else{
			        			html=rfm.addcol((String)viewfields.get(j),"",triggerfieldname,i,tableid);
			        		}
			        		if(!html.trim().equals("")){
		%>				try{
			                oCell = oRow.insertCell();
					        oCell.style.height=24;
					        oCell.style.background= "#E7E7E7";
					        var oDiv = window.parent.document.createElement("div");
					        var mainjs="<%=html%>";
							var temp=mainjs;
							var spaninx=temp.indexOf("<span notview");
							mainjs="";
							var indx=0;
							if(spaninx>0){
								mainjs+=temp.substring(spaninx,temp.length);
								temp=temp.substring(0,spaninx);				
							}
							while(temp.length>0){						
								indx=temp.indexOf("<br>");
								if(indx>=0){
									mainjs+=temp.substring(0,indx)+"\r\n";
									temp=temp.substring(indx+4,temp.length);							
								}else{
									mainjs+=temp;
									temp="";
								}
							}
					        oDiv.innerHTML = mainjs;
					        oCell.appendChild(oDiv);     
					        }catch(e){}    
		<%
			        		}
			        	}
		%>			try{
			        	rowindex = rowindex*1 +1;
			    		curindex = curindex*1 +1;
						window.parent.document.getElementById("modesnum<%=tableid%>").value=curindex;
						window.parent.document.getElementById("indexnum<%=tableid%>").value=rowindex;
						window.parent.calSum(<%=tableid%>);
					}catch(e){}
		<%
			        }  
			       if(outdatasList.size()>0)    
		        		tableid++;
		        }
			}
		}
		inputchecks=rfm.GetNeedCheckStr();
	}
}
%>
try{
window.parent.document.getElementById("inputcheck").value=window.parent.document.getElementById("inputcheck").value+"<%=inputchecks%>";
}catch(e){}
}

function delall(){
try{
  <%
  for(int j=0;j<detailsum;j++){
  %>
  	var oTable=window.parent.document.getElementById('oTable<%=j%>');
    len = window.parent.document.forms[0].elements.length;
    //alert(len);
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
    window.parent.document.getElementById("modesnum<%=j%>").value="0";
	window.parent.document.getElementById("indexnum<%=j%>").value="0";
  <%
  }%>
  }catch(e){}
}

</script>