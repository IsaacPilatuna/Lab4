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

-- ELIMINACION DE RESTRICCIONES DE LLAVES PRIMARIAS Y LLAVES FORANEAS
ALTER TABLE pruebas_pedidos.catalogo.Deudor
DROP CONSTRAINT pk_Deudor
GO


ALTER TABLE pruebas_pedidos.catalogo.Deudor
DROP CONSTRAINT debe
GO


ALTER TABLE pruebas_pedidos.movimiento.Pagos
DROP CONSTRAINT debe
GO


ALTER TABLE pruebas_pedidos.movimiento.CabezeraP
DROP CONSTRAINT solicita
GO


ALTER TABLE pruebas_pedidos.catalogo.Cliente
DROP CONSTRAINT debetener
GO


ALTER TABLE pruebas_pedidos.catalogo.Cliente
DROP CONSTRAINT pk_Cliente
GO

-- ACTUALIZACIÓN DE CÓDIGOS DE LOS CLIENTES AL NUEVO FORMATO

UPDATE pruebas_pedidos.catalogo.Cliente
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE pruebas_pedidos.catalogo.Cliente
set garante = 'C000'+substring(garante,2,3)
GO

UPDATE pruebas_pedidos.movimiento.CabezeraP
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE pruebas_pedidos.dbo.cabezacuerpoP
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE pruebas_pedidos.movimiento.Pagos
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE pruebas_pedidos.catalogo.Deudor
set codcli = 'C000'+substring(codcli,2,3)
GO

-- AGREGACIÓN DE PRIMARY KEYS

ALTER TABLE pruebas_pedidos.catalogo.Cliente 
ADD Constraint [pk_Cliente] Primary Key ([codcli])
GO


ALTER TABLE pruebas_pedidos.catalogo.Deudor 
ADD Constraint [pk_Deudor] Primary Key ([codcli])
GO