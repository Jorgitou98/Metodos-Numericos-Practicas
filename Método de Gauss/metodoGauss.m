A = input('Dame la matriz del sistema \n');
b = input('Dame el vector de terminos independientes \n');
n = size(A,1);
% Vector para llevar permutaciones de las filas
punt = 1:n;
for j = 1:n-1
    % Buscamos el pivote
    [pivote, pos] = max(abs(A(punt(j:n),j)));
    if (pivote == 0)
        error('La matriz no es inversible');
    end
    % Permuto filas en el vector auxiliar
    [punt(pos+j-1), punt(j)] = deal(punt(j),punt(pos+j-1));
    % Divido entre el pivote
    for k = j+1:n
        A(punt(k),j) = A(punt(k),j) / A(punt(j),j);
    end
    % Hacemos la operacion que nos indican los elementos de las columnas
    % j en el rango de filas desde j+1 a n
    for k = j+1:n
        A(punt(k),j+1:n) = A(punt(k),j+1:n) - A(punt(k),j) * A(punt(j),j+1:n);
    end
end
% Calculo de w con método de remonte
w = triInfUnosPunt(A,b,punt);
% Calculo de u con método de remonte
u = triangSupPunt(A,w,punt);

% Pedimos otro vector si quiere resolver mas sistemas
fprintf('La solucion a tu sistema es: \n');
fprintf('%d \n',u);
otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
while(otro == 1)
    b = input('Dame el vector de terminos independientes \n');
    % Calculo de w con método de remonte
    w = triInfUnosPunt(A,b,punt);
    % Calculo de u con método de remonte
    u = triangSupPunt(A,w,punt);
    fprintf('La solucion a tu sistema es: \n');
    fprintf('%d \n',u);
    otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
end

function u = triInfUnosPunt(A, b, punt)
n = size(A,1);
u = zeros(n, 1);

for i = 1 : n
    u(i) = b(punt(i)) - A(punt(i), 1: i-1) * u(1:i-1);
end
end

function u = triangSupPunt(A, b, punt)
n = size(A,1);
u = zeros(n, 1);

for i = n :-1: 1
    u(i) = ( b(i) - A(punt(i), i+1:n) * u(i+1:n) ) / A(punt(i),i) ;
end
end
