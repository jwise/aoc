items = {
"mutex",
"spool of cat6",
"hypercube",
"astronaut ice cream",
"boulder",
"antenna",
"sand",
"mouse"
}

function recur(i)
	if not items[i] then print("south") return  end
	print("take "..items[i])
	recur(i+1)
	print("drop "..items[i])
	recur(i+1)
end

recur(1)