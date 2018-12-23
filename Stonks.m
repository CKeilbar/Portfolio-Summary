%Program to display stock portfolio, note that the first 2 numbers in the
%data must be the number of rows and then the number of columns.
%Input file cannot have spaces after lines.
%Note that if you have a choice, it is probably better to ammend your
%current portfolio yourself in the txt file, as you can change multiple
%things at once.
%This program cannot handle poorly entred input, be gentle.
fprintf('Note: Use '' '' or " " when entering your values on lines starting with !\n');
nameoffile = input('! Enter the name of the file containg your portfolio: ');
data = fopen(nameoffile,'r');
nrowcol = fscanf(data,'%d',[1,2]);%row is the first, cols is the second
ourcell = cell(nrowcol);
fgetl(data);
for i = 1:nrowcol(1)
    line = fgetl(data);
    line = strsplit(line);
    ourcell(i,:) = line;
end
while true
fprintf('\nWhat would you like to do today?\nCurrent options:\n');
fprintf('1: View current data\n');
fprintf('2: Modify current data\n');
fprintf('3: Display a chart\n');
fprintf('4: Exit\n')
choice = input('Select an option: ');
fprintf('\n');
switch choice
    case 1%Finished and functional
        disp(nrowcol);
        disp(ourcell);
    case 2%Works fine
        fprintf('Your choices are:\n');
        fprintf('1: Modify a current entry\n');
        fprintf('2: Add new entry\n');
        fprintf('3: Delete an entry\n');
        newchoice = input('Select an option: ');
        fprintf('\n');
        switch newchoice
            case 1%Ammend, works fine
                disp(ourcell);
                line = input('Which line would you like to modify? ');
                disp(ourcell(line+1,:));
                modify = input('! Which value would you like to change? Enter the current value: ');
                for m = 1:nrowcol(2)%This finds which category needs to be ammended
                    if string(cell2mat(ourcell(line+1,m)))==string(modify)
                        break
                    end
                end
                newval = input('! Enter the new value: ');
                ourcell{line+1,m} = char(newval);%Maybe neccessary for the exe version (char)
                choice2 = input('! Enter the new file name, or type ''date'' to generate a name based on the date and time: ');
                if (string(choice2) == "date")
                    ourdate = string(clock);
                    ourdate = strcat(ourdate(1),'-',ourdate(2),'-',ourdate(3),'_',ourdate(4),'-',ourdate(5),'.txt');
                else
                    ourdate = string(choice2);
                end
                fprintf('Your new data is named %s\n\n',ourdate);
                output = fopen(char(ourdate),'w');
                fprintf(output,'%d %d\n',nrowcol(1),nrowcol(2));
                for k = 1:nrowcol(1)
                    fprintf(output,'%s ',ourcell{k,:});
                    fseek(output,-1,'cof');%If we read from this file again, the spaces produced above screw with it
                    fprintf(output,'\n');%This way, we sneak in a \n before the space, resulting in functional behaviour
                end
                fclose(output);
            case 2%does not work/print properly
                newentry = cell(1,nrowcol(2));
                fprintf('Type the values for the given category\n');
                ourcell(nrowcol(1)+1,1) = {char(num2str(nrowcol(1)+1))};
                for j = 2:nrowcol(2)
                    fprintf('! %s:',ourcell{1,j});
                    entry = input(' ');
                    ourcell(nrowcol(1)+1,j) = {char(entry)};
                end
                choice2 = input('! Enter the new file name, or type ''date'' to generate a name based on the date and time: ');
                if (string(choice2) == "date")
                    ourdate = string(clock);
                    ourdate = strcat(ourdate(1),'-',ourdate(2),'-',ourdate(3),'_',ourdate(4),'-',ourdate(5),'.txt');
                else
                    ourdate = string(choice2);
                end
                fprintf('Your new data is named %s\n\n',ourdate);
                output = fopen(char(ourdate),'w');
                nrowcol(1) = nrowcol(1)+1;
                fprintf(output,'%d %d\n',nrowcol(1),nrowcol(2));
                for k = 1:nrowcol(1)
                    fprintf(output,'%s ',ourcell{k,:});
                    fseek(output,-1,'cof');%If we read from this file again, the spaces produced above screw with it
                    fprintf(output,'\n');%This way, we sneak in a \n before the space, resulting in functional behaviour
                end
                fprintf(output,'%s',newentry{1,:});
                fclose(output);
            case 3
                disp(ourcell);
                deletedline = input('Which line would you like to remove? ');
                for m = nrowcol(1):-1:deletedline+1
                    ourcell{m,1} = num2str(str2double(ourcell(m,1))-1);
                end
                ourcell(deletedline+1,:) = [];
                choice2 = input('! Enter the new file name, or type ''date'' to generate a name based on the date and time: ');
                if (string(choice2) == "date")
                    ourdate = string(clock);
                    ourdate = strcat(ourdate(1),'-',ourdate(2),'-',ourdate(3),'_',ourdate(4),'-',ourdate(5),'.txt');
                else
                    ourdate = string(choice2);
                end
                fprintf('Your new data is named %s\n\n',ourdate);
                output = fopen(char(ourdate),'w');
                nrowcol(1) = nrowcol(1)-1;
                fprintf(output,'%d %d\n',nrowcol(1),nrowcol(2));
                for k = 1:nrowcol(1)-1
                    fprintf(output,'%s ',ourcell{k,:});
                    fseek(output,-1,'cof');%If we read from this file again, the spaces produced above screw with it
                    fprintf(output,'\n');%This way, we sneak in a \n before the space, resulting in functional behaviour
                end
            otherwise
                fprintf('I couldn''t understand that. Try again\n\n');
        end
    case 3
        fprintf('Choose one of the following:\n');
        fprintf('1: Printing a column\n');
        fprintf('2: Category filtering\n');
        fprintf('3: Navigating the table\n');
        newerchoice = input('Make a choice ');
        disp(ourcell);
        switch newerchoice
            case 1
                sizes = size(ourcell);
                selections = ourcell;
                selections(1,:) = [];
                col = input('! Type the name of the column to display: ');
                for v1 = 1:sizes(2)
                    if string(col) == string(ourcell(1,v1))
                        break;
                    end
                end
                options = categories(categorical(selections(:,v1)));
                soptions = size(options);
                sums4opt = zeros(soptions(1),1);
                for p = 1:sizes(1)-1
                    for z = 1:soptions(1)
                        if string(options(z)) == string(selections(p,v1))
                            sums4opt(z) = sums4opt(z) + str2double(cell2mat(selections(p,sizes(2))));
                        end
                    end
                end
                g = pie(sums4opt);
                %manipulating the graph
                colonspace = cell(1,soptions(1));
                for w = 1:soptions(1)
                    colonspace(w) = {': '};
                end
                pText = findobj(g,'Type','text');
                percents = get(pText,'String');%ideally, this should allow the names to appear with the %
                combine = strcat(options(:),string(colonspace)',percents);
                for w = 1:soptions(1)
                    pText(w).String = combine(w);
                end
                title(string(ourcell(1,v1)));
            case 2%group same tickers done
                selections = ourcell;
                selections(1,:) = [];
                sizes = size(selections);
                fprintf('Sample input looks like: ''Canada !Stock Telecom'', where ! represents negation.\n');
                wholething = input('! Enter a list of types you want to inlude/disclude.\n');
                keys = strsplit(wholething);
                allowedvals = true(sizes(1),1);
                for qq = 1:length(keys)
                  temp = char(keys(qq));
                  if temp(1) == '!'
                      vals = (string(selections) == string(temp(2:length(temp))));
                      [x,y] = find(vals);
                      vals(:,y(1)) = ~vals(:,y(1));
                  else
                      vals = (string(selections) == string(temp));
                      [x,y] = find(vals);
                  end
                allowedvals = (allowedvals & vals(:,y(1)));
                end%At this point we have the rows that fit the given criteria
                a = (allowedvals.*str2double(selections(:,nrowcol(2))));%produces an array. If the value is 0, remove it
                a = [a string(selections(:,nrowcol(2)-1))];
                for r = nrowcol(1)-1:-1:1
                    if a(r,1) == "0"
                        a(r,:) = [];
                    end
                end
                if isempty(a)
                    fprintf('Nothing fits the given criteria.\n\n')
                    clearvars
                end
                options = categories(categorical(a(:,2)));
                soptions = size(options);
                sizea = size(a);
                sums4opt = zeros(soptions(1),1);
                for p = 1:sizea(1)
                    for z = 1:soptions(1)
                        if string(options(z)) == string(a(p,2))
                            sums4opt(z) = sums4opt(z) + str2double(cell2mat(selections(p,sizes(2))));
                        end
                    end
                end
                g = pie(sums4opt);
                colonspace = cell(1,soptions(1));
                for w = 1:soptions(1)
                    colonspace(w) = {': '};
                end
                pText = findobj(g,'Type','text');
                percents = get(pText,'String');%ideally, this should allow the names to appear with the %
                combine = strcat(options(:),string(colonspace)',percents);
                for w = 1:soptions(1)
                    pText(w).String = combine(w);
                end
                title(wholething);
            case 3
                selections = ourcell;
                selections(1,:) = [];
                for v = 2:nrowcol(2)
                    sizes = size(selections);
                    options = categories(categorical(selections(:,v)));
                    fprintf('Category %d: %s\n',v,string(ourcell(1,v)));
                    fprintf('Type ''print'' to print these selections, or choose another category\n');
                    fprintf('%s\n',string(options));
                    choix = input('! Enter your choice: ');
                    if string(choix) == "print"
                        break
                    end
                    for u = sizes(1):-1:1
                        if(string(choix) ~= string(selections(u,v)))
                            selections(u,:) = [];
                        end
                    end
                end
                %here we print/pie our selections, based on the next categories
                soptions = size(options);
                sums4opt = zeros(soptions(1),1);
                for p = 1:sizes(1)
                    for z = 1:soptions(1)
                        if string(options(z)) == string(selections(p,v))
                            sums4opt(z) = sums4opt(z) + str2double(cell2mat(selections(p,sizes(2))));
                        end
                    end
                end
                g = pie(sums4opt);
                %manipulating the graph
                colonspace = cell(1,soptions(1));
                for w = 1:soptions(1)
                    colonspace(w) = {': '};
                end
                pText = findobj(g,'Type','text');
                percents = get(pText,'String');%ideally, this should allow the names to appear with the %
                combine = strcat(options(:),string(colonspace)',percents);
                for w = 1:soptions(1)
                    pText(w).String = combine(w);
                end
                title(string(ourcell(1,v)));
            otherwise
                fprintf('I couldn''t understand that. Try again.\n\n');
        end
    case 4
        fprintf('Program terminated. Have a nice day!\n');
        break;
    otherwise
        fprintf('I couldn''t understand that. Try again.\n\n');
end
clearvars -except ourcell nrowcol data;
end
fclose(data);
clearvars;
return;
