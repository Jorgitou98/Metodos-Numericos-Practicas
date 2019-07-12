b = input('Dame la diagonal principal \n');
c = input('Dame la diagonal superior \n');
a = input('Dame la diagonal inferior \n');
d = input('Dame el vector de terminos independientes \n');
% No es necesario comprobar errores de tamaño en los datos
% Si se produce alguno el propio matlab lanzará un error
% Ya que nos saldremos de rango en algún momento
x = remonteTriDiagonal(a,b,c,d);
fprintf('La solucion a tu sistema es: \n');
fprintf('%d \n', x);
otro = input('Desea resolver otro sistema con estas diagonales (1-SI, 0-NO) \n');
while(otro == 1)
    d = input('Dame el vector de terminos independientes \n');
    % Llamo con el nuevo d
    x= remonteTriDiagonal(a,b,c,d);
    fprintf('La solucion a tu sistema es: \n');
    fprintf('%d \n', x);
    otro = input('Desea resolver otro sistema con estas diagonales (1-SI, 0-NO) \n');
end