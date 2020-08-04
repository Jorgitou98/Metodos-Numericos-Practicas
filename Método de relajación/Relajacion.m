A = input('Dame la matriz del sistema \n');

n = size(A, 1);

if(size(A, 2) ~= n)
    error('La matrz debe ser cuadrada');
end

b = input('Dame el vector de terminos independientes \n');
w = input ('Dame el factor de peso del método \n');
iter = input('Dame el número maximo de iteraciones para el método \n');
prec = input('Dame la precisión de cálculo deseada \n');
b = b(:);

normab = norm(b);
r = zeros(n, 1);
d = zeros(n, 1);
u_k = zeros(n, 1);
precisiones = [];
for k = 1:iter
    % Realizamos la iteracion i-esima
    for i = 1: n
        r(i) = b(i) - A(i,1:i-1)*u_k(1:i-1) - A(i, i:n)*u_k(i:n);
        d(i) = w*(r(i)/A(i, i));
        u_k(i) = u_k(i) + d(i);
    end
    
    % Aplicamos el test de parada ¿||r^k|| < prec ||b||?
    precisiones(k) = norm(r)/normab;
    if precisiones(k) < prec
        % Generamos el vector de iteraciones para graficar después
        iteraciones = 1:length(precisiones);
        fprintf('El valor que aproxima lo deseado es u =: \n');
        fprintf('%d \n', u_k);
        fprintf('Termina en la iteracion %d \n', iteraciones(end));
        plot(iteraciones, precisiones);
        break;
    end
end

if(k == iter) 
    fprintf('Se agotaron todas las iteraciones \n');
    fprintf('El valor obtenido es u =: \n');
    fprintf('%d \n', u_k);
end
