delete from HtmlLabelIndex where id in (20023,20024,20025,20026)
go
delete from HtmlLabelInfo where indexid in (20023,20024,20025,20026)
go

INSERT INTO HtmlLabelIndex values(20023,'˵����������ļ�������ֶ�ӳ����������Ҳ��������еĵ����ļ��ֶ��������ϵ���ֶν��ж�Ӧ��
�磺�����ļ��еġ��ƶ��绰���ֶ���ϵͳ�ġ��ֻ����ֶζ�Ӧ��') 
GO
INSERT INTO HtmlLabelIndex values(20024,'˵����ѡ���Զ���Ϊ�ָ�����CSV�ļ������Խ�������������Outlook��Foxmail����������ϵ����Ϣ�����ʼ���ϵ���С�') 
GO
INSERT INTO HtmlLabelIndex values(20025,'˵����ѡ��������Դ�����Ϳ��Խ�ϵͳ�û������ʼ���ϵ���С�����ϵ����ɾ��������û�����Ӱ��������Դģ������ݡ�') 
GO
INSERT INTO HtmlLabelIndex values(20026,'˵����ѡ�񡰿ͻ���ϵ�ˡ����Ϳ��Խ�ϵͳ�еĿͻ���ϵ�˵����ʼ���ϵ���С�����ϵ����ɾ��������û�����Ӱ��ͻ���Դģ������ݡ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(20023,'˵����������ļ�������ֶ�ӳ����������Ҳ��������еĵ����ļ��ֶ��������ϵ���ֶν��ж�Ӧ���磺�����ļ��еġ��ƶ��绰���ֶ���ϵͳ�ġ��ֻ����ֶζ�Ӧ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20023,'Help: please establish field mapping between CSV and Mail Contacters.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20024,'˵����ѡ���Զ���Ϊ�ָ�����CSV�ļ������Խ�������������Outlook��Foxmail����������ϵ����Ϣ�����ʼ���ϵ���С�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20024,'Help: you can import data from CSV into Mail Contacter.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20025,'˵����ѡ��������Դ�����Ϳ��Խ�ϵͳ�û������ʼ���ϵ���С�����ϵ����ɾ��������û�����Ӱ��������Դģ������ݡ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20025,'Help: you can import users from HRM into Mail Contacter.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20026,'˵����ѡ�񡰿ͻ���ϵ�ˡ����Ϳ��Խ�ϵͳ�еĿͻ���ϵ�˵����ʼ���ϵ���С�����ϵ����ɾ��������û�����Ӱ��ͻ���Դģ������ݡ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20026,'Help: you can import contacters from CRM into Mail Contacter.',8) 
GO