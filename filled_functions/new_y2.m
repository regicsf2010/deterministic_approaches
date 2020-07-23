% Criado por Gilvan Soares Borges em 30/07/2015.
% 
%        Deforma graficamente a função 'Y(X)' adicionando um único pulso de
% deformação com o arrasto do mouse. Basta dar dois clicks com o mouse em 
% algum ponto do gráfico, arrastar e soltar formando um retângulo. Através 
% da posição e dimensões desse retângulo, automaticamente é definido o 
% pulso. 
%        O pulso pode ser redimensionado ao redimensionar o retângulo. Para 
% mudar o formato do pulso basta redimensionar o retângulo sem mudar os 
% parâmetros do pulso (largura "width" e a posição de pico "extremePoint"). 
% Para finalizar basta clicar dentro da área do retângulo sem redimensioná-
% lo.
% 
% 
% SINTAX:
%
% -> [newY, extremePoint, width, method] = new_y2(haxes, method0); 
%        Nessa sintax, new_y2 deforma a curva associada ao handle axes 
% passado como argumento de entrada (pelo identificador "haxes"), e retorna 
% a função deformada "newY" e as características do pulso de deformação 
% ("width", "extremePoint" e "method"). Essa sintax é apropriada para usar 
% de forma recursiva.
%        A variável de entrada "method0" é uma string que define o formato 
% do pulso, podendo ser 'spline', 'nearest' e 'linear'. Como este pode 
% mudar ao longo da execução, new_y2 retorna a variável "method", que 
% contém o formato final do pulso escolhido pelo usuário.
% 
% -> [..., haxes] = new_y2(X, Y, method0); 
%        Nessa sintax, new_y2 deforma a curva associada aos vetores X e Y, 
% e retorna, além das variáveis da sintax anterior, o identificador "haxes" 
% para o handle axes da figura criada internamente e que tem associada a 
% curva deformada. Essa sintax é indicada para a primeira chamada da função 
% new_y2, antes de usá-la recursivamente.
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

    [haxes, hcurve, iMethod] = treat_input_data(nargout, varargin);        % Trata os dados de entrada e evita inconsistências.
    
    title(haxes, 'Drag a rectangle in the graphic area.')

    X = get(hcurve,'XData'); Y = get(hcurve,'YData');

    hrect = imrect(haxes);                                                 % CRIA UM OBJETO RETÂNGULO COM O ARRASTO DO MOUSE, QUE VAI SER ASSOCIADO A UM PULSO DE DEFORMAÇÃO.

    concavity = concav(hrect, X, Y);                                       % Identifica se o pulso vai ser um morro ou um vale.
      
    show_pulse_param(haxes, getPosition(hrect), concavity)                 % Mostra informações sobre o pulso no título da figura.

    while 1
        rectParam = getPosition(hrect);
        [extremePoint, width] = pulse_param(rectParam, concavity);         % Retorna a largura e a posição de pico do pulso.
        method = get_method(iMethod);                                      % Define o formato do pulso.

        newY = new_y(X, Y, extremePoint, width, method);                   % DEFORMA A FUNÇÃO Y(X) com o pulso  já definido.
        set(hcurve,'YData', newY)

        addNewPositionCallback(hrect, ...                                  % Mostra informações sobre o pulso, continuamente, a cada redimensionamento do retângulo.
            @(rectParam) show_pulse_param(haxes, rectParam, concavity)); 

        waitfor(gcf,'WindowButtonMotionFcn')                               % Interrompe a execução do programa até houver cliks do mouse no retângulo, para o usuário poder redimensionar o pulso.
        waitfor(gcf,'WindowButtonMotionFcn')                               % É necessário duas interrupções seguidas para poder redimensionar o pulso sem o programa continuar a execução.

        rectParamTemp = getPosition(hrect);
        [extremePointTemp, widthTemp] = pulse_param(rectParamTemp, concavity);

        if isequal(rectParamTemp, rectParam)                               % Finaliza se houve clicks do mouse no retângulo, sem redimensiona-lo.
            break

        elseif isequal([extremePointTemp widthTemp], [extremePoint width]) % Muda o formato do pulso se o retângulo foi redimensionado, sem redimensionar o pulso.
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