% Criado por Gilvan Soares Borges em 30/07/2015.
% 
%        Deforma graficamente a fun��o 'Y(X)' adicionando um �nico pulso de
% deforma��o com o arrasto do mouse. Basta dar dois clicks com o mouse em 
% algum ponto do gr�fico, arrastar e soltar formando um ret�ngulo. Atrav�s 
% da posi��o e dimens�es desse ret�ngulo, automaticamente � definido o 
% pulso. 
%        O pulso pode ser redimensionado ao redimensionar o ret�ngulo. Para 
% mudar o formato do pulso basta redimensionar o ret�ngulo sem mudar os 
% par�metros do pulso (largura "width" e a posi��o de pico "extremePoint"). 
% Para finalizar basta clicar dentro da �rea do ret�ngulo sem redimension�-
% lo.
% 
% 
% SINTAX:
%
% -> [newY, extremePoint, width, method] = new_y2(haxes, method0); 
%        Nessa sintax, new_y2 deforma a curva associada ao handle axes 
% passado como argumento de entrada (pelo identificador "haxes"), e retorna 
% a fun��o deformada "newY" e as caracter�sticas do pulso de deforma��o 
% ("width", "extremePoint" e "method"). Essa sintax � apropriada para usar 
% de forma recursiva.
%        A vari�vel de entrada "method0" � uma string que define o formato 
% do pulso, podendo ser 'spline', 'nearest' e 'linear'. Como este pode 
% mudar ao longo da execu��o, new_y2 retorna a vari�vel "method", que 
% cont�m o formato final do pulso escolhido pelo usu�rio.
% 
% -> [..., haxes] = new_y2(X, Y, method0); 
%        Nessa sintax, new_y2 deforma a curva associada aos vetores X e Y, 
% e retorna, al�m das vari�veis da sintax anterior, o identificador "haxes" 
% para o handle axes da figura criada internamente e que tem associada a 
% curva deformada. Essa sintax � indicada para a primeira chamada da fun��o 
% new_y2, antes de us�-la recursivamente.
%      
% 
% EXEMPLO:
% 
% X = linspace(0, 1, 100); Y = ones(size(X));
% 
% [~, ~, ~, method, haxes] = new_y2(X, Y, 'spline');
% for i = 1:5
%     [~, ~, ~, method] = new_y2(haxes, method);
% end
% 
% title('Done!!')

function [newY, extremePoint, width, method, haxes] = new_y2(varargin)

    [haxes, hcurve, iMethod] = treat_input_data(nargout, varargin);        % Trata os dados de entrada e evita inconsist�ncias.
    
    title(haxes, 'Drag a rectangle in the graphic area.')

    X = get(hcurve,'XData'); Y = get(hcurve,'YData');

    hrect = imrect(haxes);                                                 % CRIA UM OBJETO RET�NGULO COM O ARRASTO DO MOUSE, QUE VAI SER ASSOCIADO A UM PULSO DE DEFORMA��O.

    concavity = concav(hrect, X, Y);                                       % Identifica se o pulso vai ser um morro ou um vale.
      
    show_pulse_param(haxes, getPosition(hrect), concavity)                 % Mostra informa��es sobre o pulso no t�tulo da figura.

    while 1
        rectParam = getPosition(hrect);
        [extremePoint, width] = pulse_param(rectParam, concavity);         % Retorna a largura e a posi��o de pico do pulso.
        method = get_method(iMethod);                                      % Define o formato do pulso.

        newY = new_y(X, Y, extremePoint, width, method);                   % DEFORMA A FUN��O Y(X) com o pulso  j� definido.
        set(hcurve,'YData', newY)

        addNewPositionCallback(hrect, ...                                  % Mostra informa��es sobre o pulso, continuamente, a cada redimensionamento do ret�ngulo.
            @(rectParam) show_pulse_param(haxes, rectParam, concavity)); 

        waitfor(gcf,'WindowButtonMotionFcn')                               % Interrompe a execu��o do programa at� houver cliks do mouse no ret�ngulo, para o usu�rio poder redimensionar o pulso.
        waitfor(gcf,'WindowButtonMotionFcn')                               % � necess�rio duas interrup��es seguidas para poder redimensionar o pulso sem o programa continuar a execu��o.

        rectParamTemp = getPosition(hrect);
        [extremePointTemp, widthTemp] = pulse_param(rectParamTemp, concavity);

        if isequal(rectParamTemp, rectParam)                               % Finaliza se houve clicks do mouse no ret�ngulo, sem redimensiona-lo.
            break

        elseif isequal([extremePointTemp widthTemp], [extremePoint width]) % Muda o formato do pulso se o ret�ngulo foi redimensionado, sem redimensionar o pulso.
            iMethod = iMethod + 1;
            if (iMethod == 4); iMethod = 1; end  
        end
    end

    delete(hrect)
    title(haxes, '')
end



function [haxes, hcurve, iMethod] = treat_input_data(nargout, varargin)
    in = varargin{1};
    nargin = length(in);

    if (  (nargin == 2) && isscalar(in{1}) && ishandle(in{1}) && ~isempty(get(get(in{1}, 'Children'), 'YData'))  )
        haxes = in{1};
        hcurve = get(haxes, 'Children');
        
        if (nargout == 5)
            warning('UFPa:ManyParam', 'The last output argument is dispensable.')
        end

    elseif (  (nargin == 3) && (isnumeric(in{1}) && isvector(in{1})) && (isnumeric(in{2}) && isvector(in{2}))  )
        figure
        haxes = axes;
        hcurve = stairs(haxes, in{1}, in{2}, 'linewidth', 2);

        ymin = min(in{2}); ymax = max(in{2});
        if (ymin ~= ymax)
            dY = ymax - ymin;
        elseif (ymin == 0)
            dY = 1;
        else
            dY = abs(ymin);
        end
        axis(haxes, [in{1}(1) in{1}(end) (ymin-dY) (ymax+dY)])

        xlabel(haxes, 'x'); ylabel(haxes, 'y');
        grid(haxes, 'on')
        
    else
        error('myApp:argChk', 'Inconsistent input arguments.')
    end

    if ischar(in{end});
        switch in{end}
            case 'spline';  iMethod = 1;
            case 'nearest'; iMethod = 2;
            case 'linear';  iMethod = 3;
            otherwise
                error('myApp:argChk', 'Unknown interpolation method.')
        end
    else
        error('myApp:argChk', 'The interpolation method must be defined by a string constant.')
    end
end


function concavity = concav(hrect, X, Y)

    endClick = get(gca,'CurrentPoint');

    rectParam = getPosition(hrect);
    [~, indx0] = min(abs(X - (rectParam(1) + rectParam(3)/2)));

    if ( (endClick(1, 2) - Y(indx0)) >= 0 ) 
        concavity = 'positive';
    else
        concavity = 'negative';
    end
end


function [extremePoint, width] = pulse_param(rectParam, concavity)

    width = rectParam(3);

    extremePoint(1) = rectParam(1) + rectParam(3)/2;
    if strcmp(concavity, 'negative')
        extremePoint(2) = rectParam(2);
    else
        extremePoint(2) = rectParam(2) + rectParam(4);
    end
end


function show_pulse_param(haxes, rectParam, concavity)

    [extremePointTemp, widthTemp] = pulse_param(rectParam, concavity);

    txtPulseParam = ['Resize the rectangle or click it. Width = ', num2str(widthTemp, 3), ...
        ' and Extreme point = (', num2str( extremePointTemp(1), 3), ', ', num2str( extremePointTemp(2), 3), ')'];

    title(haxes, txtPulseParam)
end


function method = get_method(iMethod)

    switch iMethod
        case 1
            method = 'spline';
        case 2
            method = 'nearest';
        case 3
            method = 'linear';
    end
end