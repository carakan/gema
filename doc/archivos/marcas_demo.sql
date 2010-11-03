-- phpMyAdmin SQL Dump
-- version 3.3.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 02, 2010 at 05:32 PM
-- Server version: 5.1.41
-- PHP Version: 5.3.2-1ubuntu4.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gema_development`
--

--
-- Dumping data for table `marcas`
--

INSERT INTO `marcas` (`id`, `parent_id`, `usuario_id`, `tipo_signo_id`, `tipo_marca_id`, `clase_id`, `pais_id`, `numero_solicitud`, `nombre`, `numero_registro`, `fecha_registro`, `numero_renovacion`, `productos`, `estado`, `estado_fecha`, `estado_serial`, `numero_publicacion`, `numero_gaceta`, `lema`, `fecha_publicacion`, `fila`, `fecha_importacion`, `valido`, `cambios`, `importado`, `apoderado`, `representante_empresarial`, `importacion_id`, `activa`, `archivo_adjunto`, `fecha_solicitud_renovacion`, `numero_solicitud_renovacion`, `fecha_renovacion`, `fecha_instruccion`, `via_instruccion`, `descripcion_imagen`, `created_at`, `updated_at`, `anterior`, `propia`, `nombre_minusculas`, `agente_ids_serial`, `titular_ids_serial`, `errores`, `errores_manual`) VALUES
(1, 0, 1, 1, 1, 20, NULL, '4459-2009', 'TOONIX', '', NULL, '', 'MUEBLES, ESPECIALMENTE ESCRITORIOS, MESAS, SILLAS, ESPEJOS Y MARCOS DE CUADROS; ALMOHADAS, cojines, BOLSAS DE DORMIR, FIGURINES, SCULTURAS, STATUAS, ESTATUILLAS, MARCOS DE PLATOS PLASTICOS CON LICENCIA NOVEDOSOS; BARBEROS DE PLASTICO, DECORACIONES PLASTICAS PARA TORTAS; LLAVEROS NO METALICOS Y NO DE CUERO; CLIPS PARA MONEDAS NO METALICOS, CORCHOS PARA BOTELLAS; BOMBILLAS PARA BEBER, ASIENTOS INFANTILES ELEVADOS, ANDADORES INFANTILES, BASENICAS, SILLAS ALTAS, VENTILADORES DE MANO, TELEFONOS MOVILES DECORTATIVOS, ADORNOS DE ESCULTURA BLANDA PARA PARED', 'lp', '2009-10-30 00:00:00', NULL, '137895', '123', '', NULL, NULL, '2010-09-02 15:11:53', 1, '--- \n- agente_ids_serial\n- titular_ids_serial\n- descripcion_imagen\n- representante_empresarial\n', 1, 'JORGE SORUCO VILLANUEVA', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 15:08:57', '2010-09-02 17:47:49', 0, 1, 'toonix', '--- \n- 4\n', '--- \n- 2\n', NULL, NULL),
(2, 0, 1, 1, 2, 36, NULL, '4463-2009', 'CITIGOLD PRIVATE CLIENT', '', NULL, '', 'Seguros; negocios financieros; negocios monetarios; negocios inmobiliarios, en la clase 36 de la ClasificaciÃ³n Internacional.', 'lp', '2009-10-30 00:00:00', NULL, '137896', '123', '', NULL, NULL, '2010-09-02 15:11:53', 1, '--- []\n\n', 1, 'Roberto Roque Ch.', NULL, NULL, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, '2010-09-02 15:08:58', '2010-09-02 15:08:58', 0, 1, 'citigold private client', '--- []\n\n', '--- []\n\n', NULL, NULL),
(3, 0, 1, 1, 2, 36, NULL, '4464-2009', 'CITIGOLD', '', NULL, '', 'Seguros; negocios financieros; negocios monetarios; negocios inmobiliarios, en la clase 36 de la ClasificaciÃ³n Internacional.', 'lp', '2009-10-30 00:00:00', NULL, '137897', '123', '', NULL, 4, '2010-09-02 15:11:53', 1, '--- []\n\n', 1, 'Roberto Roque Ch.', NULL, NULL, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, '2010-09-02 15:08:58', '2010-09-02 15:08:58', 0, 1, 'citigold', '--- []\n\n', '--- []\n\n', NULL, NULL),
(4, 0, 1, 1, 1, 4, NULL, '1234-2010', 'SYNTIUX', '', NULL, '', 'Aceites y grasas industriales ( que no sean aceitesÂ  o grasas comestibles o esenciales), lubricantes, compuestos combustibles incluidos las esencias para motores', 'sm', '2010-09-02 00:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- \n- agente_ids_serial\n', 0, 'Juan Perez', 'Juan Perez', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 16:13:36', '2010-09-02 17:48:32', 0, 1, 'syntiux', '--- \n- 3\n- 4\n', '--- \n- 2\n', NULL, NULL),
(5, 0, 1, 1, 1, 8, NULL, '3214-2010', 'PETROGAS', '', NULL, '', 'Herramientas e instrumentos de mano, cuchillerÃ­a, tenedores y cucharas, armas blancas', 'sm', '2010-09-02 15:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, 'Ana Cadima', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 17:42:48', '2010-09-02 17:42:48', 0, 1, 'petrogas', '--- \n- 1\n', '--- \n- 1\n', NULL, NULL),
(6, 0, 1, 1, 1, 1, NULL, '1254-2010', 'Agroindustria de animaciÃ³n', '', NULL, '', 'Dibujos animados', 'sm', '2010-09-02 04:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, 'Lino Lima', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 17:44:23', '2010-09-02 17:44:23', 0, 1, 'agroindustria de animacion', '--- \n- 2\n', '--- \n- 2\n', NULL, NULL),
(7, 1, 1, 1, 1, 20, NULL, '4459-2009', 'TOONIX', '', NULL, '', 'MUEBLES, ESPECIALMENTE ESCRITORIOS, MESAS, SILLAS, ESPEJOS Y MARCOS DE CUADROS; ALMOHADAS, cojines, BOLSAS DE DORMIR, FIGURINES, SCULTURAS, STATUAS, ESTATUILLAS, MARCOS DE PLATOS PLASTICOS CON LICENCIA NOVEDOSOS; BARBEROS DE PLASTICO, DECORACIONES PLASTICAS PARA TORTAS; LLAVEROS NO METALICOS Y NO DE CUERO; CLIPS PARA MONEDAS NO METALICOS, CORCHOS PARA BOTELLAS; BOMBILLAS PARA BEBER, ASIENTOS INFANTILES ELEVADOS, ANDADORES INFANTILES, BASENICAS, SILLAS ALTAS, VENTILADORES DE MANO, TELEFONOS MOVILES DECORTATIVOS, ADORNOS DE ESCULTURA BLANDA PARA PARED', 'lp', '2009-10-30 00:00:00', NULL, '137895', '123', '', NULL, NULL, '2010-09-02 15:11:53', 1, '--- []\n\n', 1, 'JORGE SORUCO VILLANUEVA', NULL, NULL, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, '2010-09-02 15:08:57', '2010-09-02 15:08:57', 0, 1, 'toonix', '--- []\n\n', '--- []\n\n', NULL, NULL),
(8, 4, 1, 1, 1, 4, NULL, '1234-2010', 'SYNTIUX', '', NULL, '', 'Aceites y grasas industriales ( que no sean aceitesÂ  o grasas comestibles o esenciales), lubricantes, compuestos combustibles incluidos las esencias para motores', 'sm', '2010-09-02 00:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, 'Juan Perez', 'Juan Perez', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 16:13:36', '2010-09-02 16:13:36', 0, 1, 'syntiux', '--- \n- 2\n', '--- \n- 2\n', NULL, NULL),
(9, 0, 1, 1, 1, 1, NULL, '4521-2010', 'PETROLOG', '', NULL, '', 'Muchas cosas', 'sm', '2010-09-02 22:12:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, 'Hugo cueto', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 17:50:25', '2010-09-02 17:50:25', 0, 1, 'petrolog', '--- \n- 4\n', '--- \n- 1\n', NULL, NULL),
(10, 0, 1, 1, 1, 3, NULL, '7854-2010', 'BASILIUM', '', NULL, '', 'Preparaciones para blanquear y otras sustancias para la colada, preparaciones para limpiar, pulir, desengrasar y pulimentar, jabones, perfumerÃ­a, asestes esenciales, cosmÃ©ticos, lociones capilares, dentÃ­fricos', 'sm', '2010-09-02 04:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, '', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 17:51:54', '2010-09-02 17:51:54', 0, 1, 'basilium', '--- \n- 3\n', '--- \n- 1\n', NULL, NULL),
(11, 0, 1, 1, 1, 1, NULL, '7412-2010', 'SHANDII', '', NULL, '', 'Prueba', 'sm', '2010-09-02 04:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, '', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 21:30:27', '2010-09-02 21:30:27', 0, 1, 'shandii', '--- \n- 4\n', '--- \n- 6\n- 5\n', NULL, NULL),
(12, 0, 1, 1, 1, 1, NULL, '3699-2010', 'SHANSI', '', NULL, '', 'JOjojoj', 'sm', '2010-09-02 13:00:00', NULL, '', '', '', NULL, NULL, NULL, 1, '--- []\n\n', 0, '', '', NULL, 1, '', NULL, NULL, NULL, NULL, NULL, '', '2010-09-02 21:31:47', '2010-09-02 21:31:47', 0, 1, 'shansi', '--- \n- 6\n', '--- \n- 5\n', NULL, NULL);

--
-- Dumping data for table `marcas_agentes`
--

INSERT INTO `marcas_agentes` (`marca_id`, `agente_id`) VALUES
(1, 4),
(4, 3),
(4, 4),
(5, 1),
(6, 2),
(9, 4),
(10, 3),
(11, 4),
(12, 6);

--
-- Dumping data for table `marcas_titulares`
--

INSERT INTO `marcas_titulares` (`marca_id`, `titular_id`) VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(9, 1),
(10, 1),
(11, 5),
(11, 6),
(12, 5);

--
-- Dumping data for table `representantes`
--

INSERT INTO `representantes` (`id`, `nombre`, `email`, `direccion`, `telefono`, `movil`, `fax`, `pagina_web`, `type`, `valido`, `created_at`, `updated_at`, `pais_id`) VALUES
(1, 'CITIGROUP INC.', NULL, '399 Park Avenue, New York , New York 10043, Estados Unidos de NorteamÃ©rica', NULL, NULL, NULL, NULL, NULL, NULL, '2010-09-02 16:05:01', '2010-09-02 16:05:01', 65),
(2, 'THE CARTOON NETWORK, INC.', '', '1050 Techwood Drive, NW, Atlanta, Georgia 30318 USA', '', NULL, '', '', NULL, NULL, '2010-09-02 16:05:01', '2010-09-02 16:17:05', 65),
(3, 'Juan Gonzales', '', 'Calle Isac tamayo NÂº 23', '', NULL, '', '', NULL, NULL, '2010-09-02 17:45:56', '2010-09-02 17:46:51', 28),
(4, 'Ana Torroja', '', 'La Vadia del cuervo, Estadium Segundo 23', '', NULL, '', '', NULL, NULL, '2010-09-02 17:46:18', '2010-09-02 17:47:18', 64),
(5, 'Juserf Akbak', '', 'Medio Oriente', '', NULL, '', '', NULL, NULL, '2010-09-02 21:29:21', '2010-09-02 21:29:21', 1),
(6, 'Ilja Resen', '', 'Bon', '', NULL, '', '', NULL, NULL, '2010-09-02 21:29:51', '2010-09-02 21:29:51', 3);
