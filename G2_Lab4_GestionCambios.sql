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

-- CAMBIOS EN LA BASE DE DATOS DE PRUEBAS 

-- ELIMINACION DE RESTRICCIONES DE LLAVES PRIMARIAS Y LLAVES FORANEAS DE CÓDIGO CLIENTE
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

-- CAMBIO DE ESTRUCTURA DE LAS COLUMNAS

ALTER TABLE pruebas_pedidos.catalogo.Cliente
ALTER COLUMN codcli char(6) NOT NULL
GO

ALTER TABLE pruebas_pedidos.catalogo.Cliente
ALTER COLUMN garante char(6) 
GO

ALTER TABLE pruebas_pedidos.movimiento.CabezeraP
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE pruebas_pedidos.dbo.cabezacuerpoP
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE pruebas_pedidos.movimiento.Pagos
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE pruebas_pedidos.catalogo.Deudor
ALTER COLUMN codcli char(6) NOT NULL
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

-- AGREGACIÓN DE PRIMARY KEYS DE CÓDIGO CLIENTE

ALTER TABLE pruebas_pedidos.catalogo.Cliente 
ADD Constraint [pk_Cliente] Primary Key ([codcli])
GO


ALTER TABLE pruebas_pedidos.catalogo.Deudor 
ADD Constraint [pk_Deudor] Primary Key ([codcli])
GO

-- AGREGACIÓN DE FOREING KEYS RELACIONADAS A CÓDIGO CLIENTE

Alter table pruebas_pedidos.movimiento.[CabezeraP] add Constraint [Solicita] foreign key([codcli]) 
references pruebas_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table pruebas_pedidos.catalogo.[Cliente] add Constraint [debetener] foreign key([garante]) 
references pruebas_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table pruebas_pedidos.catalogo.Deudor add Constraint [debe] foreign key([codcli]) 
references pruebas_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table pruebas_pedidos.movimiento.[Pagos] add Constraint [debe] foreign key([codcli]) 
references pruebas_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

-- INCREMENTO DE LÍMITE DE CRÉDITO EN 10%


ALTER TABLE pruebas_pedidos.catalogo.Cliente 
DROP CONSTRAINT [checkCredito] 
GO

ALTER TABLE pruebas_pedidos.catalogo.Cliente 
ADD CONSTRAINT [checkCredito] CHECK (credito <= 2200 )
GO

-- INCREMENTO DE CRÉDITO DE LOS CLIENTES EN 10%

UPDATE pruebas_pedidos.catalogo.Cliente
set credito = credito*1.1
GO

UPDATE pruebas_pedidos.catalogo.Deudor
set LímiteCrédito = LímiteCrédito*1.1
GO

-- ELIMINACIÓN DE LAS RESTRICCIONES FOREING KEYS DE PEDIDOS

ALTER TABLE pruebas_pedidos.movimiento.DetalleP
DROP CONSTRAINT tienedetalle
GO


-- ELIMINACIÓN DE LAS RESTRICCIONES PRIMARY KEYS

ALTER TABLE pruebas_pedidos.movimiento.CabezeraP
DROP CONSTRAINT [pk_CabezeraP]
GO

-- MODIFICACIÓN DE COLUMNAS DE CÓDIGO PEDIDO AL NUEVO FORMATO

ALTER TABLE pruebas_pedidos.movimiento.CabezeraP
ALTER COLUMN codped char(10) NOT NULL
GO

ALTER TABLE pruebas_pedidos.movimiento.DetalleP
ALTER COLUMN codped char(10) 
GO

ALTER TABLE pruebas_pedidos.dbo.cabezacuerpoP
ALTER COLUMN codped char(10) 
GO

-- ACTUALIZACIÓN DE CÓDIGOS DE PEDIDOS AL NUEVO FORMATO

UPDATE pruebas_pedidos.movimiento.CabezeraP
set codped = 'PE000000'+substring(codped,2,3)
GO

UPDATE pruebas_pedidos.movimiento.DetalleP
set codped = 'PE000000'+substring(codped,2,3)
GO

UPDATE pruebas_pedidos.dbo.cabezacuerpoP
set codped = 'PE000000'+substring(codped,2,3)
GO

-- AGREGACIÓN DE LA LLAVE PRIMARIA DEL CÓDIGO PEDIDO EN LA TABLA CABEZERAP

ALTER TABLE pruebas_pedidos.movimiento.CabezeraP 
ADD Constraint [pk_CabezeraP] Primary Key ([codped])
GO

-- AGREGACIÓN DE LA LLAVE FORANEA

Alter table pruebas_pedidos.movimiento.[DetalleP] add Constraint [tienedetalle] foreign key([codped]) 
references pruebas_pedidos.movimiento.[CabezeraP] ([codped])  on update no action on delete no action 
go
/*
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- BASE DE DATOS PRODUCCION
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

-- ELIMINACION DE RESTRICCIONES DE LLAVES PRIMARIAS Y LLAVES FORANEAS DE CÓDIGO CLIENTE
ALTER TABLE produccion_pedidos.catalogo.Deudor
DROP CONSTRAINT pk_Deudor
GO


ALTER TABLE produccion_pedidos.catalogo.Deudor
DROP CONSTRAINT debe
GO


ALTER TABLE produccion_pedidos.movimiento.Pagos
DROP CONSTRAINT debe
GO


ALTER TABLE produccion_pedidos.movimiento.CabezeraP
DROP CONSTRAINT solicita
GO


ALTER TABLE produccion_pedidos.catalogo.Cliente
DROP CONSTRAINT debetener
GO


ALTER TABLE produccion_pedidos.catalogo.Cliente
DROP CONSTRAINT pk_Cliente
GO

-- CAMBIO DE ESTRUCTURA DE LAS COLUMNAS

ALTER TABLE produccion_pedidos.catalogo.Cliente
ALTER COLUMN codcli char(6) NOT NULL
GO

ALTER TABLE produccion_pedidos.catalogo.Cliente
ALTER COLUMN garante char(6) 
GO

ALTER TABLE produccion_pedidos.movimiento.CabezeraP
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE produccion_pedidos.dbo.cabezacuerpoP
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE produccion_pedidos.movimiento.Pagos
ALTER COLUMN codcli char(6) 
GO

ALTER TABLE produccion_pedidos.catalogo.Deudor
ALTER COLUMN codcli char(6) NOT NULL
GO

-- ACTUALIZACIÓN DE CÓDIGOS DE LOS CLIENTES AL NUEVO FORMATO

UPDATE produccion_pedidos.catalogo.Cliente
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE produccion_pedidos.catalogo.Cliente
set garante = 'C000'+substring(garante,2,3)
GO

UPDATE produccion_pedidos.movimiento.CabezeraP
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE produccion_pedidos.dbo.cabezacuerpoP
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE produccion_pedidos.movimiento.Pagos
set codcli = 'C000'+substring(codcli,2,3)
GO

UPDATE produccion_pedidos.catalogo.Deudor
set codcli = 'C000'+substring(codcli,2,3)
GO

-- AGREGACIÓN DE PRIMARY KEYS DE CÓDIGO CLIENTE

ALTER TABLE produccion_pedidos.catalogo.Cliente 
ADD Constraint [pk_Cliente] Primary Key ([codcli])
GO


ALTER TABLE produccion_pedidos.catalogo.Deudor 
ADD Constraint [pk_Deudor] Primary Key ([codcli])
GO

-- AGREGACIÓN DE FOREING KEYS RELACIONADAS A CÓDIGO CLIENTE

Alter table produccion_pedidos.movimiento.[CabezeraP] add Constraint [Solicita] foreign key([codcli]) 
references produccion_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table produccion_pedidos.catalogo.[Cliente] add Constraint [debetener] foreign key([garante]) 
references produccion_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table produccion_pedidos.catalogo.Deudor add Constraint [debe] foreign key([codcli]) 
references produccion_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

Alter table produccion_pedidos.movimiento.[Pagos] add Constraint [debe] foreign key([codcli]) 
references produccion_pedidos.catalogo.[Cliente] ([codcli])  on update no action on delete no action 
go

-- INCREMENTO DE LÍMITE DE CRÉDITO EN 10%


ALTER TABLE produccion_pedidos.catalogo.Cliente 
DROP CONSTRAINT [checkCredito] 
GO

ALTER TABLE produccion_pedidos.catalogo.Cliente 
ADD CONSTRAINT [checkCredito] CHECK (credito <= 2200 )
GO

-- INCREMENTO DE CRÉDITO DE LOS CLIENTES EN 10%

UPDATE produccion_pedidos.catalogo.Cliente
set credito = credito*1.1
GO

UPDATE produccion_pedidos.catalogo.Deudor
set LímiteCrédito = LímiteCrédito*1.1
GO

-- ELIMINACIÓN DE LAS RESTRICCIONES FOREING KEYS DE PEDIDOS

ALTER TABLE produccion_pedidos.movimiento.DetalleP
DROP CONSTRAINT tienedetalle
GO


-- ELIMINACIÓN DE LAS RESTRICCIONES PRIMARY KEYS

ALTER TABLE produccion_pedidos.movimiento.CabezeraP
DROP CONSTRAINT [pk_CabezeraP]
GO

-- MODIFICACIÓN DE COLUMNAS DE CÓDIGO PEDIDO AL NUEVO FORMATO

ALTER TABLE produccion_pedidos.movimiento.CabezeraP
ALTER COLUMN codped char(10) NOT NULL
GO

ALTER TABLE produccion_pedidos.movimiento.DetalleP
ALTER COLUMN codped char(10) 
GO

ALTER TABLE produccion_pedidos.dbo.cabezacuerpoP
ALTER COLUMN codped char(10) 
GO

-- ACTUALIZACIÓN DE CÓDIGOS DE PEDIDOS AL NUEVO FORMATO

UPDATE produccion_pedidos.movimiento.CabezeraP
set codped = 'PE000000'+substring(codped,2,3)
GO

UPDATE produccion_pedidos.movimiento.DetalleP
set codped = 'PE000000'+substring(codped,2,3)
GO

UPDATE produccion_pedidos.dbo.cabezacuerpoP
set codped = 'PE000000'+substring(codped,2,3)
GO

-- AGREGACIÓN DE LA LLAVE PRIMARIA DEL CÓDIGO PEDIDO EN LA TABLA CABEZERAP

ALTER TABLE produccion_pedidos.movimiento.CabezeraP 
ADD Constraint [pk_CabezeraP] Primary Key ([codped])
GO

-- AGREGACIÓN DE LA LLAVE FORANEA

Alter table produccion_pedidos.movimiento.[DetalleP] add Constraint [tienedetalle] foreign key([codped]) 
references produccion_pedidos.movimiento.[CabezeraP] ([codped])  on update no action on delete no action 
go