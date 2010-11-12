# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# Hacer un post acerca de no dejar las constantes libres
# y colocarlas dentro de un modulo para testear
module Constants
  EMAIL_REG = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  LETRAS_REG = '[a-zñ]' # Caso especial para poder realizar las busquedas

  # Lista de caracteres especiales en expresiones regulares
  # el caracter especial \ no es considerado ya que  se transforma con el caracter
  SPECIAL_CHARS = [ ".", "|", "(", ")", "[", "]", "{", "}",  "^", "$", "+", "*", "?" ] # "+?", "*?", "\"
end
