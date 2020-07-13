let s:pluginPath = expand('<sfile>:p:h') . '/..'

function! g:bash#complete(part)
	let l:spaceend = strcharpart(a:part, strchars(a:part) - 1) == ' '
	return systemlist(s:pluginPath . '/completer.sh ' . l:spaceend . ' ' . a:part)
endfunction
