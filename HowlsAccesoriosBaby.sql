-- Creación de la base de datos 

CREATE DATABASE HowlsAccesoriosBaby;
GO

--Seleccion de base de datos

USE HowlsAccesoriosBaby;
GO

-- Creación de las tablas

-- 1. Clientes

CREATE TABLE Clientes (
    idCliente INT PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NULL,
    fechaRegistro DATE NOT NULL,
    estado VARCHAR(15) NOT NULL,

    CHECK (estado IN ('Activo', 'Inactivo'))
);

-- 2. Categorias

CREATE TABLE Categorias (
    idCategoria INT PRIMARY KEY,
    nombreCategoria VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(200) NULL,
    estado VARCHAR(15) NOT NULL,

    CHECK (estado IN ('Activo', 'Inactivo'))
);

-- 3. Canales de venta

CREATE TABLE CanalesVenta (
    idCanal INT PRIMARY KEY,
    nombreCanal VARCHAR(50) NOT NULL,
    estado VARCHAR(15) NOT NULL,

    CHECK (estado IN ('Activo', 'Inactivo'))
);

-- 4. Metodos de pago

CREATE TABLE MetodosPago (
    idMetodoPago INT PRIMARY KEY,
    nombreMetodo VARCHAR(50) NOT NULL UNIQUE,
    estado VARCHAR(15) NOT NULL,

    CHECK (estado IN ('Activo', 'Inactivo'))
);

-- 5. Proveedores

CREATE TABLE Proveedores (
    idProveedor INT PRIMARY KEY,
    nombreProveedor VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(100) NULL,
    ciudad VARCHAR(60) NOT NULL,
    estado VARCHAR(15) NOT NULL,

    CHECK (estado IN ('Activo', 'Inactivo'))
);

-- 6. Direcciones

CREATE TABLE Direcciones (
    idDireccion INT PRIMARY KEY,
    idCliente INT NOT NULL,
    departamento VARCHAR(60) NOT NULL,
    municipio VARCHAR(60) NOT NULL,
    barrio VARCHAR(80) NULL,
    direccion VARCHAR(150) NOT NULL,
    codigoPostal VARCHAR(10) NULL,
    indicaciones VARCHAR(200) NULL,
    esPrincipal BIT NOT NULL,

    FOREIGN KEY (idCliente)
    REFERENCES Clientes(idCliente),

    UNIQUE (idDireccion, idCliente)
);

-- 7. Productos

CREATE TABLE Productos (
    idProducto INT PRIMARY KEY,
    idCategoria INT NOT NULL,
    idProveedor INT NOT NULL,
    nombreProducto VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    precio DECIMAL(10,2) NOT NULL,
    stockActual INT NOT NULL,
    estado VARCHAR(15) NOT NULL,

    FOREIGN KEY (idCategoria)
    REFERENCES Categorias(idCategoria),

    FOREIGN KEY (idProveedor)
    REFERENCES Proveedores(idProveedor),

    CHECK (precio > 0),
    CHECK (stockActual >= 0),
    CHECK (estado IN ('Disponible', 'Agotado', 'Inactivo'))
);

-- AGREGAR TALLAS DISPONIBLES

ALTER TABLE Productos
ADD tallasDisponibles VARCHAR(200) NULL;
GO

-- 8. Movimientos de inventario

CREATE TABLE MovimientosInventario (
    idMovimiento INT PRIMARY KEY,
    idProducto INT NOT NULL,
    fechaMovimiento DATETIME NOT NULL,
    tipoMovimiento VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(150) NOT NULL,

    FOREIGN KEY (idProducto)
    REFERENCES Productos(idProducto),

    CHECK (tipoMovimiento IN ('Entrada', 'Salida')),
    CHECK (cantidad > 0)
);

-- 9. Pedidos

CREATE TABLE Pedidos (
    idPedido INT PRIMARY KEY,
    idCliente INT NOT NULL,
    idDireccion INT NOT NULL,
    idCanal INT NOT NULL,
    fechaPedido DATETIME NOT NULL,
    estadoPedido VARCHAR(25) NOT NULL,
    observaciones VARCHAR(250) NULL,

    FOREIGN KEY (idCliente)
    REFERENCES Clientes(idCliente),

    FOREIGN KEY (idDireccion, idCliente)
    REFERENCES Direcciones(idDireccion, idCliente),

    FOREIGN KEY (idCanal)
    REFERENCES CanalesVenta(idCanal),

    CHECK (estadoPedido IN (
        'Pendiente',
        'Confirmado',
        'En preparacion',
        'Enviado',
        'Entregado',
        'Cancelado'
    ))
);

-- 10. Detalle de pedidos

CREATE TABLE DetallePedido (
    idDetalle INT PRIMARY KEY,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (idPedido)
    REFERENCES Pedidos(idPedido),

    FOREIGN KEY (idProducto)
    REFERENCES Productos(idProducto),

    CHECK (cantidad > 0),
    CHECK (precioUnitario > 0),

    UNIQUE (idPedido, idProducto)
);

-- 11. Pagos

CREATE TABLE Pagos (
    idPago INT PRIMARY KEY,
    idPedido INT NOT NULL,
    idMetodoPago INT NOT NULL,
    fechaPago DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estadoPago VARCHAR(20) NOT NULL,
    referencia VARCHAR(100) NULL,

    FOREIGN KEY (idPedido)
    REFERENCES Pedidos(idPedido),

    FOREIGN KEY (idMetodoPago)
    REFERENCES MetodosPago(idMetodoPago),

    CHECK (monto > 0),

    CHECK (estadoPago IN (
        'Pendiente',
        'Aprobado',
        'Rechazado',
        'Reembolsado'
    ))
);

-- 12. Envios

CREATE TABLE Envios (
    idEnvio INT PRIMARY KEY,
    idPedido INT NOT NULL,
    transportadora VARCHAR(80) NOT NULL,
    numeroGuia VARCHAR(50) NULL,
    fechaDespacho DATETIME NULL,
    costoEnvio DECIMAL(10,2) NOT NULL,
    estadoEnvio VARCHAR(20) NOT NULL,

    FOREIGN KEY (idPedido)
    REFERENCES Pedidos(idPedido),

    UNIQUE (idPedido),

    CHECK (costoEnvio >= 0),

    CHECK (estadoEnvio IN (
        'Pendiente',
        'Preparando',
        'Despachado',
        'En transito',
        'Entregado',
        'Devuelto'
    ))
);

-- 1. REGISTRO DE CLIENTES

INSERT INTO Clientes (idCliente, nombres, apellidos, telefono, correo, fechaRegistro, estado)
VALUES
(1, 'Laura', 'Gomez', '3001234567', 'laura.gomez@example.com', '2026-01-10', 'Activo'),
(2, 'Andres', 'Restrepo', '3012345678', 'andres.restrepo@example.com', '2026-01-12', 'Activo'),
(3, 'Camila', 'Torres', '3023456789', 'camila.torres@example.com', '2026-01-15', 'Activo'),
(4, 'Daniela', 'Martinez', '3034567890', 'daniela.martinez@example.com', '2026-01-18', 'Activo'),
(5, 'Santiago', 'Lopez', '3045678901', 'santiago.lopez@example.com', '2026-01-20', 'Activo'),
(6, 'Valentina', 'Perez', '3056789012', 'valentina.perez@example.com', '2026-01-22', 'Activo'),
(7, 'Sebastian', 'Ramirez', '3067890123', 'sebastian.ramirez@example.com', '2026-01-25', 'Activo'),
(8, 'Mariana', 'Castro', '3078901234', 'mariana.castro@example.com', '2026-02-01', 'Activo'),
(9, 'Juan', 'Cardona', '3089012345', 'juan.cardona@example.com', '2026-02-03', 'Activo'),
(10, 'Isabella', 'Moreno', '3101234567', 'isabella.moreno@example.com', '2026-02-05', 'Activo'),
(11, 'Nicolas', 'Hernandez', '3112345678', 'nicolas.hernandez@example.com', '2026-02-08', 'Activo'),
(12, 'Sofia', 'Vargas', '3123456789', 'sofia.vargas@example.com', '2026-02-10', 'Activo'),
(13, 'Mateo', 'Giraldo', '3134567890', 'mateo.giraldo@example.com', '2026-02-12', 'Activo'),
(14, 'Valeria', 'Duque', '3145678901', 'valeria.duque@example.com', '2026-02-15', 'Inactivo'),
(15, 'Samuel', 'Rios', '3156789012', NULL, '2026-02-18', 'Activo');
GO

-- 2. REGISTRO DE CATEGORIAS

INSERT INTO Categorias (idCategoria, nombreCategoria, descripcion, estado)
VALUES
(1, 'Dulce comienzo', 'Conjuntos y prendas para los primeros meses del bebe.', 'Activo'),
(2, 'Estrellitas Baby', 'Pijamas y prendas para el descanso del bebe.', 'Activo'),
(3, 'Pequeños exploradores', 'Prendas casuales y comodas para explorar.', 'Activo'),
(4, 'Dulce verano', 'Prendas y accesorios para disfrutar del verano.', 'Activo'),
(5, 'Pequeños tesoros', 'Accesorios y complementos para bebes.', 'Activo'),
(6, 'Regalos con amor', 'Sets, peluches y regalos especiales para bebes.', 'Activo');
GO

-- 3. REGISTRO DE CANALES DE VENTA

INSERT INTO CanalesVenta (idCanal, nombreCanal, estado)
VALUES
(1, 'Instagram', 'Activo'),
(2, 'WhatsApp', 'Activo'),
(3, 'Tienda online', 'Activo');
GO

-- 4. REGISTRO DE METODOS DE PAGO

INSERT INTO MetodosPago (idMetodoPago, nombreMetodo, estado)
VALUES
(1, 'Transferencia bancaria', 'Activo'),
(2, 'Nequi', 'Activo'),
(3, 'Pago contraentrega', 'Activo');
GO

-- 5. REGISTRO DE PROVEEDORES

INSERT INTO Proveedores (idProveedor, nombreProveedor, telefono, correo, ciudad, estado)
VALUES
(1, 'Mundo Infantil', '3004567890', 'contacto@mundoinfantil.com', 'Medellin', 'Activo'),
(2, 'Distribuciones Baby', '3015678901', 'ventas@distribucionesbaby.com', 'Bogota', 'Activo'),
(3, 'Comercializadora Infantil', '3026789012', 'ventas@mundoinfantil.com', 'Cali', 'Activo'),
(4, 'Textiles Pequeños', '3037890123', 'contacto@textilespequenos.com', 'Medellin', 'Activo'),
(5, 'Accesorios del Bebé', '3048901234', 'ventas@accesoriosbebe.com', 'Barranquilla', 'Activo');
GO

-- 6. REGISTRO DE DIRECCIONES

INSERT INTO Direcciones (idDireccion, idCliente, departamento, municipio, barrio, direccion, codigoPostal, indicaciones, esPrincipal)
VALUES
(1, 1, 'Antioquia', 'Medellin', 'Laureles', 'Carrera 75 # 34-20', '050031', 'Casa de fachada blanca', 1),
(2, 2, 'Antioquia', 'Itagui', 'Santa Maria', 'Calle 75 # 52-18', '055413', 'Apartamento segundo piso', 1),
(3, 3, 'Cundinamarca', 'Bogota', 'Chapinero', 'Carrera 13 # 60-25', '110231', 'Edificio residencial', 1),
(4, 4, 'Valle del Cauca', 'Cali', 'San Fernando', 'Calle 5 # 35-40', '760042', 'Casa junto al parque', 1),
(5, 5, 'Antioquia', 'Envigado', 'La Magnolia', 'Carrera 43A # 35 Sur-12', '055422', 'Porteria principal', 1),
(6, 6, 'Atlantico', 'Barranquilla', 'Alto Prado', 'Calle 80 # 53-15', '080001', 'Apartamento 301', 1),
(7, 7, 'Santander', 'Bucaramanga', 'Cabecera', 'Carrera 35 # 48-22', '680003', 'Casa familiar', 1),
(8, 8, 'Bolivar', 'Cartagena', 'Manga', 'Calle 25 # 18-30', '130001', 'Casa de dos pisos', 1),
(9, 9, 'Antioquia', 'Sabaneta', 'Las Vegas', 'Carrera 48 # 65 Sur-20', '055450', 'Unidad residencial', 1),
(10, 10, 'Risaralda', 'Pereira', 'Pinares', 'Calle 12 # 18-45', '660003', 'Apartamento 402', 1),
(11, 11, 'Caldas', 'Manizales', 'Palermo', 'Carrera 25 # 68-10', '170001', 'Casa esquinera', 1),
(12, 12, 'Tolima', 'Ibague', 'La Pola', 'Calle 7 # 3-28', '730001', 'Casa de fachada gris', 1),
(13, 13, 'Norte de Santander', 'Cucuta', 'Caobos', 'Avenida 0 # 15-35', '540003', 'Edificio Los Pinos', 1),
(14, 14, 'Boyaca', 'Tunja', 'Centro', 'Carrera 10 # 19-40', '150001', 'Casa colonial', 1),
(15, 15, 'Antioquia', 'Bello', 'Cabanas', 'Carrera 55 # 23-16', '051053', 'Unidad residencial', 1),
(16, 1, 'Antioquia', 'Itagui', 'Suramerica', 'Calle  side 45 # 52-10', '055410', 'Direccion alternativa', 0),
(17, 2, 'Antioquia', 'Medellin', 'Belen', 'Carrera 80 # 30-15', '050030', 'Direccion de un familiar', 0),
(18, 3, 'Cundinamarca', 'Chia', 'Centro', 'Calle 10 # 8-25', '250001', 'Casa de familiar', 0),
(19, 4, 'Valle del Cauca', 'Palmira', 'Las Flores', 'Carrera 28 # 42-18', '763531', 'Direccion alternativa', 0),
(20, 5, 'Antioquia', 'Sabaneta', 'Aves Maria', 'Calle 75 Sur # 34-20', '055450', 'Direccion de trabajo', 0);
GO
-- CORREGIR DIRECCION 16

UPDATE Direcciones
SET direccion = 'Calle 45 # 52-10'
WHERE idDireccion = 16;
GO



-- 7. REGISTRO DE PRODUCTOS

INSERT INTO Productos (idProducto, idCategoria, idProveedor, nombreProducto, descripcion, precio, stockActual, estado, tallasDisponibles)
VALUES

    -- CATEGORIA 1: DULCE COMIENZO
    (1, 1, 1, 'Conjunto overol + blusa niña', NULL, 65000, 12, 'Disponible', '6/9, 9/12, 12/18, 18/24, 24/36, 36/48 meses'),
    (2, 1, 2, 'Conjunto buzo + pantalon bebe unisex', NULL, 58000, 10, 'Disponible', '0/3, 3/6, 6/9 meses'),
    (3, 1, 3, 'Conjunto body + vestido algodon bebe niña', NULL, 69900, 8, 'Disponible', '0/3, 6/9, 9/12, 12/18, 18/24 meses'),
    (4, 1, 4, 'Conjunto camiseta + bermuda Bluey niño', NULL, 80000, 7, 'Disponible', '12/18M, 18/24M, 2T, 4T, 5T, 6T'),
    (5, 1, 5, 'Conjunto + peluche de apego bebe unisex', NULL, 86900, 6, 'Disponible', '0/3, 3/6, 6/9 meses'),

    -- CATEGORIA 2: ESTRELLITAS BABY
    (6, 2, 1, 'Pijama algodon cierre doble sentido estampada bebe niña', NULL, 52000, 15, 'Disponible', '0/0, 0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (7, 2, 2, 'Pijama algodon cierre doble sentido estampada bebe niño', NULL, 52000, 13, 'Disponible', '0/0, 0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (8, 2, 3, 'Pijama algodon botones a presion x2unds surtida bebe unisex', NULL, 78990, 9, 'Disponible', '0/3, 3/6, 6/9, 9/12, 12/18 meses'),
    (9, 2, 4, 'Pijama buzo + pantalon algodon niña', NULL, 64000, 8, 'Disponible', '12/18M, 18/24M, 2T, 3T, 4T, 5T, 6T'),
    (10, 2, 5, 'Pijama buzo + pantalon algodon niño', NULL, 64000, 8, 'Disponible', '18/24M, 2T, 3T, 4T, 5T, 6T'),

    -- CATEGORIA 3: PEQUEÑOS EXPLORADORES
    (11, 3, 1, 'Overol largo aplique bordado algodon cafe bebe niño', NULL, 70800, 7, 'Disponible', '0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (12, 3, 2, 'Overol jardinera algodon indigo bebe niña', NULL, 63800, 9, 'Disponible', '0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (13, 3, 3, 'Camiseta regular algodon x2unds surtida bebe niña', NULL, 69990, 11, 'Disponible', '0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (14, 3, 4, 'Camiseta regular x2unds surtida bebe niño', NULL, 69990, 10, 'Disponible', '0/3, 3/6, 6/9, 9/12, 12/18, 18/24 meses'),
    (15, 3, 5, 'Polo oversize beige niño', NULL, 54990, 8, 'Disponible', '18/24M, 2T, 3T, 4T, 5T, 6T'),
    (16, 3, 1, 'Vestido midi indigo claro niña', NULL, 66990, 6, 'Disponible', '18/24M, 2T, 3T, 4T, 5T, 6T'),

    -- CATEGORIA 4: DULCE VERANO
    (17, 4, 2, 'Camibuso regular proteccion UV estampado niño', NULL, 48600, 10, 'Disponible', '18/24M, 2T, 3T, 4T, 5T, 6T'),
    (18, 4, 3, 'Vestido de baño manga larga proteccion UV estampado niña', NULL, 70990, 7, 'Disponible', '12/18M, 18/24M, 2T, 3T, 4T, 5T, 6T'),
    (19, 4, 4, 'Vestido de baño 3 piezas proteccion UV estampado niña', NULL, 85990, 6, 'Disponible', '12/18M, 18/24M, 2T, 3T, 4T, 5T, 6T'),
    (20, 4, 5, 'Vestido de baño manga larga proteccion UV estampado bebe niña', NULL, 92990, 5, 'Disponible', '6/9, 9/12, 12/18, 18/24 meses'),
    (21, 4, 1, 'Traje de baño proteccion UV 2 piezas estampado bebe niño', NULL, 94990, 5, 'Disponible', '6/9, 9/12, 12/18, 18/24 meses'),

    -- CATEGORIA 5: PEQUEÑOS TESOROS
    (22, 5, 2, 'Gorro bebe unisex algodon x2unds surtido', NULL, 39990, 12, 'Disponible', '0/0, 0/3, 3/6, 6/9 meses'),
    (23, 5, 3, 'Tenis casuales blanco niño', NULL, 70000, 8, 'Disponible', '19, 20, 21, 22, 23, 24, 25, 26'),
    (24, 5, 4, 'Medias con balaca bebe niña', NULL, 28000, 15, 'Disponible', '0/12 meses'),
    (25, 5, 5, 'Gorro bebe unisex lana x2unds surtido', NULL, 27990, 10, 'Disponible', '0/0, 0/3, 3/6, 6/9 meses'),
    (26, 5, 1, 'Tenis New Balance niña y niño', NULL, 65000, 7, 'Disponible', '23, 24, 25, 26'),
    (27, 5, 2, 'Set de gafas y moños niña', NULL, 16000, 14, 'Disponible', '0/12 meses'),

    -- CATEGORIA 6: REGALOS CON AMOR
    (28, 6, 3, 'Set recien nacido algodon bebe niña personalizado', NULL, 170990, 4, 'Disponible', '0/0, 0/3 meses'),
    (29, 6, 4, 'Set recien nacido algodon bebe niño personalizado', NULL, 170990, 4, 'Disponible', '0/0, 0/3 meses'),
    (30, 6, 5, 'Chaqueta textura peluche blanco bebe unisex', NULL, 79000, 6, 'Disponible', '0/0, 0/3, 3/6, 6/9, 9/12 meses'),
    (31, 6, 1, 'Peluche de apego conejo', NULL, 49000, 10, 'Disponible', NULL),
    (32, 6, 2, 'Cobija para bebe + peluche de oso', NULL, 82000, 8, 'Disponible', 'Unica');
    GO


 -- 8. REGISTRO DE MOVIMIENTOS DE INVENTARIO

INSERT INTO MovimientosInventario (idMovimiento, idProducto, fechaMovimiento, tipoMovimiento, cantidad, motivo)
VALUES

    -- ENTRADAS DE MERCANCIA
    (1, 1, '2026-01-05', 'Entrada', 14, 'Ingreso de mercancia inicial'),
    (2, 2, '2026-01-05', 'Entrada', 12, 'Ingreso de mercancia inicial'),
    (3, 3, '2026-01-06', 'Entrada', 10, 'Ingreso de mercancia inicial'),
    (4, 4, '2026-01-06', 'Entrada', 9, 'Ingreso de mercancia inicial'),
    (5, 5, '2026-01-07', 'Entrada', 8, 'Ingreso de mercancia inicial'),
    (6, 6, '2026-01-07', 'Entrada', 17, 'Ingreso de mercancia inicial'),
    (7, 7, '2026-01-08', 'Entrada', 15, 'Ingreso de mercancia inicial'),
    (8, 8, '2026-01-08', 'Entrada', 11, 'Ingreso de mercancia inicial'),
    (9, 9, '2026-01-09', 'Entrada', 10, 'Ingreso de mercancia inicial'),
    (10, 10, '2026-01-09', 'Entrada', 10, 'Ingreso de mercancia inicial'),
    (11, 11, '2026-01-10', 'Entrada', 9, 'Ingreso de mercancia inicial'),
    (12, 12, '2026-01-10', 'Entrada', 11, 'Ingreso de mercancia inicial'),
    (13, 13, '2026-01-11', 'Entrada', 13, 'Ingreso de mercancia inicial'),
    (14, 14, '2026-01-11', 'Entrada', 12, 'Ingreso de mercancia inicial'),
    (15, 15, '2026-01-12', 'Entrada', 10, 'Ingreso de mercancia inicial'),

    -- SALIDAS DE MERCANCIA
    (16, 1, '2026-01-15', 'Salida', 2, 'Salida por venta'),
    (17, 2, '2026-01-15', 'Salida', 2, 'Salida por venta'),
    (18, 3, '2026-01-16', 'Salida', 2, 'Salida por venta'),
    (19, 4, '2026-01-16', 'Salida', 2, 'Salida por venta'),
    (20, 5, '2026-01-17', 'Salida', 2, 'Salida por venta'),
    (21, 6, '2026-01-17', 'Salida', 2, 'Salida por venta'),
    (22, 7, '2026-01-18', 'Salida', 2, 'Salida por venta'),
    (23, 8, '2026-01-18', 'Salida', 2, 'Salida por venta'),
    (24, 9, '2026-01-19', 'Salida', 2, 'Salida por venta'),
    (25, 10, '2026-01-19', 'Salida', 2, 'Salida por venta'),
    (26, 11, '2026-01-20', 'Salida', 2, 'Salida por venta'),
    (27, 12, '2026-01-20', 'Salida', 2, 'Salida por venta'),
    (28, 13, '2026-01-21', 'Salida', 2, 'Salida por venta'),
    (29, 14, '2026-01-21', 'Salida', 2, 'Salida por venta'),
    (30, 15, '2026-01-22', 'Salida', 2, 'Salida por venta');
    GO
  

-- 9. REGISTRO DE PEDIDOS

INSERT INTO Pedidos (idPedido, idCliente, idDireccion, idCanal, fechaPedido, estadoPedido, observaciones)
VALUES
(1, 1, 1, 1, '2026-02-01', 'Entregado', 'Pedido entregado correctamente'),
(2, 2, 2, 2, '2026-02-03', 'Entregado', 'Cliente satisfecho con la compra'),
(3, 3, 3, 3, '2026-02-05', 'Entregado', 'Pedido realizado por tienda online'),
(4, 4, 4, 1, '2026-02-08', 'Enviado', 'Pedido despachado al cliente'),
(5, 5, 5, 2, '2026-02-10', 'Enviado', 'Entrega a domicilio'),
(6, 6, 6, 3, '2026-02-12', 'En preparacion', 'Pedido en proceso de empaque'),
(7, 7, 7, 1, '2026-02-14', 'Confirmado', 'Pedido confirmado por Instagram'),
(8, 8, 8, 2, '2026-02-16', 'Cancelado', 'Cliente solicito cancelar el pedido'),
(9, 9, 9, 3, '2026-02-18', 'Entregado', 'Pedido recibido por el cliente'),
(10, 10, 10, 1, '2026-02-20', 'Enviado', 'Pedido enviado por transportadora'),
(11, 11, 11, 2, '2026-02-22', 'Entregado', 'Entrega completada'),
(12, 12, 12, 3, '2026-02-24', 'Confirmado', 'Pedido pendiente de preparacion'),
(13, 13, 13, 1, '2026-02-26', 'En preparacion', 'Productos en proceso de alistamiento'),
(14, 14, 14, 2, '2026-02-28', 'Entregado', 'Pedido entregado correctamente'),
(15, 15, 15, 3, '2026-03-02', 'Enviado', 'Pedido despachado'),
(16, 1, 16, 1, '2026-03-04', 'Confirmado', 'Compra realizada por Instagram'),
(17, 2, 17, 2, '2026-03-06', 'En preparacion', 'Pedido en preparacion'),
(18, 3, 18, 3, '2026-03-08', 'Cancelado', 'Cliente cancelo antes del despacho'),
(19, 4, 19, 1, '2026-03-10', 'Entregado', 'Pedido entregado en direccion alternativa'),
(20, 5, 20, 2, '2026-03-12', 'Pendiente', 'Pedido pendiente de confirmacion');
GO


-- 10. REGISTRO DE DETALLES DE PEDIDO

INSERT INTO DetallePedido (idDetalle, idPedido, idProducto, cantidad, precioUnitario)
VALUES
(1, 1, 1, 1, 65000),
(2, 1, 6, 1, 52000),
(3, 2, 2, 1, 58000),
(4, 2, 7, 2, 52000),
(5, 3, 3, 1, 69900),
(6, 3, 11, 1, 70800),
(7, 4, 4, 1, 80000),
(8, 4, 12, 1, 63800),
(9, 5, 5, 1, 86900),
(10, 5, 8, 1, 78990),
(11, 6, 9, 1, 64000),
(12, 6, 13, 1, 69990),
(13, 7, 10, 1, 64000),
(14, 7, 14, 2, 69990),
(15, 8, 15, 1, 54990),
(16, 8, 16, 1, 66990),
(17, 9, 17, 1, 48600),
(18, 9, 18, 1, 70990),
(19, 10, 19, 1, 85990),
(20, 10, 20, 1, 92990),
(21, 11, 21, 1, 94990),
(22, 11, 22, 2, 39990),
(23, 12, 23, 1, 70000),
(24, 12, 24, 1, 28000),
(25, 13, 25, 2, 27990),
(26, 13, 26, 1, 65000),
(27, 14, 27, 2, 16000),
(28, 14, 28, 1, 170990),
(29, 15, 29, 1, 170990),
(30, 15, 30, 1, 79000),
(31, 16, 31, 1, 49000),
(32, 16, 32, 1, 82000),
(33, 17, 1, 2, 65000),
(34, 17, 2, 1, 58000),
(35, 18, 3, 1, 69900),
(36, 18, 4, 1, 80000),
(37, 19, 5, 1, 86900),
(38, 19, 6, 2, 52000),
(39, 20, 7, 1, 52000),
(40, 20, 8, 1, 78990);
GO

SELECT COUNT(*) AS TotalDetalles
FROM DetallePedido;

-- 11. REGISTRO DE PAGOS

INSERT INTO Pagos (idPago, idPedido, idMetodoPago, fechaPago, monto, estadoPago, referencia)
VALUES
(1, 1, 1, '2026-02-01', 117000, 'Aprobado', 'PAGO-001'),
(2, 2, 2, '2026-02-03', 162000, 'Aprobado', 'PAGO-002'),
(3, 3, 3, '2026-02-05', 140700, 'Aprobado', 'PAGO-003'),
(4, 4, 1, '2026-02-08', 143800, 'Aprobado', 'PAGO-004'),
(5, 5, 2, '2026-02-10', 165890, 'Aprobado', 'PAGO-005'),
(6, 6, 3, '2026-02-12', 133990, 'Aprobado', 'PAGO-006'),
(7, 7, 1, '2026-02-14', 203980, 'Aprobado', 'PAGO-007'),
(8, 8, 2, '2026-02-16', 121980, 'Reembolsado', 'PAGO-008'),
(9, 9, 3, '2026-02-18', 119590, 'Aprobado', 'PAGO-009'),
(10, 10, 1, '2026-02-20', 178980, 'Aprobado', 'PAGO-010'),
(11, 11, 2, '2026-02-22', 174970, 'Aprobado', 'PAGO-011'),
(12, 12, 3, '2026-02-24', 98000, 'Aprobado', 'PAGO-012'),
(13, 13, 1, '2026-02-26', 120980, 'Aprobado', 'PAGO-013'),
(14, 14, 2, '2026-02-28', 202990, 'Aprobado', 'PAGO-014'),
(15, 15, 3, '2026-03-02', 249990, 'Aprobado', 'PAGO-015'),
(16, 16, 1, '2026-03-04', 131000, 'Aprobado', 'PAGO-016'),
(17, 17, 2, '2026-03-06', 188000, 'Aprobado', 'PAGO-017'),
(18, 18, 3, '2026-03-08', 149900, 'Reembolsado', 'PAGO-018'),
(19, 19, 1, '2026-03-10', 190900, 'Aprobado', 'PAGO-019'),
(20, 20, 2, '2026-03-12', 130990, 'Pendiente', 'PAGO-020');
GO



-- 12. REGISTRO DE ENVIOS

INSERT INTO Envios (idEnvio, idPedido, transportadora, numeroGuia, fechaDespacho, costoEnvio, estadoEnvio)
VALUES
(1, 1, 'Coordinadora', 'CO-100001', '2026-02-02', 12000, 'Entregado'),
(2, 2, 'Interrapidisimo', 'IR-100002', '2026-02-04', 15000, 'Entregado'),
(3, 3, 'Servientrega', 'SE-100003', '2026-02-06', 13000, 'Entregado'),
(4, 4, 'Coordinadora', 'CO-100004', '2026-02-09', 12000, 'En transito'),
(5, 5, 'Interrapidisimo', 'IR-100005', '2026-02-11', 15000, 'En transito'),
(6, 6, 'Servientrega', 'SE-100006', NULL, 13000, 'Preparando'),
(7, 7, 'Coordinadora', NULL, NULL, 12000, 'Pendiente'),
(8, 9, 'Interrapidisimo', 'IR-100009', '2026-02-19', 15000, 'Entregado'),
(9, 10, 'Servientrega', 'SE-100010', '2026-02-21', 13000, 'En transito'),
(10, 11, 'Coordinadora', 'CO-100011', '2026-02-23', 12000, 'Entregado'),
(11, 12, 'Interrapidisimo', NULL, NULL, 15000, 'Pendiente'),
(12, 13, 'Servientrega', NULL, NULL, 13000, 'Preparando'),
(13, 14, 'Coordinadora', 'CO-100014', '2026-03-01', 12000, 'Entregado'),
(14, 15, 'Interrapidisimo', 'IR-100015', '2026-03-03', 15000, 'En transito'),
(15, 16, 'Servientrega', NULL, NULL, 13000, 'Preparando'),
(16, 17, 'Coordinadora', NULL, NULL, 12000, 'Pendiente'),
(17, 19, 'Interrapidisimo', 'IR-100019', '2026-03-11', 15000, 'Entregado'),
(18, 20, 'Servientrega', NULL, NULL, 13000, 'Pendiente');
GO


-- Consultas:

-- CONSULTA 0: Mostrar todos los productos.
-- SELECT, FROM

SELECT *
FROM Productos;

-- CONSULTA 1. Consultar productos que no estén disponibles.
-- NOT

SELECT *
FROM Productos
WHERE NOT estado = 'Disponible';

-- CONSULTA 2: Filtrar productos por estado
-- where

SELECT *
FROM Productos
WHERE estado = 'Disponible';

-- CONSULTA 3: Productos disponibles con precio inferior a $50.000
--AND

SELECT *
FROM Productos
WHERE estado = 'Disponible'
AND precio < 50000;

-- CONSULTA 4: Productos con precio inferior a $50.000 o stock menor o igual a 5
-- OR

SELECT *
FROM Productos
WHERE precio < 50000
OR stockActual <= 5;

-- CONSULTA 5: Mostrar nombre, precio y stock de los productos.
-- SELECT, FROM

SELECT nombreProducto, precio, stockActual
FROM Productos;

-- CONSULTA 6: Mostrar productos con precio superior a $100.000.
-- >

SELECT *
FROM Productos
WHERE precio > 100000;

-- CONSULTA 7: Mostrar pedidos que no estén entregados.
-- <>

SELECT *
FROM Pedidos
WHERE estadoPedido <> 'Entregado';

-- CONSULTA 8: Mostrar pedidos realizados entre el 1 y el 28 de febrero de 2026.
-- SELECT, FROM, WHERE, BETWEEN

SELECT *
FROM Pedidos
WHERE fechaPedido BETWEEN '2026-02-01' AND '2026-02-28';


-- CONSULTA 9: Mostrar pedidos pendientes, confirmados o enviados.
-- SELECT, FROM, WHERE, IN

SELECT *
FROM Pedidos
WHERE estadoPedido IN ('Pendiente', 'Confirmado', 'Enviado');


-- CONSULTA 10: Mostrar pedidos que no estén cancelados ni pendientes.
-- SELECT, FROM, WHERE, NOT IN

SELECT *
FROM Pedidos
WHERE estadoPedido NOT IN ('Cancelado', 'Pendiente');


-- CONSULTA 11: Mostrar productos cuyos nombres comiencen por la letra M.
--  SELECT, FROM, WHERE, LIKE

SELECT *
FROM Productos
WHERE nombreProducto LIKE 'M%';

-- CONSULTA 12: Mostrar productos cuyos nombres terminen por la letra S.
-- LIKE

SELECT *
FROM Productos
WHERE nombreProducto LIKE '%S';

-- CONSULTA 13: Mostrar productos cuyos nombres contengan la letra A.
-- LIKE

SELECT *
FROM Productos
WHERE nombreProducto LIKE '%A%';

-- CONSULTA 14: Mostrar clientes que no tienen correo registrado.
-- SELECT, FROM, WHERE, IS NULL

SELECT *
FROM Clientes
WHERE correo IS NULL;

-- CONSULTA 15: Mostrar clientes que tienen correo registrado.
-- SELECT, FROM, WHERE, IS NOT NULL

SELECT *
FROM Clientes
WHERE correo IS NOT NULL;

-- CONSULTA 16: Mostrar los cinco productos más costosos.
-- SELECT, TOP, FROM, ORDER BY

SELECT TOP 5 *
FROM Productos
ORDER BY precio DESC;

-- CONSULTA 17: Mostrar los departamentos registrados sin repetirlos.
-- SELECT, DISTINCT, FROM

SELECT DISTINCT departamento
FROM Direcciones;

-- CONSULTA 18: Mostrar los productos ordenados de menor a mayor precio.
-- SELECT, FROM, ORDER BY, ASC

SELECT nombreProducto, precio
FROM Productos
ORDER BY precio ASC;

-- CONSULTA 19: Contar la cantidad total de productos registrados.
-- SELECT, COUNT, FROM

SELECT COUNT(*) AS TotalProductos
FROM Productos;

-- CONSULTA 20: Calcular la cantidad total de unidades disponibles en inventario.
-- SELECT, SUM, FROM

SELECT SUM(stockActual) AS TotalUnidades
FROM Productos;

-- CONSULTA 21: Calcular el precio promedio de los productos.
-- SELECT, AVG, FROM

SELECT AVG(precio) AS PrecioPromedio
FROM Productos;

-- CONSULTA 22: Consultar el precio más bajo de los productos.
-- SELECT, MIN, FROM

SELECT MIN(precio) AS PrecioMinimo
FROM Productos;

-- CONSULTA 23: Consultar el precio más alto de los productos.
-- SELECT, MAX, FROM

SELECT MAX(precio) AS PrecioMaximo
FROM Productos;

-- CONSULTA 24: Contar cuántos productos pertenecen a cada categoría.
-- SELECT, COUNT, FROM, GROUP BY

SELECT
    idCategoria,
    COUNT(*) AS TotalProductos
FROM Productos
GROUP BY idCategoria;

-- CONSULTA 25: Mostrar las categorías que tienen más de tres productos.
-- SELECT, COUNT, FROM, GROUP BY, HAVING

SELECT
    idCategoria,
    COUNT(*) AS TotalProductos
FROM Productos
GROUP BY idCategoria
HAVING COUNT(*) > 3;

-- CONSULTA 26: Mostrar los pedidos junto con los nombres de sus clientes.
-- SELECT, FROM, INNER JOIN, ON

SELECT
    P.idPedido,
    C.nombres,
    C.apellidos,
    P.fechaPedido,
    P.estadoPedido
FROM Pedidos P
INNER JOIN Clientes C
ON P.idCliente = C.idCliente;


-- CONSULTA 27: Mostrar todos los clientes, incluso aquellos que no tienen pedidos.
-- SELECT, FROM, LEFT JOIN, ON

SELECT
    C.idCliente,
    C.nombres,
    C.apellidos,
    P.idPedido
FROM Clientes C
LEFT JOIN Pedidos P
ON C.idCliente = P.idCliente;

-- CONSULTA 28: Mostrar los productos junto con el nombre de sus proveedores.
-- SELECT, FROM, INNER JOIN, ON

SELECT
    P.nombreProducto,
    P.precio,
    PR.nombreProveedor
FROM Productos P
INNER JOIN Proveedores PR
ON P.idProveedor = PR.idProveedor;


-- CONSULTA 29: Mostrar pedidos, clientes y datos de sus envíos.
-- SELECT, FROM, INNER JOIN, ON

SELECT
    P.idPedido,
    C.nombres,
    C.apellidos,
    E.transportadora,
    E.numeroGuia,
    E.estadoEnvio
FROM Pedidos P
INNER JOIN Clientes C
ON P.idCliente = C.idCliente
INNER JOIN Envios E
ON P.idPedido = E.idPedido;


-- CONSULTA 30: Crear un procedimiento para buscar productos por categoría.
-- COMANDOS: CREATE PROCEDURE, SELECT, FROM, WHERE, EXEC

CREATE PROCEDURE BuscarProductosPorCategoria
    @idCategoria INT
AS
BEGIN
    SELECT
        idProducto,
        nombreProducto,
        precio,
        stockActual,
        estado
    FROM Productos
    WHERE idCategoria = @idCategoria;
END;
GO

-- EJECUTAR EL PROCEDIMIENTO PARA CONSULTAR LA CATEGORÍA 1.
-- EXEC

EXEC BuscarProductosPorCategoria 1;




-- Verificaciones finales


-- Verificar que los 20 pedidos tengan un cliente válido.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS pedidosConCliente
FROM Pedidos
INNER JOIN Clientes
ON Pedidos.idCliente = Clientes.idCliente;

-- 2. Verificar que los 40 detalles tengan un producto válido.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS detallesConProducto
FROM DetallePedido
INNER JOIN Productos
ON DetallePedido.idProducto = Productos.idProducto;

-- 3. Verificar que los 20 pedidos tengan un pago registrado.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS pedidosConPago
FROM Pedidos
INNER JOIN Pagos
ON Pedidos.idPedido = Pagos.idPedido;

-- 4. Verificar que los 32 productos tengan una categoría válida.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS productosConCategoria
FROM Productos
INNER JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria;

-- 5. Verificar que los 32 productos tengan un proveedor válido.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS productosConProveedor
FROM Productos
INNER JOIN Proveedores
ON Productos.idProveedor = Proveedores.idProveedor;

-- 6. Verificar que los 20 pedidos tengan una dirección válida asociada a su cliente.
-- SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS pedidosConDireccionValida
FROM Pedidos
INNER JOIN Direcciones
ON Pedidos.idDireccion = Direcciones.idDireccion
AND Pedidos.idCliente = Direcciones.idCliente;

-- 7. Verificar cuántos pedidos tienen un envío registrado.
-- Comandos: SELECT, COUNT, FROM, INNER JOIN, ON.

SELECT COUNT(*) AS pedidosConEnvio
FROM Pedidos
INNER JOIN Envios
ON Pedidos.idPedido = Envios.idPedido;

-- 8. Verificar que el valor de los pagos coincida con el total de los detalles de cada pedido.
-- SELECT, FROM, WHERE, GROUP BY, HAVING, SUM.

SELECT
    Pedidos.idPedido,
    SUM(DetallePedido.cantidad * DetallePedido.precioUnitario) AS totalPedido,
    (SELECT SUM(Pagos.monto)
     FROM Pagos
     WHERE Pagos.idPedido = Pedidos.idPedido) AS totalPagado
FROM Pedidos
INNER JOIN DetallePedido
ON Pedidos.idPedido = DetallePedido.idPedido
GROUP BY Pedidos.idPedido
HAVING SUM(DetallePedido.cantidad * DetallePedido.precioUnitario) <>
       (SELECT SUM(Pagos.monto)
        FROM Pagos
        WHERE Pagos.idPedido = Pedidos.idPedido);
GO


