% Criado por Gilvan Soares Borges em 30/07/2015.
% 
%        Deforma localmente a função 'y(x)' através de um pulso de largura
% "width" e máximo definido pelo par ondenado "extremePoint".
%
% ENTRADA:
% X -> Vetor com os elementos de x da função a ser deformada.
% 
% Y -> Vetor com os elementos de y da função a ser deformada.
% 
% extremePoint -> Vetor com 2 elementos, correspondente coordenadas do ponto
% máximo da deformação.
% 
% width -> Largura dos primeiros nulos do pulso de deformação.
% 
% method -> Método de interpolação usado no algoritmo, influencia o formato
% do pulso de deformação.
% 
% 
% SAÍDA:
% 
% newY -> Vetor com os elementos de y da função deformada.
function newY = new_y(X, Y, extremePoint, width, method)
X2 = X; newY = Y;

[~, indx0] = min(abs(X-extremePoint(1)));
newY(indx0) = extremePoint(2);

if (width/2 < extremePoint(1));        Wesq = width/2; else Wesq = extremePoint(1);        end
if (width/2 < X(end)-extremePoint(1)); Wdir = width/2; else Wdir = X(end)-extremePoint(1); end

dx = X(2)-X(1);
nWesq = round( Wesq./dx );
nWdir = round( Wdir./dx );

indNull = indx0 + [(1-nWesq):-1  1:(nWdir-1)];
X2(indNull) = []; newY(indNull) = [];

newY = interp1(X2, newY, X, method);