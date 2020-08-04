% Pidiendo primero el tamaño podemos crear la matriz y
% guardar los datos directamente sobre ella en lugar de hacerlo en vectores
% auxiliares para luego copiarlo a la matriz
n = input('Dame el tamaño de la matriz \n');
A = zeros(n,n);
% Pedimos media matriz puesto que debe de ser simétrica o hermítica
for i = 1 : n
    fprintf('Dame la fila %d de [%d..n]', i, i);
    A(i, i:n) = input(' de la matriz del sistema: \n');
    A(i+1:n, i) = A(i, i+1:n);
end
b = input('Dame el vector de terminos independientes \n');
for i = 1:n
    A(i,i) = A(i,i) - dot(A(i, 1:i-1),A(i, 1:i-1));
    if (A(i,i) <= 0)
        error('La matriz no admite factorización de Cholesky');
    end
    A(i,i) = sqrt(A(i,i));
    for j = i+1:n
        A(j,i) = (A(i,j) - dot(A(i, 1:i-1),A(j, 1:i-1)))/A(i,i);
    end
end

% Calculo de w con método de remonte
w = triangInf(A, b);
% Calculo de u con método de remonte
u = triangSupCholesky(A', w);

% Pedimos otro vector si quiere resolver mas sistemas
fprintf('La solucion a tu sistema es: \n');
fprintf('%d \n', u);
otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
while(otro == 1)
    b = input('Dame el vector de terminos independientes \n');
    % Calculo de w con método de remonte
    w = triangInf(A, b);
    % Calculo de u con método de remonte
    u = triangSupCholesky(A', w);
    fprintf('La solucion a tu sistema es: \n');
    fprintf('%d \n',u);
    otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
end

function u = triangInf(A, b)
n = size(A,1);
u = zeros(n, 1);

for i = 1 : n
    u(i) = ( b(i) - A(i, 1: i-1) * u(1:i-1) ) / A(i,i);
end
end

function u = triangSupCholesky(A, b)
n = size(A,1);
u = zeros(n, 1);
% En lugar de A(i, i+1:n), hacemos A(i+1:n, i)
% Estamos resolviendo la traspuesta
for i = n :-1: 1
    u(i) = ( b(i) - A(i, i+1:n) * u(i+1:n) ) / A(i,i) ;
end
end
