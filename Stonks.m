%Program to display stock portfolio, note that the first 2 numbers in the
%data must be the number of rows and then the number of columns.
%Note that if you have a choice, it is probably better to ammend your
%current portfolio yourself in the txt file, as you can change multiple
%things at once.
% overall = categorical(category);
% ourtable = table(category, ticker, value);
fprintf('Note: Use '' '' when entering your values on lines preceeded by a !\n');
nameoffile = input('! Enter the name of the file: ');
data = fopen(nameoffile,'r');
nrowcol = fscanf(data,'%d',[1,2]);%row is the first, cols is the second
ourcell = cell(nrowcol);
fgetl(data);
for i = 1:nrowcol(1)
    line = fgetl(data);
    line = strsplit(line);
    ourcell(i,:) = line;
end

fprintf('What would you like to do today?\nCurrent options:\n');
fprintf('1: View current data\n');
fprintf('2: Modify current data\n');
fprintf('3: Display a chart\n');
choice = input('Select an option: ');

switch choice
    case 1%Finished and functional
        disp(nrowcol);
        disp(ourcell);
    case 2%Works fine
        fprintf('Your choices are:\n');
        fprintf('1: Modify a current entry\n');
        fprintf('2: Add new entry\n')
        newchoice = input('Select an option: ');
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
                ourcell{line+1,m} = newval;
                ourdate = string(clock);
                ourdate = strcat(ourdate(1),'-',ourdate(2),'-',ourdate(3),'_',ourdate(4),'-',ourdate(5),'.txt');
                fprintf('Your new data is named %s\n',ourdate);
                output = fopen(char(ourdate),'w');
                fprintf(output,'%d %d\n',nrowcol(1),nrowcol(2));
                for k = 1:nrowcol(1)
                    fprintf(output,'%s ',ourcell{k,:});
                    fprintf(output,'\n');
                end
                fclose(output);
            case 2%Add new: Finished and functional
                newentry = cell(1,nrowcol(2));
                fprintf('! Type the values for the given category\n');
                newentry(1) = {char(num2str(nrowcol(1)+1))};
                for j = 2:nrowcol(2)
                    fprintf('%s:',ourcell{1,j});
                    entry = input(' ');
                    newentry{j} = entry;
                end
                ourdate = string(clock);
                ourdate = strcat(ourdate(1),'-',ourdate(2),'-',ourdate(3),'_',ourdate(4),'-',ourdate(5),'.txt');
                fprintf('Your new data is named %s\n',ourdate);
                output = fopen(char(ourdate),'w');
                fprintf(output,'%d %d\n',nrowcol(1)+1,nrowcol(2));
                for k = 1:nrowcol(1)
                    fprintf(output,'%s ',ourcell{k,:});
                    fprintf(output,'\n');
                end
                fprintf(output,'%s ',newentry{1,:});
                fclose(output);
            otherwise
                fprintf('I couldn''t understand that. Exiting...\n');
        end
    case 3
        fprintf('Choose one of the following:\n');
        fprintf('1: Selecting a category\n');
        fprintf('2: Filtering out a category\n');
        fprintf('3: Everything else\n');
        newerchoice = input('Make a choice ');
        disp(ourcell);
        switch newerchoice
            case 1%Works great
                cat = input('! Type a category you want to graph: ');
                newcell = ourcell;
                newcell(1,:) = [];%obliterates the labels
                for p = 1:nrowcol(2)
                    if ~isempty(nonzeros(string(newcell(:,p)) == string(cat)))%this bad boy is true if the cat is in the column
                        break;
                    end
                end
                a = (string(newcell(:,p))==string(cat)).*str2double(newcell(:,nrowcol(2)));%produces an array. If the value is 0, remove it
                a = [a string(newcell(:,nrowcol(2)-1))];
                for r = nrowcol(1)-1:-1:1
                    if a(r,1) == "0"
                        a(r,:) = [];
                    end
                end
                g = pie(str2double(a(:,1)'));
                %manipulating the graph
                newsize = size(a);
                colonspace = cell(1,newsize(1));
                for w = 1:newsize(1)
                    colonspace(w) = {': '};
                end
                pText = findobj(g,'Type','text');
                percents = get(pText,'String');%ideally, this should allow the names to appear with the %
                combine = strcat(a(:,2),string(colonspace)',percents);
                for w = 1:newsize(1)
                    pText(w).String = combine(w);
                end
                title(cat);
                
            case 2
                cat = input('! Type a category you want to filter out: ');
                newcell = ourcell;
                newcell(1,:) = [];%obliterates the labels
                for p = 1:nrowcol(2)
                    if ~isempty(nonzeros(string(newcell(:,p)) == string(cat)))%this bad boy is true if the cat is in the column
                        break;
                    end
                end
                a = (~(string(newcell(:,p))==string(cat))).*str2double(newcell(:,nrowcol(2)));%produces an array. If the value is 0, remove it
                a = [a string(newcell(:,nrowcol(2)-1))];
                for r = nrowcol(1)-1:-1:1
                    if a(r,1) == "0"
                        a(r,:) = [];
                    end
                end
                g = pie(str2double(a(:,1)'));
                %manipulating the graph
                newsize = size(a);
                colonspace = cell(1,newsize(1));
                for w = 1:newsize(1)
                    colonspace(w) = {': '};
                end
                pText = findobj(g,'Type','text');
                percents = get(pText,'String');%ideally, this should allow the names to appear with the %
                combine = strcat(a(:,2),string(colonspace)',percents);
                for w = 1:newsize(1)
                    pText(w).String = combine(w);
                end
                newtitle = strcat("Not ",cat);
                title(newtitle);
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
                %now on to graphing
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
                fprintf('I couldn''t understand that. Exiting...\n');
        end
    otherwise
        fprintf('I couldn''t understand that. Exiting...\n');
end
fclose(data);
return;