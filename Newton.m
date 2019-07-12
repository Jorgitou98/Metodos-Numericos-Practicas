
%Pregunto comoquiere interpolar

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

%Declaramos los vectores con la funcion pi y el que llevará el polinomio
n = size(ptos,2) - 1;

pol = [];
Pi = ones(1);
difDivididas = imagenes;
for k = 0:n
    % Calculamos el polinomio con el pi anterior
    pol = [0, pol] + Pi*difDivididas(1);
    % Calculamos el productorio hasta esta iteracion
    Pi = [Pi, 0] - [0, Pi.*ptos(k+1)];
    for i = 1:n-k
        % Calculamos la siguiente diferencia dividida
        % Reaprovechamos el vector de imagenes para ello
        difDivididas(i) = (difDivididas(i) - difDivididas(i+1))/(ptos(i) - ptos(i+k+1));
    end
end
% Espaciado para la representacion
espaciado = linspace(min(ptos(:)), max(ptos(:)), 200);
% Segun el caso en que estemos hacemos la grafica que corresponda
if(tipo == 0)
    hold on;
    plot(espaciado, f(espaciado(:)));
    plot(espaciado, polyval(pol, espaciado));
    scatter(ptos,imagenes);
    hold off;
end
if(tipo == 1)
    hold on;
    plot(espaciado, polyval(pol, espaciado));
    scatter(ptos,imagenes);
    hold off;
end

% Mientras quiera interpolar en mas puntos seguimos
seguir = input('¿Quiere interpolar con algún punto mas?. 0) No -- Otro) Si \n');
while(seguir ~= 0)
    n = n+1;
    %Pido los datos que correspondan para ampliar el polinomio
    %Redimensionando mis vectores de ptos e imagenes
    if(tipo == 0)
        nPto = input('Dame el nuevo punto \n');
        ptos =[ptos, nPto];
        imagenes =[imagenes, f(nPto)];
        difDivididas = [difDivididas, f(nPto)];
        
    end
    if(tipo == 1)
        nPto = input('Dame el nuevo punto \n');
        nImagen = input('Dame la nueva imagen \n');
        ptos =[ptos, nPto];
        imagenes =[imagenes, nImagen];
        difDivididas = [difDivididas, nImagen];
    end
    
    % Recalculamos las diferencias divididas
    for i = n:-1:1
        difDivididas(i) = (difDivididas(i) - difDivididas(i+1))/(ptos(i) - ptos(n+1));
    end
    pol = [0, pol] + Pi*difDivididas(1);
    Pi = [Pi, 0] - [0, Pi.*ptos(n+1)];
    
    % Espaciado para la representacion
    espaciado = linspace(min(ptos(:)), max(ptos(:)), 200);
    % Segun el caso en que estemos hacemos la grafica que corresponda
    if(tipo == 0)
        hold on;
        plot(espaciado, f(espaciado(:)));
        plot(espaciado, polyval(pol, espaciado));
        scatter(ptos,imagenes);
        hold off;
    end
    if(tipo == 1)
        hold on;
        plot(espaciado, polyval(pol, espaciado));
        scatter(ptos,imagenes);
        hold off;
    end
    %Pregunto si quiere seguir interpolando
    seguir = input('¿Quiere interpolar con algún punto mas?. 0) No -- Otro) Si \n');
end
