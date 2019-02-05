% Get all PDF files in the current folder
files = dir('*.jpg');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(id).name);
      name=strcat(f(1:16),f(20:end),'.jpg');
      movefile(files(id).name, name);
end