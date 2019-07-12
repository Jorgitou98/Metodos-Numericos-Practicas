tipo = input('¿Como quieres interpolar?. 0) Dar funcion -- 1) Dar puntos e imágenes \n');
while (tipo ~= 0 && tipo ~= 1)
    tipo = input('Introduce un 0 o un 1. 0) Dar funcion -- 1) Dar puntos e imágenes \n');
end
ptos = [];
imagenes = [];

% Si es funcion construimos la entrada correctamente calculando sus imagenes
if(tipo == 0)
    % Pedimos la funcion de forma anonima
    % El usuario debe introducirla con el formato @(x)
    f = input('Dame la funcion a interpolar \n');
    ptos = input('Dame los puntos donde interpolar \n');
    numPtos = size(ptos, 2);
    imagenes = zeros(1, numPtos);
    for i = 1:numPtos
        imagenes(i) = f(ptos(i));
    end
end
% Si nos da los puntos y las imagenes contruimos los vectores adecuadamente
if(tipo == 1)
    ptos = input('Dame los puntos donde interpolar \n');
    imagenes = input('Dame los imagenes de los puntos \n');
    if(size(ptos,2) ~= size(imagenes,2))
        error('No hay igual numero de puntos e imagenes \n');
    end
end

% Como hay n+1 puntos, n es el numero de puntos menos 1
n = size(ptos,2) - 1;

% Declaramos vectores para los coeficientes del sistema que nos va a
% permitir obtener los momentos, para después hallar la funcion

lambda = zeros(n, 1);
h = zeros(n, 1);
d = zeros(n+1, 1);
mu = zeros(n, 1);

% Calculamos esto vectores para después poder hallar los momentos

h(1) = ptos(2) - ptos(1); %Def de h
for j = 1 : n-1
    h(j+1) = ptos(j+2) - ptos(j+1);
    lambda(j+1) = h(j+1)/(h(j) + h(j+1));
    mu(j) = 1 - lambda(j+1);
    d(j+1) = 6/(h(j) + h(j+1)) * ((imagenes(j+2) - imagenes(j+1))/h(j+1) - (imagenes(j+1) - imagenes(j))/h(j));
end

% Preguntamos por el tipo de funcion spline para establecer unicidad
% Solo hemos implementado los tipos I y II

tipoSpline = input('¿Que tipo de funcion Spline quieres usar? (1 o 2) \n');
while (tipoSpline ~= 0 && tipoSpline ~= 1)
    tipo = input('Introduce 1 o 2 \n');
end
% Ponemos las condiciones correspondientes a tipo I
if tipoSpline == 1
    lam(1) = 0;
    d(1) = 0;
    mu(n) = 0;
    d(n+1) = 0;
end

% Ponemos las condiciones correspondientes a tipo II
if tipoSpline == 2
    y_0 = input('Dame la derivada en 0' \n');
    y_n = input('Dame la derivada en n' \n');
    lam(1) = 1;
    d(1) = 6/h(1) * ((imagenes(2) - imagenes(1))/h(1) - y_0);
    mu(n) = 1;
    d(n+1) = 6/h(n) * (y_n - (imagenes(n+1) - imagenes(n))/h(n));
end


% Obtenemos los momentos resolviendo los correspondienes sistemas
% diagonales
M = remonteTriDiagonal(mu, repmat(2, n+1,1), lambda, d);

% Calculamos los coeficientes del polinomio en cada [x_j, x_j+1]
% Habra 4 coeficientes por cada intervalo
% Habra 4 polinomios de interplacion de grado <= 3 uno por cada intervalo
% Llevaremos una matriz n X 4 para guardar los n coeficientes de cada uno
% de los 4 polinomios

funcion = zeros(n,4);

for j = 1:n
    % Alfa es solo y_j
    beta = (imagenes(j+1) - imagenes(j))/h(j) - (2*M(j) + M(j+1))/6 * h(j);
    gamma = M(j)/2;
    delta = (M(j+1)-M(j))/(6*h(j));
    % Construimos el polinomio que interpola en [x_j, xj+1]
    funcion(j, 1) = delta;
    funcion(j, 2) = -3*delta * ptos(j) + gamma;
    funcion(j, 3) = 3*delta * ptos(j)^2 - 2 * gamma * ptos(j) + beta;
    funcion(j, 4) = -delta * ptos(j)^3 + gamma * ptos(j)^2 - beta * ptos(j) + imagenes(j);
end

if(tipo == 0)
    hold on;
    scatter(ptos,imagenes);
    for j = 1:n
        espaciado = linspace(ptos(j), ptos(j+1), 200);
        plot(espaciado, polyval(funcion(j, :), espaciado));
        plot(espaciado, f(espaciado(:)));
    end
    hold off;
end
if(tipo == 1)
    hold on;
    scatter(ptos,imagenes);
    for j = 1:n
        espaciado = linspace(ptos(j), ptos(j+1), 200);
        plot(espaciado, polyval(funcion(j, :), espaciado));
    end
    hold off;
end
function x = remonteTriDiagonal(a,b,c,d)
n = length(b);
m = zeros(n, 1);
g = zeros(n, 1);
m(1) = b(1);
if m(1) == 0
    error('La matriz A no tiene todos sus menores principales distintos de cero.');
end
g(1) = d(1) / m(1);

for k = 2:n
    m(k) = b(k) - c(k-1) / m(k-1) * a(k-1);
    if m(k) == 0
        error('La matriz A no tiene todos sus menores principales distintos de cero.');
    end
    g(k) = (d(k) - g(k-1) * a(k-1)) / m(k);
end

x(n) = g(n);
for k = n-1:-1:1
    x(k) = g(k) - c(k) / m(k) * x(k+1);
end
end
