RESTORE FILELISTONLY FROM DISK = 'D:\backup\ped.bak'
GO

RESTORE DATABASE pruebas_pedidos
FROM DISK='D:\backup\ped.bak' 
WITH RECOVERY,STATS=10,
MOVE 'pedido1' TO 'D:\data\pruebas_pedidos1.mdf',
MOVE 'pedido2' TO 'D:\data\pruebas_pedidos2.ndf',
MOVE 'pedido3' TO 'D:\data\pruebas_pedidos3.ndf',
MOVE 'pedido1_log' TO 'D:\log\pruebas_pedidos.ldf'
GO

ALTER DATABASE pruebas_pedidos MODIFY FILE (NAME='pedido1',
NEWNAME='pruebas_pedido1')
GO
ALTER DATABASE pruebas_pedidos MODIFY FILE (NAME='pedido2',
NEWNAME='pruebas_pedido2')
GO
ALTER DATABASE pruebas_pedidos MODIFY FILE (NAME='pedido3',
NEWNAME='pruebas_pedido3')
GO
ALTER DATABASE pruebas_pedidos MODIFY FILE (NAME='pedido1_log',
NEWNAME='pruebas_pedido1_log')
GO



