# language: es
Característica: Importar datos de un pdf de lista de publicacion
  Para poder importar cuando estoy logueado
  la lista en pdf

  Escenario: Importar PDF
  Dado de que logueo con "admin" "demo123"
  Entonces deberia ingresar
  Y visito la pagina de importacion
  Entonces selecciono un archivo ""
  Y lleno el numero de gaceta con ""
  Entonces ingreso el archivo 
  Y deberia ver 
