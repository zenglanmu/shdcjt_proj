<SCRIPT language=VBS>
Sub window_onload()
    wait.style.display="none"
    On Error Resume Next
    Baco.Refresh.focus
End Sub

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>

<script language="javascript">
function displaydiv()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
    }
    else{
        spanimage.innerHTML = "<img src='/images/ArrowUpGreen.gif' border=0>" ;
        oDiv.style.display = "";
    }
}
</SCRIPT>


<div  id=oDiv style="display:none">
<img src = "/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>" border=0>
<%
int top0 = 38;   // �����ռ�
int nodexsize = 60;
int nodeysize = 40;
String currentnodeid="" + nodeid;

String bkcol = "";          // �ڵ㷽����ɫ
int icount = 0;             // �ڵ����
int curnodetype = 0;        // �ڵ�״̬  0: ��ͨ��  1: ��ǰ 2:����

ArrayList operatednode = new ArrayList();               // �ù�������������ͨ���Ľڵ�
ArrayList operaternode = new ArrayList();               // ���еķǱ�������Ĳ�����
ArrayList viewernode = new ArrayList();                 // ��ǰ�ڵ������Ѳ鿴��
ArrayList canoperaternode = new ArrayList();            // ��ǰ�ڵ������δ������

 
/*  
logtype : 
1: ����
2: �ύ
3: �˻�
4: ���´�
5: ɾ��
6: ����
9: ת��
*/

// �ù�������������ͨ���Ľڵ� logtype = 2
sql = "select distinct nodeid from workflow_requestLog where logtype='2' and requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	operatednode.add(nodeid1);
}

// ��ǰ�ڵ������Ѳ鿴��
sql = "select distinct viewer,viewtype from workflow_requestViewLog where id = "+ requestid + " and currentnodeid = "+currentnodeid;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("viewer"));
	String operatortype = Util.null2String(rs.getString("viewtype"));
	viewernode.add(operator+"_"+operatortype);
}

// ��ǰ�ڵ������δ������
sql = "select distinct userid,usertype from workflow_currentoperator where isremark = '0' and requestid = "+ requestid ;
rs.executeSql(sql);
while(rs.next())
{
	String operator = Util.null2String(rs.getString("userid"));
	String operatortype = Util.null2String(rs.getString("usertype"));
	canoperaternode.add(operator+"_"+operatortype);
}

// ���еķǱ�������Ĳ�����
sql = "select distinct nodeid,operator,operatortype from workflow_requestLog where requestid = "+requestid + " and logtype != '1' " ;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid1 = Util.null2String(rs.getString("nodeid"));
	String operator = Util.null2String(rs.getString("operator"));
	String operatortype = Util.null2String(rs.getString("operatortype"));
	operaternode.add(nodeid1+"_"+operator+"_"+operatortype);
}

// ѡ�����еĸù������Ľڵ��������Ϣ
sql = "SELECT nodeid , nodename , drawxpos, drawypos FROM workflow_flownode,workflow_nodebase WHERE (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_flownode.nodeid = workflow_nodebase.id and workflow_flownode.workflowid = "+workflowid;
rs.executeSql(sql);

while(rs.next()){
	icount ++;
    if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){     // ��ǰ�ڵ�
        curnodetype = 1;
        bkcol = "#005979";
    }
    else if(operatednode.indexOf(Util.null2String(rs.getString("nodeid")))!=-1){  // �Ѿ�ͨ���Ľڵ�
        curnodetype = 0;
        bkcol = "#0079A4";
    }
    else {
        bkcol = "#00BDFF";          // �����ڵ�
        curnodetype =2;
    }
	
    int drawxpos = rs.getInt("drawxpos");
    int drawypos = rs.getInt("drawypos");
    String nodename = Util.toScreen(rs.getString("nodename"),user.getLanguage());
%>
<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany 
STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;
TOP:<%=drawypos-nodeysize+top0%>;LEFT:<%=drawxpos-nodexsize%>;
height:<%=nodeysize*2%>;width:<%=nodexsize*2%>" LANGUAGE=javascript 
onclick="return oc_CurrentMenuOnClick(<%=icount%>)" onmouseout="return oc_CurrentMenuonmouseout(<%=icount%>)" >
    <tr height=15px>		
    <TD VALIGN=TOP style="padding-left:2px;background-color:<%=bkcol%>;color:white;border:1px solid black">
    <B><%=nodename%></B></TD>
    </TR><TR>
    <%
        if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:4px solid red;padding-left:2px">
    <%
        }else{
    %>
    <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:1px solid black;padding-left:2px">
    <%  
        }
    %>
        <%if(curnodetype==0){%>
	<img src="/images/iconemp.gif" title="�Ѳ�����">
		<%
            for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	                if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%              
                    }else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%              
                    }else{
    %>
	ϵͳ
	<%              
                    }
            		break;
		        }
            }               //  end of for
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        } else if(curnodetype==1){
    %>
	<img src="/images/imgPersonHead.gif" title="δ������">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
	            
                if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else {
    %>
	ϵͳ
	<%
                }
		        break;
		    }               // end of for
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        }else if(curnodetype==2){
    %>
	<img src="/images/imgPersonHead.gif" title="δ������">
	<%
	        sql = " select id , groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
	        rs1.executeSql(sql);
	        if(rs1.next()){
	%>
	<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
	<%
            }
    %>
	<br>&nbsp<br>
	<div align=right>
	>>>
	</div>
    <%
        }
    %>
    </TD></TR></TABLE>

    <DIV id="oc_divMenuDivision<%=icount%>" name="oc_divMenuDivision<%=icount%>" 
    style="visibility:hidden; LEFT:<%=drawxpos%>; POSITION:absolute; TOP:<%=drawypos+top0%>; WIDTH:240px; Z-INDEX: 200">
    <TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript 
     onmouseout="return oc_CurrentMenuonmouseout(<%=icount%>)" onmouseover="return oc_CurrentMenuOnClick(<%=icount%>)" 
     style="HEIGHT: 79px; WIDTH: 246px">
    <%
         if(curnodetype==0){
    %>
	 <TR id=D3><TD class=MenuPopup><img src="/images/iconemp.gif" title="�Ѳ�����">
	<%
	        for(int i=0;i<operaternode.size();i++){
                String tmp = ""+operaternode.get(i);
                if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
                {
                    String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                    String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
                    if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                    } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                    } else{ 
    %>
	ϵͳ
	<%
                    }
    %>
	&nbsp
	<%
                }
            }               // end of for
    %>
	&nbsp
	</TD></TR>
    <%  
        } else if(curnodetype==1){
    %>
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead.gif" title="δ������">
	<%
            for(int i=0;i<canoperaternode.size();i++){
                String tmp = ""+canoperaternode.get(i);
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(0,tmp.indexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%          
                } else{
    %>
	ϵͳ
	<%
                }
    %>
	&nbsp
	<%
            }       // end of for
    %>
	&nbsp
	</TD></TR>
	<TR id=D2><TD class=MenuPopup><img src="/images/icon_resource_flat.gif" title="�鿴��">
	<%
        for(int i=0;i<viewernode.size();i++){
            String tmp = ""+viewernode.get(i);
            String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
            String tmpid = tmp.substring(0,tmp.indexOf("_"));
            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
            } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
            } else{
    %>
	ϵͳ
	<%
            }
    %>
	&nbsp
	<%
        }           // end of for
    %>
	&nbsp
	</TD></TR>
    <TR id=D3><TD class=MenuPopup><img src="/images/iconemp.gif" title="�Ѳ�����">
	<%
        for(int i=0;i<operaternode.size();i++){
            String tmp = ""+operaternode.get(i);
            if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
            {
                String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
                String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
	            if(tmptype.equals("0")){
    %>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=tmpid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
	<%
                } else if(tmptype.equals("1")){
    %>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
	<%
                } else{
    %>
	ϵͳ
	<%
                }
    %>
	&nbsp
	<%
            }
        }           //  end of for
    %>
	&nbsp
	</TD></TR>
    <%
        } else if(curnodetype==2){ 
    %>
	<TR id=D1><TD class=MenuPopup><img src="/images/imgPersonHead.gif" title="δ������">
	<%
	        sql = " select id, groupname from workflow_nodegroup where nodeid = " + rs.getString("nodeid");
	        rs1.executeSql(sql);
	        while(rs1.next()){
	%>
	<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=formid%>&isbill=<%=isbill%>&id=<%=rs1.getString("id")%>"><%=Util.toScreen(rs1.getString("groupname"),user.getLanguage())%></a>
	&nbsp
	<%
            }
    %>
	</TD></TR>
    <%
        }
    %>
</TABLE>
</DIV>

<%
}       // end of the max while
%>
</div>