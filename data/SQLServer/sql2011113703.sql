ALTER TABLE blog_sysSetting   ADD  attachmentDir VARCHAR(4000) NULL
GO
INSERT INTO blog_app(name,isActive,appType,sort,iconPath) VALUES('156',1,'attachment',7,'')
GO

declare @id INT
declare @managerid  INT
declare @tempmanagerid  INT
DECLARE @managetstr VARCHAR(400)
SET @managetstr=''
SET @tempmanagerid=0
declare cursor0 cursor for SELECT id,managerid FROM HrmResource ORDER BY id
open cursor0                
fetch next from cursor0  into @id,@managerid
while(@@fetch_status=0)     
begin
  
  WHILE(@managerid<>0 AND @managerid IS NOT NULL AND @managerid<>@tempmanagerid)
  BEGIN
     
     SET @tempmanagerid=@managerid
     SELECT @managetstr=@managetstr+','+CAST(id AS VARCHAR(10)),@managerid=managerid FROM HrmResource WHERE id=@managerid
  END
  
  SET @managetstr=@managetstr+','
  UPDATE HrmResource SET managerstr=@managetstr WHERE id=@id
  
  SET @managetstr=''
  
  fetch next from cursor0  into @id,@managerid
end
close cursor0        
deallocate cursor0

GO
