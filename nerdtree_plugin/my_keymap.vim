function! NERDTtreeAddBookmark(node)
	call a:node.bookmark(fnamemodify(a:node.path.str(), ':t'))
endf

function! NERDTtreeRemoveBookmark(node)
	call a:node.delete()
endf

call NERDTreeAddKeyMap({
	\ 'key': 'b',
	\ 'callback': 'NERDTtreeAddBookmark',
	\ 'quickhelpText': 'bookmark',
	\ 'scope': 'Node',
	\ })
call NERDTreeAddKeyMap({
	\ 'key': 'dd',
	\ 'callback': 'NERDTtreeRemoveBookmark',
	\ 'quickhelpText': 'remove bookmark',
	\ 'scope': 'Bookmark',
	\ })
