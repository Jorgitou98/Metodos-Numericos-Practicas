A = input('Dame la matriz del sistema \n');
b = input('Dame el vector de terminos independientes \n');
n = size(A,1);

for i =1:n
    % Calculamos los elementos diagonales de U, sobre la propia A
    % Nos permitirán determinar si la factoización es posible
    A(i,i) = A(i,i) - (A(i, 1 : i-1) * A(1 : i-1, i));
    if A(i,i) == 0
        error('La matriz no admite factorización LU');
    end
    % Calculamos el resto de elementos de U sobre la parte triangular
    % superior de A
    for k = i+1: n
        A(i, k) = A(i, k) - (A(i, 1 : i-1) * A (1 : i-1, k));
    end
    % Calculamos los elementos de L
    % sobre la parte triangular inferior de A
    for k = i+1:n
        A(k,i) = (A(k,i) - (A(k, 1 : i-1) * A(1 : i-1, i))) / A(i,i);
    end
end

% Calculo de w con método de remonte
w = triangInfUnos(A, b);
% Calculo de u con método de remonte
u = triangSup(A, w);

% Pedimos otro vector si quiere resolver mas sistemas
fprintf('La solucion a tu sistema es: \n');
fprintf('%d \n',u);
otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
while(otro == 1)
    b = input('Dame el vector de terminos independientes \n');
    % Calculo de w con método de remonte
    w = triangInfUnos(A, b);
    % Calculo de u con método de remonte
    u = triangSup(A, w);
    fprintf('La solucion a tu sistema es: \n');
    fprintf('%d \n',u);
    otro = input('Desea resolver otro sistema con esta matriz (1-SI, 0-NO) \n');
end

function u = triangInfUnos(A, b)
n = size(A,1);
u = zeros(n, 1);

for i = 1 : n
    u(i) = b(i) - (A(i, 1: i-1) * u(1:i-1));
end
end


function u = triangSup(A, b)
n = size(A,1);
u = zeros(n, 1);

for i = n :-1: 1
    u(i) = ( b(i) - (A(i, i+1:n) * u(i+1:n)) ) / A(i,i) ;
end
end


