Dado /^de que logueo con "([^"]*)" "([^"]*)"$/ do |login, password|
  visit("http://localhost:3000")
  fill_in "Usuario", :with => login
  fill_in "Contraseña", :with => password
  click_button('Ingresar')
end

Dado /^visito la pagina de importacion$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^selecciono un archivo "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Entonces /^lleno el numero de gaceta con "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Entonces /^ingreso el archivo$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^deberia ver$/ do
  pending # express the regexp above with the code you wish you had
end

