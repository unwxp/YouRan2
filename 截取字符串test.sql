declare @str varchar(500)
select @str = '姓名：张三性别：男出生年月：19900101病历记录：此人感冒，咽喉痛，微热END医嘱：去热颗粒'

--读出“病历记录"内容：“此人感冒，咽喉痛，微热”
select CHARINDEX('病历记录',@str)+ 5

select CHARINDEX('END',@str)


select SUBSTRING(@str,CHARINDEX('病历记录',@str)+ 5 ,CHARINDEX('END',@str)-(CHARINDEX('病历记录',@str)+ 5))

