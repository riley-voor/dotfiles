" Allow saving of files as sudo when you forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
