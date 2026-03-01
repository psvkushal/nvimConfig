retrying neovim config by reading around sources from kickstart, lazy docs and plugins, using $VIMRUNTIME/example_init.lua
Thinking of adding the following

- [x] gruvbox colorscheme
    - [x] see if its possible to make the background darker in gruvbox as close to black as possible
        - did this but I think lets use it when I am bored of this one
- [x] whichkey
    - [ ] ~~for whichKey see how to go about adding dev icons, ideally something across the terminal would be great~~
        - For now lets do it via the standard mini dev icons or nvim dev icons lets ignore f
- [ ] completions
    - [x] I want good autocompletions on what I am using for bash, go, python, c lang
- [x] telescope
    - [x] installation done
    - [x] figure out how to scroll through results buffer and preview buffer
        - got confused between results and preview buffer mapped to values which feels comfortable
    - [x] add support for viewing through images
        - not satisfied but for now its okay IG, lets complete the others and come back to this one
    - mini.pick and fzf-lua (or fzf) seems to be the alternatives present for telescope
    - LOOK: Okay telescope has some git commands like bcommits etc, lets go through them when possible
    - removed telescope I think I should have just kept telescope without setting any keymaps to compare some features with snacks for now lets add it back
- [x] LSP functionality
- [ ] git fugitive or neovim equivalent
    - [x] setup gitsigns, with userful hunk movement and showing up of gitblame
        - for now this seems to be sufficient
        - This looks interesting https://github.com/tanvirtin/vgit.nvim, especially like the project wide diff view, and conflict management is also very good
    - [ ] not sure what fugitive might give so lets see, later
    - IG a good way to stage all the files and then commit would be great, IG lazyGit might be good idea for that, but I dont like lazygit feels like additionall workflow learning for something I can get via github or gitlab, which doesnt feel appealing, maybe good way to check things before pushing but again, I dont think I will be using the full power of that workflow right now
    - maybe its not additional learning, its just that I already have the tools for creating new branch, deleting going through stash etc, it just feels like lazy git too much for that, doing that in neovim feels appealing
    - the qflist seems near to what I need so yeah lazygit seems too much for what I need
- [x] image support
    - kitty seems plenty fast with image viewing, but image.nvim seems very slow in displaying the image in my terminal, lets see some videos if something can be done
    - [x] lets replace 3rd/image.nvim with snacks nvim, lets see if possible to install only images but its okay if I need to install all
        - yeah itseems to be loading faster or feels like loading faster
        - maybe I should just use snacks picker instead of telescope
- [x] I think folke has todo plugin or something related to it, I like how it highlights those words lets add it here

- For some reason I dont wanna install icon packs like mini or dev icons, but I dont know why
- add that K keyword  to hover documentation -> itseems already by default in neovim so not exactly required
- For now I am going to keep git fugitive aside

IG these are remaining
- [ ] Add nvim lua status line https://github.com/nvim-lualine/lualine.nvim -> gives helpful information on branches and other things 
- [ ] oil.nvim want to try this out

happy with lsp completion and having single config file, and how I was able to be comfortable with just writing the config, I dont think I will feel scared of installing new plugins now, atleast if they are single plugins and they are simple

unhappy with how I did lsp config, hopefully with nvim 0.12 a good way will be ironed out, I did not understand what I did so not so comfortable with it, and shortcuts related to LSP I dont understand where to go with it

Not exactly bad, but I would like to see a way where in quickfix list, when I am at a point in the cursor should move to that buffer, not sure how it will go, but feels that would be cool


side thoughts 
- think about using alt-h,j,k,l instead of <c-w>-h,j,k,l and similar operations <c-w> replace it with alt, <c-w>-> and <c-w>-< to increase and decrease the size of the window,
    - or maybe this is skill issue and I should just make my fingers stronger?
- the quickfixlist and loclist seems to be very old features of vim go through it once -> https://youtu.be/aKG9uR6LhX4
    - https://www.reddit.com/r/neovim/comments/17y0gnl/what_are_some_cooluseful_ways_you_guys_use/
    - https://www.reddit.com/r/neovim/comments/1o2aeoj/how_do_you_use_quickfix_list/
    - https://www.youtube.com/watch?v=AuXZA-xCv04
- How to setup floating window is interesting for me https://www.youtube.com/watch?v=7Kzv3wUHtyU
- https://github.com/bngarren/checkmate.nvim -> This checklist plugin looks interesting
- what is tags, tag stack in neovim
- why is LOOK: not rendering here in markdown files
- IG :h lsp-vs-treesitter where they talk about ctags and tags, I want to understand what i_CTRL-X_CTRL-] means, does it mean in insert mode, ctrl-x and ctrl-] ?
- hoping I will understand more by going through tj video https://youtu.be/m8C0Cq9Uv9o
