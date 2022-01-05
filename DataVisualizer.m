function DataVisualizer()
    figure(1)
    plotEnergy();
    figure(2)
    plotCO2();
    figure(4)
    plotTemperature();
    fclose('all');
end

function plotEnergy()
    RenewableGen = textscan(fopen('Data/RenewableGen.csv'),'%d,%f');
    Energy = textscan(fopen('Data/Energy.csv'),'%d,%f');
    hold on
    plot(cell2mat(Energy(1)),cell2mat(Energy(2)),'r*');
    plot(cell2mat(RenewableGen(1)),cell2mat(RenewableGen(2)),'b*');
    hold off
    xlabel('Year');
    ylabel('Trillion BTU');
    title('Energy Production since 1980');
end

function plotTemperature()
    Temps = textscan(fopen('Data/Global_Temps.csv'),'%d,%f,%f');
    plot(cell2mat(Temps(1)),cell2mat(Temps(2)),'g*');
    xlabel('Year');
    ylabel('Degree Celsius');
    title('Global Temperature Anomaly');
end

function plotCO2()
    CO2 =  textscan(fopen('Data/CO2.csv'),'%f,%f');
    RegData = fscanf(fopen('Data/RegData.csv'),'%d,%f,%f,%f,%f\n',[5,inf])';
    plot(cell2mat(CO2(1)),cell2mat(CO2(2)),'k*');
    xlabel('Year');
    ylabel('Million Metric Tons CO2');
    title('Carbon Dioxide Production Per Year');
    figure(3);
    hold on
    plot(cell2mat(CO2(1)),cumsum(cell2mat(CO2(2))),'k-');
    xlabel('Year');
    ylabel('Millon Metric Tons CO2');
    title('Global Carbon Dioxide');
    %Year,Total Energy,Renewable Energy,CO2,Global Temps
    [trainedModel, validationRMSE] = trainRegressionModel(RegData);
    coeffsTE = polyfit(1949:2019,RegData(:,2),10);
    coeffsRE = polyfit(1949:2019,RegData(:,3),10);
    Y = 2019:2030;
    TE = polyval(coeffsTE,Y);
    RE = polyval(coeffsRE,Y);
    FutureCO2 = trainedModel.predictFcn([Y', TE', RE']);
    Offset = sum(RegData(:,4));
    plot(Y,cumsum(FutureCO2) + Offset,'r--');
    
end

