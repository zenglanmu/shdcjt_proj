<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
    char flag = 2;
    String ProcPara = "";

    String method = Util.null2String(request.getParameter("method"));

    if(method.equals("add"))
    {
        String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
		String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

        ProcPara = "insert into DocInstancyLevel(name,desc_n) values('"+name+"','"+desc+"')";
        RecordSet.executeSql(ProcPara);

        response.sendRedirect("docInstancyLevel.jsp");
        return;
    }

    if(method.equals("edit"))
    {
        String id=Util.null2String(request.getParameter("id"));
        String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
		String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
        ProcPara = "update DocInstancyLevel set ";
        ProcPara += "name='" + name + "', ";
        ProcPara += "desc_n='" + desc + "' ";
        ProcPara += " where id = " + id ;
        RecordSet.executeSql(ProcPara);

        response.sendRedirect("docInstancyLevel.jsp");
        return;
    }

    String IDs[]=request.getParameterValues("IDs");
    if(method.equals("delete"))
    {
        if(IDs != null)
        {
            for(int i=0;i<IDs.length;i++)
            {
                ProcPara = "delete DocInstancyLevel where id = " + IDs[i];
                RecordSet.executeSql(ProcPara);

            }
        }

        response.sendRedirect("docInstancyLevel.jsp");
        return;
    }
%>
