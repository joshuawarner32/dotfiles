function github -d "Clone a github repo into ~/src/github.com/<arg> (if not already cloned) and cd into it"
  if test -d {$HOME}/src/github.com/{$argv[1]}
  	cd {$HOME}/src/github.com/{$argv[1]}
  else
  	mkdir -p {$HOME}/src/github.com/(dirname {$argv[1]})
  	git clone git@github.com:{$argv[1]} {$HOME}/src/github.com/{$argv[1]}; \
  		or return 1
  	cd {$HOME}/src/github.com/{$argv[1]}
  end
  	
end
