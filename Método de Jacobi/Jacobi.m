A = input('Dame la matriz del sistema \n');
n = size(A, 1);

if(size(A, 2) ~= n)
    error('La matrz debe ser cuadrada');
end

% Comprobamos que el metodo esta bien definido
for i = 1: n
    if(A(i,i) == 0)
        error('El metodo no esta bien definido');
    end
end

b = input('Dame el vector de terminos independientes \n');
iter = input('Dame el número maximo de iteraciones para el método \n');
prec = input('Dame la precisión de cálculo deseada \n');

b = b(:);
normab = norm(b);
r = zeros(n, 1);
d = zeros(n, 1);
u_k = zeros(n, 1);
precisiones = [];
% Usaremos este vector para representar la precisión después
for k = 1:iter
    % Calculamos r^k
    r = b - A*u_k;
    % Aplicamos el test de parada ¿||r^k|| < prec ||b||?
    precisiones(k) = norm(r)/normab;
    % Si hemos alcanzado la precision lo indicamos y sacamos la salida
    if precisiones(k) < prec
        iteraciones = 1:length(precisiones);
        fprintf('El valor que aproxima lo deseado es u =: \n');
        fprintf('%d \n', u_k);
        fprintf('Termina en la iteracion %d \n', iteraciones(end));
        % Representamos la precision en las distintas iteraciones
        plot(iteraciones, precisiones);
        break;
    end
    d = r./diag(A);
    u_k = u_k + d;
end
if(k == iter)
    fprintf('Se agotaron todas las iteraciones \n');
    fprintf('El valor obtenido es u =: \n');
    fprintf('%d \n', u_k);
end