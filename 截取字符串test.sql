declare @str varchar(500)
select @str = '�����������Ա��г������£�19900101������¼�����˸�ð���ʺ�ʹ��΢��ENDҽ����ȥ�ȿ���'

--������������¼"���ݣ������˸�ð���ʺ�ʹ��΢�ȡ�
select CHARINDEX('������¼',@str)+ 5

select CHARINDEX('END',@str)


select SUBSTRING(@str,CHARINDEX('������¼',@str)+ 5 ,CHARINDEX('END',@str)-(CHARINDEX('������¼',@str)+ 5))

