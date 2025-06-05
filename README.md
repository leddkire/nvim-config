# nvim-config

## Python - nginx lsp
1. Install pyenv and pyenv-venv
2. pyenv install 3.7
3. pyenv virtualenv 3.7.17 py3nvim_3_7_17
4. pyenv activate py3nvim_3_7_17
5. python3 -m pip install pynvim
6. pyenv which <-- copy result and add to nvim init.lua like in the example below
7. pim.g.python3_host_prog = '/usr/local/var/pyenv/versions/py3nvim_3_7_17/bin/python'
8. pyenv global 3.7.17 <-- sets global version as well for Lazy and Mason to work
