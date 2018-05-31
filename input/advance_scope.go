/*
 * We check the value which depends on your symbol table dump function.
 * Your symbol table needs to record the scope depth.
 */
var x int = 10
var y int = 5
{
	x++
	var x int = 5
	x = x + 5
	println(x)
}

println(x)

{
	x++
	println(x)
}

println(x)
