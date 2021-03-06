ALTER TABLE workflow_requestlog ADD receivedPersons varchar(1000)
GO




alter PROCEDURE  workflow_RequestLog_Insert @requestid	int, @workflowid	int, @nodeid	int, @logtype	char(1), @operatedate	char(10), @operatetime	char(8), @operator	int, @remark	text, @clientip	char(15), @operatortype	int, @destnodeid	int, @operate varchar(1000), @flag integer output , @msg varchar(80) output
AS declare @count integer  if @logtype = '1' begin
select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype
if @count > 0 begin update workflow_requestlog SET	 [operatedate]	 = @operatedate, [operatetime]	 = @operatetime, [remark]	 = @remark, [clientip]	 = @clientip, [destnodeid]	 = @destnodeid
WHERE ( [requestid]	 = @requestid AND [nodeid]	 = @nodeid
AND [logtype]	 = @logtype AND [operator]	 = @operator AND [operatortype]	 = @operatortype)
end else begin insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate) end end else begin  delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype
insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate)  end

GO


