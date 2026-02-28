retrying neovim config by reading around sources from kickstart, lazy docs and plugins, using $VIMRUNTIME/example_init.lua
Thinking of adding the following

- [x] gruvbox colorscheme
- [x] whichkey
    - [ ] for whichKey see how to go about adding dev icons, ideally something across the terminal would be great 
- [ ] completions
    - [ ] I want good autocompletions on what I am using for bash, go, python, c lang
- [ ] telescope
    - [x] installation done
    - [x] figure out how to scroll through results buffer and preview buffer
        - got confused between results and preview buffer mapped to values which feels comfortable
    - [x] add support for viewing through images
        - not satisfied but for now its okay IG, lets complete the others and come back to this one
- [ ] LSP functionality

- [ ] git fugitive or neovim equivalent
    - [x] setup gitsigns, with userful hunk movement and showing up of gitblame
        - for now this seems to be sufficient
        - This looks interesting https://github.com/tanvirtin/vgit.nvim, especially like the project wide diff view, and conflict management is also very good
    - [ ] not sure what fugitive might give so lets see, later
    - IG a good way to stage all the files and then commit would be great, IG lazyGit might be good idea for that, but I dont like lazygit feels like additionall workflow learning for something I can get via github or gitlab, which doesnt feel appealing, maybe good way to check things before pushing but again, I dont think I will be using the full power of that workflow right now
    - maybe its not additional learning, its just that I already have the tools for creating new branch, deleting going through stash etc, it just feels like lazy git too much for that, doing that in neovim feels appealing
    - the qflist seems near to what I need so yeah lazygit seems too much for what I need
- [ ] oil.nvim want to try this out
- [ ] image support
    - kitty seems plenty fast with image viewing, but image.nvim seems very slow in displaying the image in my terminal, lets see some videos if something can be done
