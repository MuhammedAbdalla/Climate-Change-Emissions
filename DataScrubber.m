function DataScrubber()
    fclose('all');
    clc
    clear
    YEAR = 1949;
    Consumption_scrub(YEAR);
    Electricity_scrub(YEAR)
    Renewable_scrub(YEAR);
    RegressionData(YEAR);
    fclose('all');
end

function Consumption_scrub(YEAR)
    save Data/CO2.csv
    save Data/CO2FULL.csv
    save Data/Energy.csv
    infile = fopen('Data/Consumption_Energy.csv','r'); %contains Total Energy consumption BTU & CO2 emissions gigatons
    outfileCO2 = fopen('Data/CO2.csv','w');
    outfileEnergy = fopen('Data/Energy.csv','w');
    if (infile ~= -1)
        aline = fgetl(infile);      
        while (aline ~= -1) 
            %"MSN","YYYYMM","Value","Column_Order","Description","Unit"
            linesplit = strsplit(aline,",");
            if (str2double(linesplit{4}) == 1 && str2double(linesplit{2}(1:end-2)) >= YEAR)
                fprintf(outfileEnergy,'%s,%.3f\n',linesplit{2}(1:end-2), str2double(linesplit{3})*1000);
            end
            if (str2double(linesplit{4}) == 8) && (str2double(linesplit{2}(1:end-2)) >= YEAR)
                fprintf(outfileCO2,'%s,%.3f\n', linesplit{2}(1:end-2), str2double(linesplit{3}));
            end
            aline = fgetl(infile);
        end
    end
end

function Electricity_scrub(YEAR)
    save Data/Electricity.csv
    infile = fopen('Data/Electricity_Generation.csv','r'); %Contains Electricity in kWh
    outfileElectricity = fopen('Data/Electricity.csv','w');
    if (infile ~= -1)
        aline = fgetl(infile);      
        while (aline ~= -1) 
            %"MSN","YYYYMM","Value","Column_Order","Description","Unit"
            linesplit = strsplit(aline,",");
            if (str2double(linesplit{4}) == 4 && str2double(linesplit{2}(1:end-2)) >= YEAR)
                fprintf(outfileElectricity,'%s,%.3f\n',linesplit{2}(1:end-2), str2double(linesplit{3}));
            end
            aline = fgetl(infile);
        end
    end
end

function Renewable_scrub(YEAR)
    save Data/RenewableGen.csv
    save Data/RenewableCon.csv
    infile = fopen('Data/Renewable_Energy.csv','r'); %Contains Renewable Energy Consumption and Generation in BTU
    outfileGen = fopen('Data/RenewableGen.csv','w');
    outfileCon = fopen('Data/RenewableCon.csv','w');
    if (infile ~= -1)
        aline = fgetl(infile);      
        while (aline ~= -1) 
            %"MSN","YYYYMM","Value","Column_Order","Description","Unit"
            linesplit = strsplit(aline,",");
            if (str2double(linesplit{2}(end-1:end)) == 13)
                if (str2double(linesplit{4}) == 4 && str2double(linesplit{2}(1:end-2)) >= YEAR)
                    fprintf(outfileGen,'%s,%.3f\n',linesplit{2}(1:end-2), str2double(linesplit{3}));
                end
                if (str2double(linesplit{4}) == 13 && str2double(linesplit{2}(1:end-2)) >= YEAR)
                    fprintf(outfileCon,'%s,%.3f\n',linesplit{2}(1:end-2), str2double(linesplit{3}));
                end
            end
            aline = fgetl(infile);
        end
    end
end
function RegressionData(YEAR)
    save Data/RegData.csv
    RegData         =   fopen('Data/RegData.csv','w');
    TotalEnergy     =   textscan(fopen('Data/Energy.csv','r'),'%d,%f');
    RenewableEnergy =   textscan(fopen('Data/RenewableGen.csv','r'),'%d,%f');
    CO2             =   textscan(fopen('Data/CO2.csv','r'),'%d,%f');
    GlobalTemps     =   textscan(fopen('Data/Global_Temps.csv','r'),'%d,%f,%f');
    counter = 1;
    %fprintf(RegData,'Year,Total Energy,Renewable Energy,CO2,Global Temps\n');
    %Year,Total Energy,Renewable Energy,CO2,Global Temps
    while (counter < 2020 -  YEAR+1)
         fprintf(RegData,'%d,%f,%f,%f,%f\n',YEAR - 1 + counter,TotalEnergy{2}(counter),RenewableEnergy{2}(counter),CO2{2}(counter),GlobalTemps{2}(counter));
         counter = counter + 1;
    end
end