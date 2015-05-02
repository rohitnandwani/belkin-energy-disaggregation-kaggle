function fileList = getAllFiles(dirName, search_str)
% GETALLFILES Returs a list of all files in the given directory with
%  regex search_str filter. Example of a search_str = 'hello_\w*' will get
% all files of the name 'hello_*.*'

    % Get all file names under the specified folder & subfolders
    myfiles = traverseDir(dirName);
    % Filter the file list
    fileList = cell(0);  % Intialize the cell array
    for i=1:length(myfiles)
        filename = myfiles{i,1};
        %Extract file name from full path
        [~, fname, ext] = fileparts(filename);
        % Build full filename with ext against which we test regex filter
        fname = [fname ext];
        X =  regexp(fname, search_str, 'once');
        if ~isempty(X)>0
            %disp(filename);
            fileList{end+1} = filename;            
        end
        %celldisp(X);
    end
end