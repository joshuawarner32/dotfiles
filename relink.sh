cd $(dirname "${BASH_SOURCE[0]}")
dir=$(pwd)
git pull
files=".bash_profile .bash_aliases"
for x in ${files}; do
    ln -is ${dir}/$x ${HOME}/$x
done

wget https://raw.github.com/nojhan/liquidprompt/master/liquidprompt -O ~/liquidprompt