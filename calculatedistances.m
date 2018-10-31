function [ds_sameperson2d,ds_diffperson2d] = calculatedistances()
%CALCULATEDISTANCES 

% workspace in workspacepartialdistances.mat

% distances 49 distances between same person, using 32 intbit and 32
% fracbit
% distances 50 distances between diff person, using 32 intbit and 32
% fracbit
% ds_diffperson32 stores 4, 8, 12, ... intbit and 32 fracbit

%d32_sameperson contains distances between same person for intbit = 1:32
%and fracbit = 32
n_bands=8;
h_bands=20;
n_arcs=1;
h_radius=12;
h_lato=h_radius+(n_bands*h_bands*2)+16;
if mod(h_lato,2)==0
    h_lato=h_lato-1;
end
n_sectors=n_bands*n_arcs;
matrice=zeros(h_lato);
for ii=1:(h_lato*h_lato)
    matrice(ii)=whichsector(ii);
end
num_disk=2;

database = 'fp_database3.dat'

myFolder = '/home/taeyun/Desktop/Homomorphic_Encryption/HomFingerPrintAuth/fp_tobeverified';
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, 's*.bmp'); % Change to whatever pattern you need.

% myFolder = '/home/taeyun/Desktop/Homomorphic_Encryption/HomFingerPrintAuth/processed_fp';
% % Get a list of all files in the folder with the desired file name pattern.
% filePattern = fullfile(myFolder, 'f*.bmp'); % Change to whatever pattern you need.

theFiles = dir(filePattern);

% how many number of bits to be tested
numbitstotest = 32;


for i=4:4:28
    for j = 2:7
        if j == 4
            continue
        end
        % number of bits to represent double
        intbit = j;
        fracbit = i;
        intbitarray(1:num_disk*n_sectors,1:1) = intbit;
        fracbitarray(1:num_disk*n_sectors,1:1) = fracbit;
        %

        %calculate distances for different person
        d_diffperson = zeros(length(theFiles), 1);
        for k = 1 : (length(theFiles))
            baseFileName = theFiles(k).name;
            fullFileName = strcat(theFiles(k).folder, '/', baseFileName);
            %fullFileName = fullfile(myFolder, baseFileName);
            % Now do whatever you want with this file name,
            % such as reading it in as an image array with imread()
            [img,map] = imread(fullFileName);
            immagine=double(img);

            if isa(img,'uint8')
                graylevmax=2^8-1;
            end
            if isa(img,'uint16')
                graylevmax=2^16-1;
            end
            if isa(img,'uint32')
                graylevmax=2^32-1;
            end
            fingerprint = immagine;

            N=h_lato;

            [BinarizedPrint,XofCenter,YofCenter]=centralizing(fingerprint,0);
            [CroppedPrint]=cropping(XofCenter,YofCenter,fingerprint);
            [NormalizedPrint,vector]=sector_norm(CroppedPrint,0);

            % memoria per feature vector d'ingresso
            vettore_in=zeros(num_disk*n_sectors,1);
            for (angle=0:1:num_disk-1)
                gabor=gabor2d_sub(angle,num_disk);
                ComponentPrint=conv2fft(NormalizedPrint,gabor,'same');
                [disk,vector]=sector_norm(ComponentPrint,1);
                finger_code{angle+1}=vector(1:n_sectors);
                vettore_in(angle*n_sectors+1:(angle+1)*n_sectors)=finger_code{angle+1};
            end



            % FingerCode of input fingerprint has just been calculated.
            % Checking with DataBase
            if (exist(database)==2)
                load(database,'-mat');
                %---- alloco memoria -----------------------------------
                %...
                vettore_a=zeros(num_disk*n_sectors,1);
                vettore_b=zeros(num_disk*n_sectors,1);
                %best_matching=zeros(fp_number,1);
                best_matching=zeros(1,1);
                valori_rotazione=zeros(n_arcs,1);
                % start checking ---------------------------------------

                % randomly choose other fingerprint
                a = 1;
                b = length(theFiles);

                while true
                    r = round((b-a).*rand(1,1) + a);
                    if (r ~= k)
                        break
                    end
                end

                fcode1=data{r,1};
                fcode2=data{r,2};
                for rotazione=0:(n_arcs-1)
                    p1=fcode1;
                    p2=fcode2;
                    % ruoto i valori dentro disco
                    for conta_disco=1:num_disk
                        disco1=p1{conta_disco};
                        disco2=p2{conta_disco};
                        for old_pos=1:n_arcs
                            new_pos=mod(old_pos+rotazione,n_arcs);
                            if new_pos==0
                                new_pos=n_arcs;
                            end
                            for conta_bande=0:1:(n_bands-1)
                                disco1r(new_pos+conta_bande*n_arcs)=disco1(old_pos+conta_bande*n_arcs);
                                disco2r(new_pos+conta_bande*n_arcs)=disco2(old_pos+conta_bande*n_arcs);
                            end
                        end
                        p1{conta_disco}=disco1r;
                        p2{conta_disco}=disco2r;
                    end
                    % ruoto i dischi circolarmente
                    for old_disk=1:num_disk
                        new_disk=mod(old_disk+rotazione,num_disk);
                        if new_disk==0
                            new_disk=num_disk;
                        end
                        pos=old_disk-1;
                        vettore_a(pos*n_sectors+1:(pos+1)*n_sectors)=p1{new_disk};
                        vettore_b(pos*n_sectors+1:(pos+1)*n_sectors)=p2{new_disk};
                    end

                    %
        %                     intva = int32(vettore_a);
        %                     intvb = int32(vettore_b);
        %                     intvi = int32(vettore_in);
        %                     
                    %calculate 1 norm using encrypted vectors
                    %d1 = encryptedDistance(intva, intvi);
                    %d2 = encryptedDistance(intvb, intvi);
                    %
        %                     
        % %                     
                    vettore_a = arrayfun(@reducedoublebits, vettore_a, intbitarray, fracbitarray); 
                    vettore_b = arrayfun(@reducedoublebits, vettore_b, intbitarray, fracbitarray); 
                    vettore_in = arrayfun(@reducedoublebits, vettore_in, intbitarray, fracbitarray); 
                    d1=norm(vettore_a-vettore_in);
                    d2=norm(vettore_b-vettore_in);

        %                     d1=sqrt(sum((intva-intvi).^2));
        %                     d2=sqrt(sum((intvb-intvi).^2));

        %                     d1 = sum(abs(intva-intvi));
        %                     d2 = sum(abs(intvb-intvi));
                    if d1<d2
                        val_minimo=d1;
                    else
                        val_minimo=d2;
                    end
                    valori_rotazione(rotazione+1)=val_minimo;
                end
                [minimo,posizione_minimo]=min(valori_rotazione);
                best_matching(1)=minimo;

                [distanza_minima,posizione_minimo]=min(best_matching);
                beep;
                %message=strcat('distance between ', num2str(k),'th fingerprints : ',num2str(distanza_minima));
                %msgbox(message,'DataBase Info','help');
                %disp(message);
                d_diffperson(k) = distanza_minima;
            else
                message='DataBase is empty. No check is possible.';
                msgbox(message,'FingerCode DataBase Error','warn');
            end

        end

        % calculate distances for the same person
        d_sameperson = zeros(length(theFiles), 1);
        for k = 1 : length(theFiles)
            baseFileName = theFiles(k).name;
            fullFileName = strcat(theFiles(k).folder, '/', baseFileName);
            %fullFileName = fullfile(myFolder, baseFileName);
            % Now do whatever you want with this file name,
            % such as reading it in as an image array with imread()
            [img,map] = imread(fullFileName);
            immagine=double(img);

            if isa(img,'uint8')
                graylevmax=2^8-1;
            end
            if isa(img,'uint16')
                graylevmax=2^16-1;
            end
            if isa(img,'uint32')
                graylevmax=2^32-1;
            end
            fingerprint = immagine;

            N=h_lato;

            [BinarizedPrint,XofCenter,YofCenter]=centralizing(fingerprint,0);
            [CroppedPrint]=cropping(XofCenter,YofCenter,fingerprint);
            [NormalizedPrint,vector]=sector_norm(CroppedPrint,0);

            % memoria per feature vector d'ingresso
            vettore_in=zeros(num_disk*n_sectors,1);
            for (angle=0:1:num_disk-1)
                gabor=gabor2d_sub(angle,num_disk);
                ComponentPrint=conv2fft(NormalizedPrint,gabor,'same');
                [disk,vector]=sector_norm(ComponentPrint,1);
                finger_code{angle+1}=vector(1:n_sectors);
                vettore_in(angle*n_sectors+1:(angle+1)*n_sectors)=finger_code{angle+1};
            end



            % FingerCode of input fingerprint has just been calculated.
            % Checking with DataBase
            if (exist(database)==2)
                load(database,'-mat');
                %---- alloco memoria -----------------------------------
                %...
                vettore_a=zeros(num_disk*n_sectors,1);
                vettore_b=zeros(num_disk*n_sectors,1);
                %best_matching=zeros(fp_number,1);
                best_matching=zeros(1,1);
                valori_rotazione=zeros(n_arcs,1);
                % start checking ---------------------------------------

                fcode1=data{k,1};
                fcode2=data{k,2};
                for rotazione=0:(n_arcs-1)
                    p1=fcode1;
                    p2=fcode2;
                    % ruoto i valori dentro disco
                    for conta_disco=1:num_disk
                        disco1=p1{conta_disco};
                        disco2=p2{conta_disco};
                        for old_pos=1:n_arcs
                            new_pos=mod(old_pos+rotazione,n_arcs);
                            if new_pos==0
                                new_pos=n_arcs;
                            end
                            for conta_bande=0:1:(n_bands-1)
                                disco1r(new_pos+conta_bande*n_arcs)=disco1(old_pos+conta_bande*n_arcs);
                                disco2r(new_pos+conta_bande*n_arcs)=disco2(old_pos+conta_bande*n_arcs);
                            end
                        end
                        p1{conta_disco}=disco1r;
                        p2{conta_disco}=disco2r;
                    end
                    % ruoto i dischi circolarmente
                    for old_disk=1:num_disk
                        new_disk=mod(old_disk+rotazione,num_disk);
                        if new_disk==0
                            new_disk=num_disk;
                        end
                        pos=old_disk-1;
                        vettore_a(pos*n_sectors+1:(pos+1)*n_sectors)=p1{new_disk};
                        vettore_b(pos*n_sectors+1:(pos+1)*n_sectors)=p2{new_disk};
                    end
                    vettore_a = arrayfun(@reducedoublebits, vettore_a, intbitarray, fracbitarray); 
                    vettore_b = arrayfun(@reducedoublebits, vettore_b, intbitarray, fracbitarray); 
                    vettore_in = arrayfun(@reducedoublebits, vettore_in, intbitarray, fracbitarray); 
                    d1=norm(vettore_a-vettore_in);
                    d2=norm(vettore_b-vettore_in);

                    if d1<d2
                        val_minimo=d1;
                    else
                        val_minimo=d2;
                    end
                    valori_rotazione(rotazione+1)=val_minimo;
                end
                [minimo,posizione_minimo]=min(valori_rotazione);
                best_matching(1)=minimo;

                [distanza_minima,posizione_minimo]=min(best_matching);
                beep;
                d_sameperson(k) = distanza_minima;
            else
                message='DataBase is empty. No check is possible.';
                msgbox(message,'FingerCode DataBase Error','warn');
            end
        end

        ds_diffperson2d{j,i} = d_diffperson;
        ds_sameperson2d{j,i} = d_sameperson;
    end
    
end

end

